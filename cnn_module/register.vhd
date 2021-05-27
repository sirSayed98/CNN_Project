library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY reg IS
GENERIC (WORDSIZE : integer := 32);
		 PORT(
			 	clk : IN std_logic; 
				en : in std_logic;
		 		d : IN signed(WORDSIZE-1 DOWNTO 0);
				q : OUT signed(WORDSIZE-1 DOWNTO 0) := (others => '0')
				);
END reg;

ARCHITECTURE reg_1 OF reg IS
BEGIN
	PROCESS(clk)
	BEGIN
		IF rising_edge(clk) and en = '1'  THEN     
			q <= d;
		END IF;
	END PROCESS;
END reg_1;


