library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Concat2x2 is
generic(
	WORD_SIZE : integer := 16
		);
	port(
	arr1 : in signed(2*WORD_SIZE-1 downto 0);
	arr2 : in signed(2*WORD_SIZE-1 downto 0);
	result : out signed(2*WORD_SIZE*2-1 downto 0)
	);
end entity;

ARCHITECTURE Concat2x2_arc of Concat2x2 is
begin
result <= arr2 & arr1 ;
end ARCHITECTURE;
