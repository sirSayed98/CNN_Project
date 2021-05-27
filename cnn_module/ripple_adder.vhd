library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity ripple_adder is
  generic (
    SIZE : integer := 8
    );
	port (
    op1, op2 : in signed(SIZE-1 downto 0);
    cin : in signed;
    result : out  signed(SIZE-1 downto 0);
    cout : out signed
    );
end ripple_adder;

-- Architecture
architecture ripple_adder_0 of ripple_adder is 

-----------------------------------Declarations--------------------------------
component full_adder is
  port (
    a,b,cin : in  signed;
    s, cout : out signed );
end component;

-----------------------------------Signals-------------------------------------
signal carry_temp : signed(SIZE-1 DOWNTO 0);

begin

  --generate the full adders
  Adders_output_0: full_adder port map(op1(0 downto 0), op2(0 downto 0), cin, result(0 downto 0), carry_temp(0 downto 0));
  adders: for i in 1 to SIZE-1 generate
    Adder_output: full_adder port map(op1(i downto i), op2(i downto i), carry_temp(i-1 downto i-1), result(i downto i), carry_temp(i downto i));
  end generate;
  cout <= carry_temp(SIZE-1 downto SIZE -1);

end ripple_adder_0;
