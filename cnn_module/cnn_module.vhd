
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity system is
  generic (
    WORDSIZE     : integer := 16;
    WINDOWSIZE   : integer := 5;
    ADDRESS_SIZE : integer := 16
  );
  port (
    clk   : in std_logic;
    start : in std_logic;
    reset : in std_logic;
    done  : out std_logic
  );
end entity system;

architecture system_arch of system is
  component ram is
    generic (
      WORDSIZE     : integer := 16;
      ADDRESS_SIZE : integer := 16
    );
    port (
      clk     : in std_logic;
      we      : in std_logic;
      address : in std_logic_vector(ADDRESS_SIZE - 1 downto 0);
      datain  : in std_logic_vector(WORDSIZE - 1 downto 0);
      dataout : out std_logic_vector(WORDSIZE - 1 downto 0)
    );
  end component;
  component reg is
    generic (WORDSIZE : integer := 32);
    port (
	  reset : in std_logic;
      clk : in std_logic;
      en  : in std_logic;
      d   : in signed(WORDSIZE - 1 downto 0);
      q   : out signed(WORDSIZE - 1 downto 0) := (others => '0')
    );
  end component;

  component ripple_adder is
    generic (
      SIZE : integer := 8
    );
    port (
      op1, op2 : in signed(SIZE - 1 downto 0);
      cin      : in signed;
      result   : out signed(SIZE - 1 downto 0);
      cout     : out signed
    );
  end component;

  component controller2 is
    generic (
      ADDRESS_SIZE : integer := 16
    );
    port (
      start             : in std_logic;
      clk               : in std_logic;
      reset             : in std_logic;
      we                : out std_logic;
      EWF               : out std_logic;
      EWB               : out std_logic;
      out_conv          : out std_logic;
      enable_conv       : out std_logic;
      out_pool          : out std_logic;
      done              : out std_logic;
      reset_Accumulator : out std_logic;
      filterAddress     : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
      BuffAddress       : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
      MemAddress        : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
      ConvAddress       : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
      PoolAddress       : out std_logic_vector(ADDRESS_SIZE - 1 downto 0)
    );
  end component;
  component Buff is
    generic (
      WORD_SIZE    : integer := 16;
      WINDOW_SIZE  : integer := 3;
      ADDRESS_SIZE : integer := 16
    );
    port (
      buffAddress : in signed(ADDRESS_SIZE - 1 downto 0);
      datain      : in signed(WORD_SIZE - 1 downto 0);
      enable      : in std_logic;
      clk         : in std_logic;
      data        : out signed(WINDOW_SIZE * WINDOW_SIZE * WORD_SIZE - 1 downto 0)
    );
  end component;
  component convolution is
    generic (
      WINDOWSIZE : integer := 3
    );
    port (
      filter : in signed(WINDOWSIZE * WINDOWSIZE * 16 - 1 downto 0);
      window : in signed(WINDOWSIZE * WINDOWSIZE * 16 - 1 downto 0);
      result : out signed(15 downto 0)
    );
  end component;

  component Concat is
    generic (
      WORD_SIZE : integer := 16
    );
    
    port (
      arr1   : in signed(5*WORD_SIZE-1 downto 0);
      arr2   : in signed(5*WORD_SIZE-1 downto 0);
      arr3   : in signed(5*WORD_SIZE-1 downto 0);
      arr4   : in signed(5*WORD_SIZE-1 downto 0);
      arr5   : in signed(5*WORD_SIZE-1 downto 0);
      result : out signed(5*5*WORD_SIZE-1 - 1 downto 0)
    );
  end component;

  component Concat2x2 is
    generic (
      WORD_SIZE : integer := 16
    );
    port(
      arr1 : in signed(2*WORD_SIZE-1 downto 0);
      arr2 : in signed(2*WORD_SIZE-1 downto 0);
      result : out signed(2*WORD_SIZE*2-1 downto 0)
      );
  end component;

  component pooling is
    generic(
      WINDOWSIZE : integer := 2
    );
    port(
    window : in signed(WINDOWSIZE*WINDOWSIZE*16-1 downto 0);
    sum : out signed(15 downto 0)
    );
  end component;
  

  
  signal we                                                           : std_logic;
  signal EWF, EWB, out_conv, enable_conv, out_pool, reset_Accumulator : std_logic;
  signal indata                                                       : std_logic_vector(WORDSIZE - 1 downto 0);
  signal outdata                                                      : std_logic_vector(WORDSIZE - 1 downto 0);
  signal imgdata                                                      : signed(32 * 32 * WORDSIZE - 1 downto 0) := (others => '0');
  signal filter_data                                                  : signed(5 * 5 * WORDSIZE - 1 downto 0)   := (others => '0');
  --   signal convResult                                                       : signed(28 * 28 * WORDSIZE - 1 downto 0)         := (others => '0');
  signal conv_input_concatination                                                             : signed(28 * 28 * 5 * 5 * WORDSIZE - 1 downto 0) := (others => 'U');
  signal pool_input_concatination                                                             : signed(14 * 14 * 2 * 2 * WORDSIZE - 1 downto 0) := (others => 'U');
  signal filterAddress, BuffAddress, MemAddress, ConvAddress, PoolAddress : std_logic_vector(ADDRESS_SIZE - 1 downto 0);

  type CONV_RESULT is array(0 to 783) of signed(WORDSIZE - 1 downto 0);
  signal adder_carry : signed(783 downto 0);
  signal convResult   : CONV_RESULT := (others => (others =>'0')); -- 0 is convolution 1  
  signal reg_to_adder : CONV_RESULT := (others => (others =>'0'));
  signal adder_result : CONV_RESULT := (others => (others =>'0'));
  --   signal adder_result : std_logic_vector(WORDSIZE - 1 downto 0);

  type POOL_RESULT is array(0 to 14*14-1) of signed(WORDSIZE - 1 downto 0);
  signal poolResult : POOL_RESULT := (others => (others =>'0'));

  

