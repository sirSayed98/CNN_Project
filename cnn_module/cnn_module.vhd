
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity system is
	generic (
		WORDSIZE     : integer := 16;
		WINDOWSIZE   : integer := 5;
		ADDRESS_SIZE : integer := 16
	);
	port (
		clk   : in std_logic;
		start : in std_logic;
		reset : in std_logic;
		done  : out std_logic
	);
end entity system;

architecture system_arch of system is
	component ram is
		generic (
		WORDSIZE     : integer := 16;
		ADDRESS_SIZE : integer := 16
		);
		port (
		clk     : in std_logic;
		we      : in std_logic;
		address : in std_logic_vector(ADDRESS_SIZE - 1 downto 0);
		datain  : in std_logic_vector(WORDSIZE - 1 downto 0);
		dataout : out std_logic_vector(WORDSIZE - 1 downto 0)
		);
	end component;
	component controller2 is
		generic (
		ADDRESS_SIZE : integer := 16
		);
		port (
		start            : in std_logic;
		clk              : in std_logic;
		reset            : in std_logic;
		we               : out std_logic;
		EWF              : out std_logic;
		EWB              : out std_logic;
		out_conv         : out std_logic;
		enable_conv      : out std_logic;
		out_pool         : out std_logic;
		done             : out std_logic;
		reset_Accumulator : out std_logic;
		filterAddress    : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
		BuffAddress      : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
		MemAddress       : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
		ConvAddress      : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
		PoolAddress      : out std_logic_vector(ADDRESS_SIZE - 1 downto 0)
		);
	end component;
	component Buff is
		generic (
		WORD_SIZE    : integer := 16;
		WINDOW_SIZE  : integer := 3;
		ADDRESS_SIZE : integer := 16
		);
		port (
		buffAddress : in signed(ADDRESS_SIZE - 1 downto 0);
		datain      : in signed(WORD_SIZE - 1 downto 0);
		enable      : in std_logic;
		clk         : in std_logic;
		data        : out signed(WINDOW_SIZE * WINDOW_SIZE * WORD_SIZE - 1 downto 0)
		);
	end component;
	component convolution is
		generic (
		WINDOWSIZE : integer := 3
		);
		port (
		enable : in std_logic;
		filter : in signed(WINDOWSIZE * WINDOWSIZE * 16 - 1 downto 0);
		window : in signed(WINDOWSIZE * WINDOWSIZE * 16 - 1 downto 0);
		result : out signed(15 downto 0)
		);
	end component;
	component Concat is
		generic (
		WORD_SIZE : integer := 16
		);
		port (
		arr1   : in signed(15 downto 0);
		arr2   : in signed(15 downto 0);
		arr3   : in signed(15 downto 0);
		arr4   : in signed(15 downto 0);
		arr5   : in signed(15 downto 0);
		result : out signed(16 * 5 - 1 downto 0)
		);
	end component;
	signal we                                                               : std_logic;
	signal EWF, EWB, out_conv, enable_conv, out_pool, reset_Accumulator      : std_logic;
	signal indata                                                           : std_logic_vector(WORDSIZE - 1 downto 0);
	signal outdata                                                          : std_logic_vector(WORDSIZE - 1 downto 0);
	signal imgdata                                                          : signed(32 * 32 * WORDSIZE - 1 downto 0)         := (others => '0');
	signal filter_data                                                      : signed(5 * 5 * WORDSIZE - 1 downto 0)           := (others => '0');
	signal convResult                                                       : signed(28 * 28 * WORDSIZE - 1 downto 0)         := (others => '0');
	signal help                                                             : signed(28 * 28 * 5 * 5 * WORDSIZE - 1 downto 0) := (others => 'U');
	signal filterAddress, BuffAddress, MemAddress, ConvAddress, PoolAddress : std_logic_vector(ADDRESS_SIZE - 1 downto 0);
begin
	-- RAM component --
	Ram_comp : ram generic map(WORDSIZE, ADDRESS_SIZE) port map(clk, we, (MemAddress), outdata, indata);
	-- controller component--
	Control : controller2 generic map(ADDRESS_SIZE) port map(start, clk, reset, we, EWF, EWB, out_conv, enable_conv, out_pool, done, reset_Accumulator, filterAddress, BuffAddress, MemAddress, ConvAddress, PoolAddress);
	-- Image Buffer component--
	Img_Buffer : Buff generic map(WORDSIZE, 32, ADDRESS_SIZE) port map(signed(BuffAddress), signed(indata), EWB, clk, (imgdata));
	-- Filter Buffer component--
	Filter_Buffer : Buff generic map(WORDSIZE, 5, ADDRESS_SIZE) port map(signed(filterAddress), signed(indata), EWF, clk, (filter_data));
	Conv_REG :
	for i in 0 to 27 generate
		A :
		for j in 0 to 27 generate
		concat1 : Concat port map(
			imgdata(((i * 32 + j + 5) * 16) - 1 downto (i * 32 + j) * 16),
			imgdata((((i + 1) * 32 + j + 5) * 16) - 1 downto ((i + 1) * 32 + j) * 16),
			imgdata((((i + 2) * 32 + j + 5) * 16) - 1 downto ((i + 2) * 32 + j) * 16),
			imgdata((((i + 3) * 32 + j + 5) * 16) - 1 downto ((i + 3) * 32 + j) * 16),
			imgdata((((i + 4) * 32 + j + 5) * 16) - 1 downto ((i + 4) * 32 + j) * 16),
			help((i * 28 + j + 25) * 16 - 1 downto (i * 28 + j) * 16));
		conv : convolution generic map(
			5) port map(enable_conv, filter_data,
			help((i * 28 + j + 25) * 16 - 1 downto (i * 28 + j) * 16),
			convResult((i * 28 + j + 1) * 16 - 1 downto (i * 28 + j) * 16));--index of convResult
		end generate A;
	end generate Conv_REG;
	outdata <= std_logic_vector(convResult((to_integer(unsigned(ConvAddress)) + 1) * 16 - 1 downto to_integer(unsigned(ConvAddress)) * 16)) when out_conv = '1'
		else (others => 'Z');

end architecture;