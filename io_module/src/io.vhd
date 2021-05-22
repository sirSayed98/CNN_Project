library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity io is
  generic (
    RAM_WORD_SIZE : integer := 16;
    RAM_ADDRESS_SIZE : integer := 10
    );
  port(
    clk : in std_logic;
    rst : in std_logic;
    interrupt : in std_logic;
    load_process : in std_logic;
    img_cnn : in std_logic;
    done : out std_logic;

    din : in std_logic_vector(15 downto 0);
    dout : out std_logic_vector(3 downto 0)
    );  
end io;

architecture io_0 of io is

-----------------------------------Declarations--------------------------------
--register 
component reg IS
generic (WORDSIZE : integer := 16);
		 port(
			 	clk : IN std_logic; 
        en : in std_logic;
		 		d : IN std_logic_vector(WORDSIZE-1 downto 0);
				q : OUT std_logic_vector(WORDSIZE-1 downto 0)
				);
end component;

--RAM
component ram is
	generic(
		WORDSIZE : integer := 16;
		ADDRESS_SIZE : integer := 16
	);
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(ADDRESS_SIZE-1 downto 0);
		datain  : IN  std_logic_vector(WORDSIZE-1 downto 0);
		dataout : OUT std_logic_vector(WORDSIZE-1 downto 0));
end component;

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

--decrementing counter
component decCounter is
  generic (n : integer := 8);
  port(
    clk : in std_logic;
    rst : in std_logic;
    dec : in std_logic;
    load : in std_logic;
    zeroFlag : out std_logic;
    parallel_OP : out std_logic_vector (n-1 downto 0);
    parallel_IN : in std_logic_vector (n-1 downto 0)
  );
end component;

--shift register
component shiftReg is
  generic (n : integer := 8);
  port(
    clk, rst, enable  : in std_logic;
    serial_IP : in std_logic;
    parallel_OP : out std_logic_vector (n-1 downto 0)
  );
end component;
-----------------------------------Signals-------------------------------------
--RAM
signal ram_address_bus : std_logic_vector(RAM_ADDRESS_SIZE-1 downto 0);
signal ram_output : std_logic_vector(RAM_WORD_SIZE-1 downto 0);
signal ram_input : std_logic_vector(RAM_WORD_SIZE-1 downto 0);
signal ram_we : std_logic;

--Address Counters
signal ACIMG_en : std_logic;
signal ACIMG_input : std_logic_vector(RAM_ADDRESS_SIZE-1 downto 0);
signal ACIMG_output : std_logic_vector(RAM_ADDRESS_SIZE-1 downto 0);
signal ACIMG_adder_cout : std_logic;
signal ACIMG_adder_output : std_logic_vector(RAM_ADDRESS_SIZE-1 downto 0);

signal ACKRN_en : std_logic;
signal ACKRN_input : std_logic_vector(RAM_ADDRESS_SIZE-1 downto 0);
signal ACKRN_output : std_logic_vector(RAM_ADDRESS_SIZE-1 downto 0);
signal ACKRN_adder_cout : std_logic;
signal ACKRN_adder_output : std_logic_vector(RAM_ADDRESS_SIZE-1 downto 0);

constant IMAGE_SIZE : integer := 784; --in bytes
constant KERNALS_SIZE : integer := 200;

----------------------------------Counters-------------------------------------
signal num_count_z : std_logic;
signal num_count_dec : std_logic;
signal num_count_load : std_logic;
signal num_count_input : std_logic_vector(4 downto 0);
signal num_count_output : std_logic_vector(4 downto 0);

signal data_count_z : std_logic;
signal data_count_dec : std_logic;
signal data_count_load : std_logic;
signal data_count_input : std_logic_vector(6 downto 0);
signal data_count_output : std_logic_vector(6 downto 0);
----------------------------------Shift register-------------------------------
signal shift_reg_output : std_logic_vector(RAM_WORD_SIZE-1 downto 0);
signal shift_reg_input : std_logic;
signal shift_reg_enable : std_logic;

-----------------------------------StateMachine--------------------------------
type io_state is (s_idle, 
                  s_prep_first_byte, 
                  s_finished_first_byte, 
                  s_prep_second_byte,
                  s_finished_second_byte);  
signal state : io_state;    
                 
signal ds_idle : std_logic;
signal ds_prep_first_byte : std_logic;
signal ds_finished_first_byte : std_logic;
signal ds_prep_second_byte : std_logic;
signal ds_finished_second_byte : std_logic;

