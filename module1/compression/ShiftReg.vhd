Library ieee;
use ieee.std_logic_1164.all;

entity shiftReg is
    GENERIC (n : integer := 8);
    port(
        clk, rst, enable  : in std_logic;
        serial_IP : in std_logic;
        parallel_OP : inout std_logic_vector (n-1 downto 0)
    );
end shiftReg;

architecture shiftReg_arch of shiftReg is
begin
    process(clk)
    	begin
	  if(enable='1') then
		if(rst='1') then
			parallel_OP <= (others => '0');
		elsif (rising_edge(clk)) then
			parallel_OP(n-1 downto 1) <= parallel_OP(n-2 downto 0);
			parallel_OP(0) <= serial_IP;
		end if;
	  end if;
	end process;
end shiftReg_arch;