begin
  -- RAM component --
  Ram_comp_lbl : ram generic map(WORDSIZE, ADDRESS_SIZE) port map(clk, we, MemAddress, outdata, indata);
  -- controller component--
  Control_lbl : controller2 generic map(ADDRESS_SIZE) port map(start, clk, reset, we, EWF, EWB, out_conv, enable_conv, out_pool, done, reset_Accumulator, filterAddress, BuffAddress, MemAddress, ConvAddress, PoolAddress);
  -- Image Buffer component--
  Img_Buffer_lbl : Buff generic map(WORDSIZE, 32, ADDRESS_SIZE) port map(signed(BuffAddress), signed(indata), EWB, clk, imgdata);
  -- Filter Buffer component--
  Filter_Buffe_lblr : Buff generic map(WORDSIZE, 5, ADDRESS_SIZE) port map(signed(filterAddress), signed(indata), EWF, clk, filter_data);
  Conv_REG_lbl :
  for i in 0 to 27 generate
    A :
    for j in 0 to 27 generate
      concat1_lbl : Concat port map(
        imgdata(((i * 32 + j + 5) * 16) - 1 downto (i * 32 + j) * 16),
        imgdata((((i + 1) * 32 + j + 5) * 16) - 1 downto ((i + 1) * 32 + j) * 16),
        imgdata((((i + 2) * 32 + j + 5) * 16) - 1 downto ((i + 2) * 32 + j) * 16),
        imgdata((((i + 3) * 32 + j + 5) * 16) - 1 downto ((i + 3) * 32 + j) * 16),
        imgdata((((i + 4) * 32 + j + 5) * 16) - 1 downto ((i + 4) * 32 + j) * 16),
        conv_input_concatination((i * 28 + j + 1)*25 * 16 - 1 downto (i * 28 + j) *25* 16));
      conv_lbl : convolution generic map(
        5) port map(filter_data,
        conv_input_concatination((i * 28 + j + 1) *25* 16 - 1 downto (i * 28 + j) *25* 16), convResult(28 * i + j));--index of convResult
      --(i * 28 + j + 1) * 16 - 1 downto (i * 28 + j) * 16)
      reg1_lbl : reg generic map(
      16) port map(reset_Accumulator, clk, enable_conv, adder_result(i * 28 + j), reg_to_adder(i * 28 + j));

      addr_lbl : ripple_adder generic map(16) port map(convResult(i*28+j), 
	  reg_to_adder(i*28+j), adder_carry(i*28+j downto i*28+j), adder_result(i*28+j), adder_carry(i*28+j downto i*28+j));
    end generate A;

  end generate Conv_REG_lbl;

  -- reg_to_adder(to_integer(unsigned(ConvAddress)))
  outdata <= std_logic_vector(reg_to_adder(to_integer(unsigned(ConvAddress)))) when out_conv = '1'
  else (others => 'Z');-- convolution buffer address 

       
  Pool_REG :
  for row in 0 to (28-2)/2 generate -- varies from 0 to 13
    B :
    for col in 0 to (28-2)/2 generate -- varies from 0 to 13
      concat_pool_input_lbl : Concat2x2 generic map (16) port map(
        imgdata((((row*2) * 32 + (col*2) + 2) * 16) - 1 downto ((row*2) * 32 + (col*2)) * 16),          
        imgdata((((row*2+1) * 32 + (col*2) + 2) * 16) - 1 downto ((row*2+1) * 32 + (col*2)) * 16),                  
        pool_input_concatination(((row) * 14 + col + 1) * 4 * 16 - 1 downto ((row) * 14 + col) * 4 * 16));

        pool_result_lbl : pooling  generic map(2) port map( 
                pool_input_concatination(((row) * 14 + col + 1) * 4 * 16 - 1 downto ((row) * 14 + col) * 4 * 16)
              , poolResult(14 * row + col)
              );
        
    end generate B;
  end generate Pool_REG;
 	     

  outdata <= std_logic_vector(poolResult(to_integer(unsigned(PoolAddress)))) when out_pool = '1'
  else (others => 'Z');
         
end architecture;
  -- outdata <= std_logic_vector(convResult((to_integer(unsigned(ConvAddress)) + 1) * 16 - 1 downto to_integer(unsigned(ConvAddress)) * 16)) when out_conv = '1'
  -- 	else (others => 'Z');-- convolution buffer address 
							