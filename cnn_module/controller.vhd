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
		ADDRESS_SIZE : integer := 16
		);
		port(
		start : in std_logic;
		clk : in std_logic;
		we : out std_logic;
		EWF : out std_logic;
		EWB : out std_logic;
		out_conv : out std_logic;
		enable_conv : out std_logic;
		out_pool : out std_logic;
		reset_Accumlator : out std_logic;
		filterAddress : out  std_logic_vector(ADDRESS_SIZE-1 downto 0);
		BuffAddress : out  std_logic_vector(ADDRESS_SIZE-1 downto 0);
		MemAddress : out  std_logic_vector(ADDRESS_SIZE-1 downto 0);
		ConvAddress : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
		PoolAddress : out  std_logic_vector(ADDRESS_SIZE-1 downto 0)
		);
end entity;

ARCHITECTURE controllerArc OF controller is
	--signal conv_buffer : signed(WORDSIZE*28*28-1 downto 0);
	--signal img_buffer : signed(WORDSIZE*32*32-1 downto 0);
	--signal pool_buffer : signed(WORDSIZE*14*14-1 downto 0);
	begin 
		
		process (start, clk) is
			variable c : Integer;
			variable MemAddr : std_logic_vector(ADDRESS_SIZE-1 downto 0);
			variable BuffAddr : std_logic_vector(ADDRESS_SIZE-1 downto 0);
			variable filterAddr : std_logic_vector(ADDRESS_SIZE-1 downto 0);
			variable ConvAddr : std_logic_vector(ADDRESS_SIZE-1 downto 0);
			variable PoolAddr : std_logic_vector(ADDRESS_SIZE-1 downto 0);
			variable layerCounter : Integer;
			variable wordsCount : Integer;
			variable img_loaded : Integer;
			variable filter_loaded : Integer;
			begin 
				if rising_edge(start) then 
					--intialization
					c := 0;
					Layercounter := 0;
					wordsCount := 0;
					MemAddr := (others=>'0');
					BuffAddr := (others=>'0');
					filterAddr := (others=>'0');
					ConvAddr := (others=>'0');
					PoolAddr := (others=>'0');
					MemAddress <= MemAddr;
					BuffAddress <= BuffAddr;
					filterAddress <= filterAddr;
					ConvAddress  <= ConvAddr;
					PoolAddress  <= PoolAddr;
					EWB <= '1';
					EWF <= '0';
					out_conv <= '0';
					we <= '0';
					enable_conv <= '0';
					out_pool <= '0';
					reset_Accumlator <= '1';
					img_loaded := 0;
					filter_loaded := 0;
				end if;
				if rising_edge(clk) then
					-- layer 0 --
					if wordsCount < 1024 and img_loaded = 0 then
						-- load image --
						MemAddr := MemAddr + X"0001";
						BuffAddr := BuffAddr + X"0001";
						MemAddress <= MemAddr;
						BuffAddress <= BuffAddr;
						wordsCount := wordsCount + 1;
						if 	wordsCount = 1024 then
							img_loaded := 1;
							EWF <= '1';
							EWB <= '0';
							wordsCount := 0;
						end if;
					elsif img_loaded = 1 and filter_loaded = 0 then
						MemAddr := MemAddr + X"0001";
						filterAddr := filterAddr + X"0001";
						MemAddress <= MemAddr;
						filterAddress <= filterAddr;
						wordsCount := wordsCount + 1;
						if wordsCount = 25 then
							filter_loaded := 1;
							EWF <= '0';
							wordsCount := 0;
						end if;
					end if;  		
				end if;
		end process;
end controllerArc;