library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity poolTest is
end entity;

ARCHITECTURE poolTest_arc of poolTest is
    component pooling is
        generic(
		    WINDOWSIZE : integer := 3
	    );
	    port(
	    window : in signed(WINDOWSIZE*WINDOWSIZE*16-1 downto 0);
	    sum : out signed(15 downto 0)
	    );
    end component;
    -- inputs --
    signal w : signed(3*3*16-1 downto 0) := (others=>'0');
    ----------
    -- outputs --
    signal s : signed(15 downto 0);
    -------------
    begin
    -- port mapping --
    pool : pooling generic map(3) port map
    (
        w ,
        s 
    ); 
    ------------------
    -- process ---
    -- testing
    -- window |1| 1| 1|
    --        |1| 1| 1|
    --        |1| 1| 1|
    --wait for 100 ps;
    -- window |0.5| 0.5| 0.5|
    --        |0.5| 0.5| 0.5|
    --        |0.5| 0.5| 0.5|
    w <= "000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000","000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000" after 200 ps;
    -------------
end ARCHITECTURE;

