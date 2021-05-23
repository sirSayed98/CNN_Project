library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
 
entity io_tb is
end io_tb;
 
architecture io_tb_0 of io_tb is
 
-----------------------------------Declarations--------------------------------
component io is
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
end component;
 
-----------------------------------Signals-------------------------------------
file image_file : text;
file kernal_file : text;

constant PERIOD : time := 100 ps;

signal clk : std_logic := '1';
signal rst : std_logic;
signal interrupt : std_logic;
signal load_process : std_logic;
signal img_cnn : std_logic;
signal done : std_logic;
signal din : std_logic_vector(15 downto 0);
signal dout : std_logic_vector(3 downto 0);
   
signal finish_sim : std_logic := '0';

begin
 
  -------------------------Instantiate and Map UUT-----------------------------
  IO_INST : io
    port map (
      clk,
      rst,
      interrupt,
      load_process,
      img_cnn,
      done,
      din,
      dout
      );
 
 
  --clk 
  process 
  begin
    clk <= not clk; 
    wait for PERIOD/2;
    
    if finish_sim = '1' then
      wait;
    end if;
  end process;

  --reset 
  process 
  begin
    rst <= '1'; 
    wait for PERIOD;
    rst <= '0'; 
    wait;
  end process;

  ---stimuli
  process
    variable v_line     : line;
    variable v_packet : std_logic_vector(15 downto 0);
  begin
    wait for PERIOD;
    
    --send image
    file_open(image_file, "image.txt",  read_mode);
 
    img_cnn <= '1';
    while not endfile(image_file) loop
      readline(image_file, v_line);
      read(v_line, v_packet);
 
      din <= v_packet;
      load_process <= '1';
      interrupt <= '1';

      wait for PERIOD; --wait for at least a period
      wait until done = '1';
    end loop;
 
    file_close(image_file);

    --send kernals
    file_open(kernal_file, "kernal.txt",  read_mode);
 
    img_cnn <= '0';
    while not endfile(kernal_file) loop
      readline(kernal_file, v_line);
      read(v_line, v_packet);
 
      din <= v_packet;
      load_process <= '1';
      interrupt <= '1';

      wait for PERIOD; --wait for at least a period
      wait until done = '1';
    end loop;
 
    file_close(kernal_file);

    --process
    --load_process <= '0';
    --interrupt <= '1';
    --wait for PERIOD; --wait for at least a period
    --wait until done = '1';

    --assert
    --TODO
    
    ---------------------------------------------
    finish_sim <= '1'; --stop simulation
    wait;
  end process;
 
end io_tb_0;