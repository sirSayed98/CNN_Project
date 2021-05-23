
library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity system is
	generic(
		WORDSIZE : integer := 16;
		ADDRESS_SIZE : integer := 16
		);
	port(
		clk : in std_logic ;
		start : in std_logic
	    );
end entity system;

ARCHITECTURE system_arch OF system is
	component ram is
		GENERIC (WORDSIZE : integer := 16;
				ADDRESS_SIZE : integer := 16
		);
		port(
			clk : in std_logic;
			we  : in std_logic;
			address : in  std_logic_vector(ADDRESS_SIZE-1 downto 0);
			datain  : in  std_logic_vector(WORDSIZE-1 downto 0);
			dataout : out std_logic_vector(WORDSIZE-1 downto 0)
		);
	end component;
	component controller is 
	   	GENERIC(
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
	end component;
	component convolution is
		generic(
			WINDOWSIZE : integer := 5
		);
		port(
		filter : in signed(WINDOWSIZE*WINDOWSIZE*16-1 downto 0);
		window : in signed(WINDOWSIZE*WINDOWSIZE*16-1 downto 0);
		result : out signed(15 downto 0)
		);
	end component;
	component poolingFloat is
		generic(
			WINDOWSIZE : integer := 5
		);
		port(
		window : in signed(WINDOWSIZE*WINDOWSIZE*16-1 downto 0);
		sum : out signed(15 downto 0)
		);
	end component;
	signal we :  std_logic;
	signal ad :  std_logic_vector(ADDRESS_SIZE-1 downto 0);
	signal indata  :   std_logic_vector(WORDSIZE-1 downto 0);
	signal outdata  :  std_logic_vector(WORDSIZE-1 downto 0);
	signal convR :  signed(WORDSIZE-1 downto 0);
	signal poolR: signed(WORDSIZE-1 downto 0);
	signal fil : signed(WORDSIZE*5*5-1 downto 0);
	signal img_W : signed(WORDSIZE*5*5-1 downto 0);
	begin
	-- RAM component --
	Ram_comp: ram generic map(WORDSIZE, ADDRESS_SIZE) port map(clk,we,ad,indata,outdata);
	-- controller --
	Control: controller generic map(WORDSIZE , ADDRESS_SIZE) port map(start,clk,indata,convR,poolR,we,ad,outdata,fil,img_W);		
	-- convolution --
	Convolute: convolution generic map(5) port map(fil,img_W,convR);
	-- pooling --
	Pooling: poolingFloat generic map(5) port map(img_W,poolR);
end system_arch;