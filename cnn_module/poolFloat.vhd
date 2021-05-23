library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
Entity poolingFloat is
	generic(
		WINDOWSIZE : integer := 3
	);
	port(
	size : in integer;
	window : in std_logic_vector(WINDOWSIZE*WINDOWSIZE*16-1 downto 0);
	sum : out std_logic_vector(15 downto 0)
	);
end entity;

ARCHITECTURE Pool_arc of poolingFloat is 

function average (s : integer; w : std_logic_vector)return std_logic_vector is
variable result : std_logic_vector(15 downto 0):= (others => '0');

begin
	
for i in 0 to s*s-1 loop
	result := result + w(((i+1)*16-1)downto((i+1)*16-16));
end loop;

if s = 3 then
	result := (result(15)&result(15)&result(15)) & result(15 downto 3);
else    result := (result(15)&result(15)&result(15)&result(15)&result(15)) & result(15 downto 5);
end if;

return result;

end function;


begin

sum <= average(size , window);

end ARCHITECTURE;