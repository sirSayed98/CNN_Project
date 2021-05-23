library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity convolution is
	generic(
		WINDOWSIZE : integer := 3
	);
	port(
	filter : in signed(WINDOWSIZE*WINDOWSIZE*16-1 downto 0);
	window : in signed(WINDOWSIZE*WINDOWSIZE*16-1 downto 0);
	result : out signed(15 downto 0)
	);
end entity;

ARCHITECTURE convolution_arc of convolution is 

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

result <= conv(filter , window);

end ARCHITECTURE;