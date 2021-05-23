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
		convResult : in signed(WORDSIZE-1 downto 0);
		poolResult: in signed(WORDSIZE-1 downto 0);
		we : out std_logic;
		address : out  std_logic_vector(ADDRESS_SIZE-1 downto 0);
		dataout : out std_logic_vector(WORDSIZE-1 downto 0);
		filter : out signed(WORDSIZE*5*5-1 downto 0);
		image_window : out signed(WORDSIZE*5*5-1 downto 0)
		);
end entity;

ARCHITECTURE controllerArc OF controller is
	signal conv_buffer : signed(WORDSIZE*28*28-1 downto 0);
	signal img_buffer : signed(WORDSIZE*32*32-1 downto 0);
	signal pool_buffer : signed(WORDSIZE*14*14-1 downto 0);

	begin 
		process (start, clk) is
			variable layerCounter : signed(2 downto 0);
			variable depthCounter : signed(4 downto 0);
			variable filterCounter : signed(7 downto 0);
			variable wordCount : signed(15 downto 0); 	-- number of words to read
			variable mem_address : std_logic_vector(15 downto 0); 	-- number of words to read
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
					wordCount := to_signed(32*32, 16);
					mem_address :=  (others => '0');
					
					iLoaded := '0';
					fLoaded := '0';
					address <= x"00";
					index := 0;
				end if;
					
				if rising_edge(clk) then
					if Layercounter = O"0" then
						if  iLoaded = '0' then   
							img_buffer((1 + index) * 16 - 1 downto index * 16)  <= signed(datain);
							index := index + 1;
							mem_address := mem_address + 1;
							address <= mem_address;
							if index = wordCount then
								iLoaded := '1';
								wordCount := to_signed(25, 16);
								-- Assumed filter is after image
								index := 0;
							end if;
						elsif fLoaded = '0' then
							filter((1 + index) * 16 - 1 downto index * 16)  <= signed(datain);
							index := index +1;
							mem_address := mem_address + 1;
							address <= mem_address;
							if index = wordCount then
								fLoaded := '1';
								wordCount := to_signed(25, 16);
								-- Assumed filter is after image
								index := 0;
								end if;
						else 
							image_window <= img_buffer((1 + index) * 16*5*5 - 1 downto index *16*5*5);
							conv_buffer((1 + index)*16-1 downto index*16) <= convResult;
							index := index + 1;
						end if;
					end if;
					
					-- load the image
					-- load filters 
					-- convolve 
					-- save result
				end if;
			end process;
end controllerArc;