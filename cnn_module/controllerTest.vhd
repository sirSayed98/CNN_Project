library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity controllerTest is
    end entity;

ARCHITECTURE controllerTestArc OF controllerTest is

    component controller is 
    generic(
    ADDRESS_SIZE : integer := 16;
    WORDSIZE : integer := 16;
-- * IMMEDIATE_START_ADDRESS = 3575 + 16 * 120 * 5 * 5 = 51575
    IMMEDIATE_START_ADDRESS : integer := 51575 
    );
    port(
    start : in std_logic;
    clk : in std_logic;
    reset : in std_logic; -- NEW everything is reset if =1
    we : out std_logic;
    EWF : out std_logic;
    EWB : out std_logic;
    out_conv : out std_logic;
    enable_conv : out std_logic;
    out_pool : out std_logic;
    done : out std_logic;   -- NEW  is set to 1 on done
    reset_accumulator : out std_logic;
    filterAddress : out  std_logic_vector(ADDRESS_SIZE-1 downto 0);
    BuffAddress : out  std_logic_vector(ADDRESS_SIZE-1 downto 0);
    MemAddress : out  std_logic_vector(ADDRESS_SIZE-1 downto 0);
    ConvAddress : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
    PoolAddress : out  std_logic_vector(ADDRESS_SIZE-1 downto 0)
    );
end component;
 
-- inputs --
signal st: std_logic := '0';
signal clock : std_logic := '0'; -- make sure you initialise!
signal r : std_logic := '0'; -- make sure you initialise!
----------
-- outputs --
signal w:  std_logic;
signal EF :  std_logic;
signal EB :  std_logic;
signal oonv :  std_logic;
signal ee_conv :  std_logic;
signal oool :  std_logic;
signal d:  std_logic;   -- NEW  is set to 1 on done
signal rulator :  std_logic;
signal fss :   std_logic_vector(15 downto 0);
signal B :   std_logic_vector(15 downto 0);
signal M:   std_logic_vector(15 downto 0);
signal C :  std_logic_vector(15 downto 0);
signal P :   std_logic_vector(15 downto 0);
-------------
begin
-- port mapping --
control : controller generic map(16,16,51575) port map
(
    st ,clock,r,w,EF,EB,oonv,ee_conv,oool,d,rulator,fss,B,M,C,P
); 
------------------
-- process ---
-- testing
clock <= not clock after 50 ps;
st <= '0','1' after 100 ps;
r <= '0';
-------------
end ARCHITECTURE;
