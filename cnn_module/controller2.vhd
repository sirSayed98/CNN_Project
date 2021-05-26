-- 
-- Layer counter
-- Depth counter
-- Filter counter 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

 Entity controller2 is 
		generic(
		ADDRESS_SIZE : integer := 20;
		WORDSIZE : integer := 16;
		IMMEDIATE_START_ADDRESS : integer := 51575
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
		MemAddr : out  std_logic_vector(ADDRESS_SIZE-1 downto 0);
		ConvAddress : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
		PoolAddress : out  std_logic_vector(ADDRESS_SIZE-1 downto 0)
		);
end entity;

ARCHITECTURE controller2Arc OF controller2 is

	--signal conv_buffer : signed(WORDSIZE*28*28-1 downto 0);
	--signal img_buffer : signed(WORDSIZE*32*32-1 downto 0);
	--signal pool_buffer : signed(WORDSIZE*14*14-1 downto 0);
	-- * IMMEDIATE_START_ADDRESS = 3575 + 16 * 120 * 5 * 5 = 51575

	-- type small_rom is array (0 to 4) of std_logic_vector(WORDSIZE-1 downto 0);
	type small_rom is array (0 to 4) of integer range 0 to 2**WORDSIZE - 1;
	-- small_rom: signed(5*16-1 downto 00
	-- IMMEDIATE_START_ADDRESS = 3575 + 16 * 120 * 5 * 5 = 51575
 -- signal layer_type_rom : small_rom := ("0000","0001","0000","0001",  ); -- 0 is convolution 1 pooling

	signal layer_type_rom : small_rom := (0,1,0,1,0); -- 0 is convolution 1 pooling

	signal input_start_address_rom : small_rom := (
	0,	-- input of conv
	IMMEDIATE_START_ADDRESS , -- input to pool
	IMMEDIATE_START_ADDRESS +784*1, -- input to conv
	IMMEDIATE_START_ADDRESS +784+196*6,	-- input to  pool 
	IMMEDIATE_START_ADDRESS +1960+16*100 -- input to conv
	);
	signal input_size_rom : small_rom := (1024,784,14*14,100,5*5); -- size of image in each layer


	signal output_start_address_rom : small_rom := (
		IMMEDIATE_START_ADDRESS ,
		IMMEDIATE_START_ADDRESS +784*1,
		IMMEDIATE_START_ADDRESS +784+196*6,
		IMMEDIATE_START_ADDRESS +1960+16*100,
		IMMEDIATE_START_ADDRESS +3560+25);
	signal output_size_rom : small_rom := (784,196,100,5*5,1);
	signal filter_start_address_rom : small_rom := (1024,0,1174,0,3575);
	signal max_feature_maps_rom : small_rom := (6,6,16,16,120);
	signal max_depth_rom : small_rom := (1,0,6,0,16);
	signal current_layer_sig : integer range 0 to 4 := 0;
	

	-- these are the input to convolution and to pooling
	
	signal input_start_address : integer range 0 to 2**WORDSIZE - 1 := 0; 
	signal input_size : integer range 0 to 2**WORDSIZE - 1 := 0; -- this is the input of 2D Image or matrix
	signal output_start_address : integer range 0 to 2**WORDSIZE - 1 := 0; -- this the first place to write to the output
	signal output_size : integer range 0 to 2**WORDSIZE - 1 := 0; -- the output of 1 feature map convolved
	signal filter_start_address: integer range 0 to 2**WORDSIZE - 1 := 0; -- the address of the 1st filter
	signal max_feature_maps : integer range 0 to 2**WORDSIZE - 1 := 0;  -- eg. 16 
	signal max_depth : integer range 0 to 2**WORDSIZE - 1 := 0;



	begin 		

		-- process (current_layer_sig) is
		-- begin
		-- 	feature := 0;

		-- 	if layer_type_rom(current_layer_sig) = 0 then 
		-- 			--intialization convolution
		-- 			input_start_address <= input_start_address_rom(current_layer_sig);
		-- 			input_size <= input_size_rom(current_layer_sig);
		-- 			output_start_address <= output_start_address_rom(current_layer_sig);
		-- 			output_size <= output_size_rom(current_layer_sig);
		-- 			filter_start_address <= filter_start_address_rom(current_layer_sig);
		-- 			max_feature_maps <= max_feature_maps_rom(current_layer_sig);
		-- 			max_depth <= max_depth_rom(current_layer_sig);
					
		-- 	elsif layer_type_rom(current_layer_sig) = 1 then
		-- 			-- intialize pooling
		-- 			input_start_address <= input_start_address_rom(current_layer_sig);
		-- 			input_size <= input_size_rom(current_layer_sig);
		-- 			output_start_address <= output_start_address_rom(current_layer_sig);
		-- 			output_size <= output_size_rom(current_layer_sig);
		-- 			filter_start_address <= filter_start_address_rom(current_layer_sig);
		-- 			max_feature_maps <= max_feature_maps_rom(current_layer_sig);
		-- 			max_depth <= max_depth_rom(current_layer_sig);					
		-- 	end if;
			
		-- end process;

		process (start, clk, current_layer_sig) is
			variable MemAddr : std_logic_vector(ADDRESS_SIZE-1 downto 0);
			variable BuffAddr : std_logic_vector(ADDRESS_SIZE-1 downto 0);
			variable filterAddr : std_logic_vector(ADDRESS_SIZE-1 downto 0);
			variable ConvAddr : std_logic_vector(ADDRESS_SIZE-1 downto 0);
			variable PoolAddr : std_logic_vector(ADDRESS_SIZE-1 downto 0);
			variable layerCounter : Integer;
			variable wordsCount : Integer;
			variable img_loaded : Integer;
			variable filter_loaded : Integer;
			variable feature : Integer;
			variable depth : Integer;
			variable image_loaded : Integer;
			variable filter_loaded : Integer;
			begin 
				if rising_edge(start) then 
					--intialization
						current_layer_sig <= 0;
						feature := 0;
						depth := 0;	
						image_loaded := 0;
						filter_loaded := 0;	
						EWB <= '0';
						EWF	<= '0';
						wordsCount := 0;		
				end if;
				if rising_edge(clk) then 


					if layer_type_rom(current_layer_sig) = 0 then 
					--intialization convolution
						input_start_address <= input_start_address_rom(current_layer_sig);
						input_size <= input_size_rom(current_layer_sig);
						output_start_address <= output_start_address_rom(current_layer_sig);
						output_size <= output_size_rom(current_layer_sig);
						filter_start_address <= filter_start_address_rom(current_layer_sig);
						max_feature_maps <= max_feature_maps_rom(current_layer_sig);
						max_depth <= max_depth_rom(current_layer_sig);
						if image_loaded = 0 then
							-- read from memory --
							we <= '0';
							-- Load Input from MemAddr = input_start_address + input_size * feature 
							EWB <= '1';
							MemAddr <= input_start_address  ;
							-- wordCount ++
							-- if wordCount = input size EWB  = 0 image_Loaded = 1
						elsif filter_loaded = 0 then
							EWF <= '1';
							MemAddr <= filter_start_address ;
							-- MemAddr ++
							-- if MemAddr = filter size EWF  = 0 image_Loaded = 1
						elsif feature < max_feature_maps then
							if depth < max_depth then					
								
								-- reset_acummulator=0	// has no effect when accumulating
								reset_Accumlator = '0';
								
								-- enable_convolve=0
								
								
								-- enalble_convolve = 1
								
								
								
								-- enable_convolve=0 // now data in buffers
							end if;
							--store output at MemAddr = output_start_address + output_size*feature
						else
							 --current_layer_counter+=1
						end if;
					elsif layer_type_rom(current_layer_sig) = 1 then
							--intialize pooling
							input_start_address <= input_start_address_rom(current_layer_sig);
							input_size <= input_size_rom(current_layer_sig);
							output_start_address <= output_start_address_rom(current_layer_sig);
							output_size <= output_size_rom(current_layer_sig);
							filter_start_address <= filter_start_address_rom(current_layer_sig);
							max_feature_maps <= max_feature_maps_rom(current_layer_sig);
							max_depth <= max_depth_rom(current_layer_sig);
							if feature < max_feature_maps then
								-- Load Input from MemAddr = input_start_address + input_size * feature 
								-- OUT_POOL=1
								-- store output at MemAddr = output_start_address + output_size*feature
								-- OUT_POOL = 0
							else
								-- current_layer_counter+=1
							end if;
					end if;
				end if;
				-- if start = 1 and rising_edge(clk) then
				-- 	if layer_type_rom(0) = 0 then 
				-- 		--do the convolution 
					

						
				-- 	elsif layer_type_rom(0) = 1 then
				-- 	-- do the  pooling
							
				-- 	end if;
					
				-- end if;
					-- wordsCount := 0;
					-- MemAddr := (others=>'0');
					-- BuffAddr := (others=>'0');
					-- filterAddr := (others=>'0');
					-- ConvAddr := (others=>'0');
					-- PoolAddr := (others=>'0');
					-- MemAddr <= MemAddr;
					-- BuffAddress <= BuffAddr;
					-- filterAddress <= filterAddr;
					-- ConvAddress  <= ConvAddr;
					-- PoolAddress  <= PoolAddr;
					-- EWB <= '1';
					-- EWF <= '0';
					-- out_conv <= '0';
					-- we <= '0';
					-- enable_conv <= '0';
					-- out_pool <= '0';
					-- reset_Accumlator <= '1';
					-- img_loaded := 0;
					-- filter_loaded := 0;
				-- end if;
				--if rising_edge(clk) then
					-- layer 0 --
					-- if wordsCount < 1024 and img_loaded = 0 then
					-- 	-- load image --
					-- 	MemAddr := MemAddr + X"0001";
					-- 	BuffAddr := BuffAddr + X"0001";
					-- 	MemAddr <= MemAddr;
					-- 	BuffAddress <= BuffAddr;
					-- 	wordsCount := wordsCount + 1;
					-- 	if 	wordsCount = 1024 then
					-- 		img_loaded := 1;
					-- 		EWF <= '1';
					-- 		EWB <= '0';
					-- 		wordsCount := 0;
					-- 	end if;
					-- elsif img_loaded = 1 and filter_loaded = 0 then
					-- 	MemAddr := MemAddr + X"0001";
					-- 	filterAddr := filterAddr + X"0001";
					-- 	MemAddr <= MemAddr;
					-- 	filterAddress <= filterAddr;
					-- 	wordsCount := wordsCount + 1;
					-- 	if wordsCount = 25 then
					-- 		filter_loaded := 1;
					-- 		EWF <= '0';
					-- 		wordsCount := 0;
					-- 	end if;
					-- end if;  		
				--end if;
		end process;
end controller2Arc;