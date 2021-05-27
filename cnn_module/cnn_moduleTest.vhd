library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
entity systemTest is    
end entity systemTest;
  
architecture system_arch of systemTest is
    component system is 
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
    end component;
    -- inputs --
	signal c   : std_logic := '0';
    signal s : std_logic := '0';
    signal r : std_logic := '0';
    ----------
    -- outputs --
    signal d  : std_logic;
    -------------
    begin
    -- port mapping --
    sys : system generic map(16,5,16) port map(c ,s ,r,d ); 
    ------------------
    c <= not c after 100 ps;
end ARCHITECTURE;

