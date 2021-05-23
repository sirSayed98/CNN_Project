-- 
-- Layer counter
-- Depth counter
-- Filter counter 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

 Entity controller is 
		generic(
		WORDSIZE : integer := 16;
		ADDRESS_SIZE : integer := 16
		);
		port(
		start : in std_logic;
		clk : in std_logic;
		datain  : in  std_logic_vector(WORDSIZE-1 downto 0);
		convResult : in std_logic_vector(16*28*28-1 downto 0);
		poolResult: in std_logic_vector(16*14*14-1 downto 0);
		we : out std_logic;
		address : out  std_logic_vector(ADDRESS_SIZE-1 downto 0);
		dataout : out std_logic_vector(WORDSIZE-1 downto 0);
		filter : out std_logic_vector(16*5*5-1 downto 0);
		image_buf : out std_logic_vector(16*32*32-1 downto 0)
		);
end entity;

ARCHITECTURE controllerArc OF controller is
	signal ad : std_logic_vector(15 downto 0):= x"0000";
	

	begin 
		process (start, clk) is
			variable layerCounter : std_logic_vector(2 downto 0);
			variable depthCounter : std_logic_vector(4 downto 0);
			variable filterCounter : std_logic_vector(7 downto 0);
			variable wordCount : std_logic_vector(15 downto 0); 	-- number of words to read
			variable iLoaded : std_logic;	-- image loaded or not
			variable fLoaded : std_logic;	-- filters loaded or not
			variable index : integer;
			variable temp : integer;
			begin
				if rising_edge(start) then
					-- Initialization
					layerCounter := (others => '0');
					depthCounter := (others => '0');
					filterCounter := (others => '0');
					wordCount := std_logic_vector(to_unsigned(32*32, 16));
					iLoaded := '0';
					fLoaded := '0';
					address <= x"00";
					index := 0;
					end if;
					
				if rising_edge(clk) then
					if Layercounter = O"0" and iLoaded = '0' then   
						image_buf((1 + index) * 16 - 1 downto index * 16)  <= datain;
						index := index + 1;
					end if;
					-- load the image
					-- load filters 
					-- convolve 
					-- save result
				end if;
			end process;
	
	
	
	-- Layercounter : std_logic_vector(2 downto 0);
	-- Depthcounter : std_logic_vector(4 downto 0);
	-- Filtercounter : std_logic_vector(7 downto 0);
		
	-- begin
	-- 	process(Layercounter) is
	-- 	begin
	-- 		if Layercounter = '0' then
	-- 			for i in 0 to 32 loop
	-- 				for j in 0 to 32 loop
	-- 					address <= ad;
	-- 					we <= '1';
	-- 					image_buf(i,j)<= datain;
	-- 					ad := ad += "1"; 
	-- 				end loop;
	-- 			end loop; 
	-- 		end if;
	-- 	end process;
end controllerArc;