library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Adder de 1 bit
entity FullAdder is
	Port(x, y, Cin : in std_logic;
		  Cout, Sum : out std_logic);
end FullAdder;

architecture full_adder of FullAdder is
begin
	Sum <= x xor y xor Cin;
	Cout <= (x and y) or (y and Cin) or (x and Cin);
end full_adder;

entity Adder4 is
	Port(A, B : in std_logic_vector(3 downto 0);
		  Ci : in std_logic;
		  S : out std_logic_vector(3 downto 0);
		  Co : out std_logic);
	end Adder4;
	
architecture adder_4 of Adder4 is
component FullAdder
	Port(x, y, Cin : in std_logic;
		  Cout, Sum : out std_logic);
end component;
signal C : bit_vector(3 downto 1);
begin
	FA0 : FullAdder port map( A(0), B(0), Ci, C(1), S(0));
	FA1 : FullAdder port map( A(1), B(1), C(1), C(2), S(1));
	FA2 : FullAdder port map( A(2), B(2), C(2), C(3), S(2));
	FA3 : FullAdder port map( A(3), B(3), C(3), Co, S(3));
end adder_4;