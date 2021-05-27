library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity full_adder is
	port (a,b,cin : in  signed;
		  s, cout : out signed );
end full_adder;

architecture full_adder_0 of full_adder is
	begin
	s <= a xor b xor cin;
	cout <= (a and b) or (cin and (a xor b));
end full_adder_0;