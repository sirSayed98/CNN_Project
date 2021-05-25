library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Entity resBuff is
	generic(
		WORD_SIZE : integer := 16;
		WINDOW_SIZE : integer := 3;
		ADDRESS_SIZE : integer := 16
	);
	port(
	buffAddress : in signed(ADDRESS_SIZE-1 downto 0);
	datain : in signed(WINDOW_SIZE*WINDOW_SIZE*WORD_SIZE-1 downto 0);
	enable : in std_logic;
	data : out signed(WINDOW_SIZE*WINDOW_SIZE*WORD_SIZE-1 downto 0)
	);
end entity;


ARCHITECTURE PIPO of resBuff is 
signal buffSig : signed(WINDOW_SIZE*WINDOW_SIZE*WORD_SIZE-1 downto 0);
begin

process(enable) is
	begin
		if enable = '1' then
			buffSig <= datain;
		end if;
	end process;

data <= buffSig;
end ARCHITECTURE;