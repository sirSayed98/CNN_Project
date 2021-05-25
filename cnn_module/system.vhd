
library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity system is
	port(
		clk : in std_logic
	    );
end entity system;

ARCHITECTURE system_arch OF system is
SIGNAL address		: std_logic_vector(15 downto 0);
SIGNAL data_in, data_out	: std_logic_vector(15 downto 0);

begin
ram : ENTITY work.ram GENERIC MAP(WORDSIZE => WORDSIZE, ADDRESS_SIZE => ADDRESS_SIZE)
PORT MAP(clk, we, address, datain, data_out);

cnn_module : ENTITY work.ram GENERIC MAP(WORDSIZE => WORDSIZE, ADDRESS_SIZE => ADDRESS_SIZE)
PORT MAP(clk, we, address, datain, data_out);
end system_arch;