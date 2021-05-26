library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Entity Buff is
	generic(
		WORD_SIZE : integer := 16;
		WINDOW_SIZE : integer := 3;
		ADDRESS_SIZE : integer := 16
	);
	port(
	buffAddress : in signed(ADDRESS_SIZE-1 downto 0);
	datain : in signed(WORD_SIZE-1 downto 0);
	enable : in std_logic;
	clk : in std_logic;
	data : out signed(WINDOW_SIZE*WINDOW_SIZE*WORD_SIZE-1 downto 0)
	);
end entity;


ARCHITECTURE SIPO of Buff is 
signal buffSig : signed(WINDOW_SIZE*WINDOW_SIZE*WORD_SIZE-1 downto 0);
begin

process(clk) is
	begin
		if rising_edge(clk) then
			if enable = '1' then
				buffSig((WORD_SIZE * (to_integer(buffAddress)+1))-1 downto WORD_SIZE * to_integer(buffAddress)) <= datain;
			end if;
		end if;
	end process;

data <= buffSig;
end ARCHITECTURE;