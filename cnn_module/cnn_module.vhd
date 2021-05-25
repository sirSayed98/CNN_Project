
library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity cnn_module is
	generic(
		WORDSIZE : integer := 16;
		ADDRESS_SIZE : integer := 16
		);
	port(
		clk : in std_logic,
		start : in std_logic;
		we : out std_logic;
		datain  : out  std_logic_vector(WORDSIZE-1 downto 0);
		dataout : in std_logic_vector(WORDSIZE-1 downto 0);
	    );
end entity cnn_module;

ARCHITECTURE cnn_module_arch OF cnn_module is

	
end cnn_module_arch;