begin
  ------------------------------------RAM--------------------------------------
  --TODO: make the ram outside of io module.
  ram_inst: ram generic map (RAM_WORD_SIZE, RAM_ADDRESS_SIZE) 
  port map(clk, ram_we, ram_address_bus, ram_input, ram_output);

  ram_address_bus <= ACIMG_output when img_cnn = '1' 
  else ACKRN_output;

  ram_input <= shift_reg_output;

  ram_we <= (ds_prep_first_byte and num_count_z) or 
  (ds_prep_second_byte and num_count_z);
  ---------------------------Address Counters----------------------------------
  ACIMG : reg generic map (RAM_ADDRESS_SIZE) 
  port map(clk, ACIMG_en, ACIMG_input, ACIMG_output);  

  ACIMG_adder: ripple_adder generic map (RAM_ADDRESS_SIZE)
  port map(ACIMG_output, (others => '0'), '1', ACIMG_adder_output, ACIMG_adder_cout);
  
  ACIMG_input <= (others => '0') when rst = '1' else ACIMG_adder_output;

  ACIMG_en <= rst or (num_count_z and ds_prep_first_byte and img_cnn) or
  (num_count_z and ds_prep_second_byte and img_cnn);
  
  ACKRN : reg generic map (RAM_ADDRESS_SIZE) 
  port map(clk, ACKRN_en, ACKRN_input, ACKRN_output);  

  ACKRN_adder: ripple_adder generic map (RAM_ADDRESS_SIZE)
  port map(ACKRN_output, (others => '0'), '1', ACKRN_adder_output, ACKRN_adder_cout);

  ACKRN_input <= std_logic_vector(to_unsigned(IMAGE_SIZE, ACKRN_input'length))
  when rst = '1' else ACKRN_adder_output;

  ACKRN_en <= rst or (num_count_z and ds_prep_first_byte and not img_cnn) or
  (num_count_z and ds_prep_second_byte and not img_cnn);

  -------------------------------StateMachine----------------------------------
  process (clk) 
  begin
    if rising_edge(clk) then
      if rst = '0' then
        case state is
        
          when s_idle => 
            if load_process = '1' and interrupt = '1' then
              state <= s_prep_first_byte;  
            else
              state <= s_idle;
            end if;

          when s_prep_first_byte => 
            if num_count_z = '0' and data_count_z = '1' then
              state <= s_prep_second_byte;
            elsif num_count_z = '1' then
              state <= s_finished_first_byte;
            else 
              state <= s_prep_first_byte;
            end if;

          when s_finished_first_byte => 
            if data_count_z = '0' then
              state <= s_prep_first_byte;
            elsif data_count_z = '1' then
              state <= s_prep_second_byte;
            else
              state <= s_finished_first_byte;
            end if;

          when s_prep_second_byte => 
            if num_count_z = '0' and data_count_z = '1' then
              state <= s_idle;
            elsif num_count_z = '1' then
              state <= s_finished_second_byte;
            else
              state <= s_prep_second_byte;
            end if;

          when s_finished_second_byte => 
            if data_count_z = '1' then
              state <= s_idle;
            elsif data_count_z = '0' then
              state <= s_prep_second_byte;
            else 
              state <= s_finished_second_byte;
            end if;
        end case;
      else 
        state <= s_idle;
      end if;
    end if;
  end process;

  -------------------------------StateMachineDecode----------------------------
  process (state)
  begin
    if state = s_idle then 
      ds_idle <= '1';
    else 
      ds_idle <= '0';
    end if;

    if state = s_prep_first_byte then 
      ds_prep_first_byte <= '1';
    else 
      ds_prep_first_byte <= '0';
    end if;
    
    if state = s_finished_first_byte then 
      ds_finished_first_byte <= '1';
    else 
      ds_finished_first_byte <= '0';
    end if;
    
    if state = s_prep_second_byte then 
      ds_prep_second_byte <= '1';
    else 
      ds_prep_second_byte <= '0';
    end if;
    
    if state = s_finished_second_byte then 
      ds_finished_second_byte <= '1';
    else 
      ds_finished_second_byte <= '0';
    end if;

  end process;
  
  ------------------------------------Word Counter-----------------------------
  num_count : decCounter generic map (5) 
  port map (clk, rst, num_count_dec, num_count_load, num_count_z, 
  num_count_output, num_count_input);

  num_count_dec <= (ds_prep_first_byte or ds_prep_second_byte) and 
  (not num_count_z and not data_count_z);

  num_count_load <= 
  ((ds_finished_second_byte or ds_finished_first_byte) and not data_count_z) or
  (ds_finished_first_byte and data_count_z);

  num_count_input <= std_logic_vector(to_unsigned(RAM_WORD_SIZE, 
  num_count_input'length));
  ------------------------------------packet Counter---------------------------
  data_count : decCounter generic map (7) 
  port map (clk, rst, data_count_dec, data_count_load, data_count_z, 
  data_count_output, data_count_input);

  data_count_dec <= num_count_dec;

  data_count_load <= 
  (ds_idle and load_process and interrupt) or 
  (ds_finished_first_byte and data_count_z) or 
  (ds_prep_first_byte and not num_count_z and data_count_z);

  data_count_input <= din(14 downto 8) 
  when (ds_idle and load_process and interrupt) = '1' else din(6 downto 0);
  ------------------------------------Done Signal------------------------------
  done <= ds_idle;
  ------------------------------------Shift register---------------------------
  byte_reg: shiftReg generic map(RAM_WORD_SIZE) 
  port map(clk, rst, shift_reg_enable, shift_reg_input, shift_reg_output);
  
  shift_reg_input <= din(15) when ds_prep_first_byte = '1' else din(7);
  shift_reg_enable <= num_count_dec;

end io_0;

