Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;


entity decCounter is
    GENERIC (n : integer := 8);
    port(
        loadEight,enable,load  : in std_logic;
        clk : in std_logic;
	zeroFlag : out std_logic;
        parallel_OP : inout std_logic_vector (n-1 downto 0);
	parallel_IN : in std_logic_vector (n-1 downto 0)
    );
end decCounter;

architecture decCounter_arch of decCounter is
begin
    process(clk)
    	begin
	  if(rising_edge(clk)) then
	  	if(enable='1') then
			if(loadEight='1') then
				parallel_OP <= "00001000";
			elsif(load='1') then
				parallel_OP <= parallel_IN;
			else
				parallel_OP <= std_logic_vector(unsigned(parallel_OP) -1);
			end if;
	  	end if;
	  end if;
	end process;

zeroFlag <= nor_reduce(parallel_OP);
end decCounter_arch;