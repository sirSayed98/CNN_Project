Library ieee;
use ieee.std_logic_1164.all;

entity shiftReg is
    GENERIC (n : integer := 8);
    port(
        clk, rst, enable  : in std_logic;
        serial_IP : in std_logic;
        parallel_OP : out std_logic_vector (n-1 downto 0)
    );
end shiftReg;


architecture shiftReg_arch of shiftReg is
	signal shift_reg_OP : std_logic_vector (n-1 downto 0);
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if(rst='1') then
				shift_reg_OP <= (others => '0');
			elsif(enable='1') then
				shift_reg_OP(n-1 downto 1) <= shift_reg_OP(n-2 downto 0);
				shift_reg_OP(0) <= serial_IP;
			end if;
	  end if;
	end process;

	parallel_OP <= shift_reg_OP;
end shiftReg_arch;