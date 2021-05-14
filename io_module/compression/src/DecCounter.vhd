Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;


entity decCounter is
    GENERIC (n : integer := 8);
    port(
        clk : in std_logic;
        rst : in std_logic;
        dec : in std_logic;
        load : in std_logic;
        zeroFlag : out std_logic;
        parallel_OP : out std_logic_vector (n-1 downto 0);
        parallel_IN : in std_logic_vector (n-1 downto 0)
    );
end decCounter;

architecture decCounter_arch of decCounter is
  --ripple adder
  component ripple_adder is
    generic (
      SIZE : integer := 8
      );
    port (
      op1, op2 : in std_logic_vector(SIZE-1 downto 0);
      cin : in std_logic;
      result : out  std_logic_vector(SIZE-1 downto 0);
      cout : out std_logic
      );
  end component;

  --Address Counters
  signal adder_cout : std_logic;
  signal adder_output : std_logic_vector(n-1 downto 0);

  signal counter_output : std_logic_vector(n-1 downto 0);
begin
  adder: ripple_adder generic map (n)
  port map(counter_output, (others => '1'), '0', adder_output, adder_cout);
  
  process(clk)
  begin
    if(rising_edge(clk)) then
      if(dec = '1') then
        counter_output <= adder_output;
      elsif(load = '1') or (rst = '1') then
        counter_output <= parallel_IN;
      end if;
    end if;
  end process;

  parallel_OP <= counter_output;
  zeroFlag <= nor_reduce(counter_output);
end decCounter_arch;