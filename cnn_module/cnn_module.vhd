library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity system is
	generic(
		WORDSIZE : integer := 16;
        WINDOWSIZE : integer := 5;
		ADDRESS_SIZE : integer := 16
		);
	port(
		clk : in std_logic ;
		start : in std_logic
	    );
end entity system;

ARCHITECTURE system_arch OF system is
    
	type buffer_type is array(0 TO 2**10-1) OF std_logic_vector(WORDSIZE-1 downto 0);
	signal buff : buffer_type;

	type ConvResult is array(0 TO 783) OF std_logic_vector(WORDSIZE-1 downto 0);
	signal conv_result : ConvResult;


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
    
    function conv (f : signed; w : signed)return signed is
        variable convresult : signed(16 downto 0):= (others => '0');
        variable tmp : signed(31 downto 0):= (others => '0');
        begin
            
        for i in 0 to WINDOWSIZE*WINDOWSIZE-1 loop
            tmp := (f((i+1)*16-1 downto i*16)) * (w((i+1)*16-1 downto i*16));
            if(to_integer(tmp(31 downto 22)) > 15) then 
                tmp := (others=>'1');
                tmp(31 downto 26) := (others=>'0');
            end if;
            if(to_integer(tmp(31 downto 22)) < -16) then
                tmp := (others=>'1');
                tmp(21 downto 0) := (others=>'0');
            end if;
            convresult := convresult + (tmp(26)&(tmp(26 downto 11)));
            if(to_integer(convresult(16 downto 11)) > 15) then 
                convresult := (others=>'1');
                convresult(16 downto 15) := "00";
            end if;
            if(to_integer(convresult(16 downto 11)) < -16) then
                convresult := (others=>'1');
                convresult(10 downto 0) := (others=>'0');
            end if;
        end loop;
        
        return convresult(15 downto 0);
        
        end function;
        
    
	begin
	-- RAM component --
	Ram_comp: ram generic map(WORDSIZE, ADDRESS_SIZE) port map(clk,we,ad,indata,outdata);
	-- controller --
	Control: controller generic map(WORDSIZE , ADDRESS_SIZE) port map(start,clk,indata,convR,poolR,we,ad,outdata,fil,img_W);		
	-- convolution --
	Convolute: convolution generic map(5) port map(fil,img_W,convR);
	-- pooling --
	Pooling: poolingFloat generic map(5) port map(img_W,poolR);


	-- Large Pooling
GEN_D_FF:
    for ROW in 0 to 27 generate
    begin
        GEN_D_FF0:
                for COL in 0 to 27 generate
                begin

                    conv_result(ROW * 28 + COL) <= conv(signed(fil) , signed(
                        buff(to_integer(unsigned((ROW) * 32 + (COL))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW) * 32 + (COL+1))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW) * 32 + (COL+2))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW) * 32 + (COL+3))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW) * 32 + (COL+4))))(15 downto 0) &
                        buff(to_integer(unsigned((ROW+1) * 32 + (COL))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+1) * 32 + (COL+1))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+1) * 32 + (COL+2))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+1) * 32 + (COL+3))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+1) * 32 + (COL+4))))(15 downto 0) &
                        buff(to_integer(unsigned((ROW+2) * 32 + (COL))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+2) * 32 + (COL+1))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+2) * 32 + (COL+2))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+2) * 32 + (COL+3))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+2) * 32 + (COL+4))))(15 downto 0) &
                        buff(to_integer(unsigned((ROW+3) * 32 + (COL))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+3) * 32 + (COL+1))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+3) * 32 + (COL+2))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+3) * 32 + (COL+3))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+3) * 32 + (COL+4))))(15 downto 0) &
                        buff(to_integer(unsigned((ROW+4) * 32 + (COL))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+4) * 32 + (COL+1))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+4) * 32 + (COL+2))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+4) * 32 + (COL+3))))(15 downto 0) &  
                        buff(to_integer(unsigned((ROW+4) * 32 + (COL+4))))(15 downto 0)     
                    ) 
                                    
                    );
                    -- DFF_X: convolution generic map(5) port map(fil,img_W,convR);

                  
            end generate;
    end generate;
end system_arch;