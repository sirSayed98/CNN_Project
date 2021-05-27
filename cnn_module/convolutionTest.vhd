library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity convolutionTest is
end entity;

ARCHITECTURE convolutionTest_arc of convolutionTest is
	component  convolution is 
		generic(
			WINDOWSIZE : integer := 3
		);
		port(
		filter : in signed(WINDOWSIZE*WINDOWSIZE*16-1 downto 0);
		window : in signed(WINDOWSIZE*WINDOWSIZE*16-1 downto 0);
		result : out signed(15 downto 0)
		);
	end component;
	-- inputs --
	signal f : signed(3*3*16-1 downto 0) := (others=>'0');
    signal w : signed(3*3*16-1 downto 0) := (others=>'0');
    ----------
    -- outputs --
    signal r : signed(15 downto 0):= (others=>'0');
    -------------
    begin
    -- port mapping --
    conv : convolution generic map(3) port map(f ,w ,r ); 
    ------------------
    -- process ---
    -- testing
    -- window |1| 1| 1|     filter |1 | 1| 1|
    --        |1| 1| 1|            |1 | 1| 1|
    --        |1| 1| 1|            |1 | 1| 1|
    --wait for 100 ps;
    -- window |0.5| 0.5| 0.5|    filter |2 | 2| 2|
    --        |0.5| 0.5| 0.5|           |2 | 2| 2|  
    --        |0.5| 0.5| 0.5|           |2 | 2| 2|
	f <= "000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000","000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000" after 200 ps;
    w <= "000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000","000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000" after 200 ps;
    -------------
end ARCHITECTURE;

