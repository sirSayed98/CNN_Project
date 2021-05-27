library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity pooling is
	generic(
		WINDOWSIZE : integer := 2
	);
	port(
	window : in signed(WINDOWSIZE*WINDOWSIZE*16-1 downto 0);
	sum : out signed(15 downto 0)
	);
end entity;

ARCHITECTURE Pool_arc of pooling is 

function average (s : integer; w : signed)return signed is
variable result : signed(16 downto 0):= (others => '0');

begin
	
for i in 0 to WINDOWSIZE*WINDOWSIZE-1 loop
	-- cocant w in add with w of ((i+1)*16-1)
	result := result + (w((i+1)*16-1) & w(((i+1)*16-1)downto((i+1)*16-16)));
	if(to_integer(result(16 downto 11)) > 15) then 
		result := (others=>'1');
		result(16 downto 15) := "00";
	end if;
	if(to_integer(result(16 downto 11)) < -16) then
		result := (others=>'1');
		result(10 downto 0) := (others=>'0');
	end if;
end loop;

--  if s = 3 then
-- 	result := "0"&(result(15)&result(15)&result(15)) & result(15 downto 3);
--else
    result := "0"&(result(15)&result(15)&result(15)&result(15)&result(15)) & result(15 downto 5);
--end if;

return result(15 downto 0);

end function;


begin

sum <= average(WINDOWSIZE , window);

end ARCHITECTURE;
