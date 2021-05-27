library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity Concat is
generic(
	WORD_SIZE : integer := 16
		);
	port(
	arr1 : in signed(5*WORD_SIZE-1 downto 0);
	arr2 : in signed(5*WORD_SIZE-1 downto 0);
	arr3 : in signed(5*WORD_SIZE-1 downto 0);
	arr4 : in signed(5*WORD_SIZE-1 downto 0);
	arr5 : in signed(5*WORD_SIZE-1 downto 0);
	result : out signed(5*WORD_SIZE*5-1 downto 0)
	);
end entity;

ARCHITECTURE Concat_arc of Concat is
begin
result <= arr5 & arr4 & arr3 & arr2 & arr1;
end ARCHITECTURE;
