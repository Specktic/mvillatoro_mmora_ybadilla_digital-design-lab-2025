-- Adder de 1 bit
entity FullAdder is
	Port(x, y, Cin : in bit;
		  Cout, Sum : out bit);
end FullAdder;

architecture full_adder of FullAdder is
begin
	Sum <= x xor y xor Cin;
	Cout <= (x and y) or (y and Cin) or (x and Cin);
end fulladder;

