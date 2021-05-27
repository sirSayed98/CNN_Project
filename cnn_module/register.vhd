library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY reg IS
GENERIC (WORDSIZE : integer := 32);
		 PORT(
			 	reset : IN std_logic;
			 	clk : IN std_logic; 
				en : in std_logic;
		 		d : IN signed(WORDSIZE-1 DOWNTO 0);
				q : OUT signed(WORDSIZE-1 DOWNTO 0) := (others => '0')
				);
END reg;

ARCHITECTURE reg_1 OF reg IS
BEGIN
	PROCESS(clk, reset)
	BEGIN
		if reset = '1' then 
			q <= (others => '0');
		end if;
		IF rising_edge(clk) and en = '1'  THEN     
			q <= d;
		END IF;
	END PROCESS;
END reg_1;


