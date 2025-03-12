library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- sumador 1 bit
entity FullAdder is
    Port (x, y, Cin : in std_logic;
          Cout, Sum : out std_logic);
end FullAdder;

architecture Behavioral of FullAdder is
begin
    Sum  <= x xor y xor Cin;
    Cout <= (x and y) or (y and Cin) or (x and Cin);
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- sumador 4 bits
entity Adder4 is
    Port (SW : in std_logic_vector(7 downto 0);	-- switches
          HEX0, HEX1 : out std_logic_vector(6 downto 0));	-- 7-segmentos
end Adder4;

architecture Behavioral of Adder4 is

    component FullAdder
        Port(x, y, Cin : in std_logic;
             Cout, Sum : out std_logic);
    end component;

    signal A, B, S : std_logic_vector(3 downto 0);
    signal C : std_logic_vector(3 downto 0);	-- carry
    signal Co : std_logic;
	 signal result : std_logic_vector(4 downto 0);	-- resultado

begin

    A  <= SW(3 downto 0);
    B  <= SW(7 downto 4);
	 C(0) <= '0';	-- carry 0

    -- 4 sumadores 1 bit
    FA0 : FullAdder port map(A(0), B(0), C(0), C(1), S(0));
    FA1 : FullAdder port map(A(1), B(1), C(1), C(2), S(1));
    FA2 : FullAdder port map(A(2), B(2), C(2), C(3), S(2));
    FA3 : FullAdder port map(A(3), B(3), C(3), Co, S(3));
	 
	 -- resultado final
	 result <= Co & S;

     -- decoder HEX0 
    process(result(3 downto 0))
    begin
        case result(3 downto 0) is
            when "0000" => HEX0 <= "1000000"; -- 0
            when "0001" => HEX0 <= "1111001"; -- 1
            when "0010" => HEX0 <= "0100100"; -- 2
            when "0011" => HEX0 <= "0110000"; -- 3
            when "0100" => HEX0 <= "0011001"; -- 4
            when "0101" => HEX0 <= "0010010"; -- 5
            when "0110" => HEX0 <= "0000010"; -- 6
            when "0111" => HEX0 <= "1111000"; -- 7
            when "1000" => HEX0 <= "0000000"; -- 8
            when "1001" => HEX0 <= "0010000"; -- 9
            when "1010" => HEX0 <= "0001000"; -- A
            when "1011" => HEX0 <= "0000011"; -- B
            when "1100" => HEX0 <= "1000110"; -- C
            when "1101" => HEX0 <= "0100001"; -- D
            when "1110" => HEX0 <= "0000110"; -- E
            when "1111" => HEX0 <= "0001110"; -- F
            when others => HEX0 <= "1111111"; -- Blank
        end case;
    end process;

    -- decoder HEX1
    process(result(4))
    begin
        case result(4) is
            when '0' => HEX1 <= "1000000"; -- 0
            when '1' => HEX1 <= "1111001"; -- 1
            when others => HEX1 <= "1111111"; -- Blank
        end case;
    end process;

end Behavioral;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity tb_Adder4 is
end tb_Adder4;

architecture behavior of tb_Adder4 is

    -- Component declaration for the Unit Under Test (UUT)
    component Adder4
        Port (SW : in std_logic_vector(7 downto 0);
              HEX0, HEX1 : out std_logic_vector(6 downto 0));
    end component;

    -- Signals for connecting to the UUT
    signal SW : std_logic_vector(7 downto 0);
    signal HEX0, HEX1 : std_logic_vector(6 downto 0);

begin

    -- Instantiate the UUT
    uut: Adder4 PORT MAP (SW => SW,
								  HEX0 => HEX0,
								  HEX1 => HEX1);

    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: 3 + 5 (00000011 + 00000101)
        SW <= "00000011";  -- A = 3, B = 5
        WAIT FOR 10 ns;

        -- Test case 2: 15 + 7 (00001111 + 00000111)
        SW <= "00001111";  -- A = 15, B = 7
        WAIT FOR 10 ns;

        -- Test case 3: 8 + 6 (00001000 + 00000110)
        SW <= "00001000";  -- A = 8, B = 6
        WAIT FOR 10 ns;

        -- Test case 4: 0 + 0 (00000000 + 00000000)
        SW <= "00000000";  -- A = 0, B = 0
        WAIT FOR 10 ns;

        -- Test case 5: 15 + 15 (00001111 + 00001111)
        SW <= "00001111";  -- A = 15, B = 15
        WAIT FOR 10 ns;

        -- Test case 6: 9 + 8 (00001001 + 00001000)
        SW <= "00001001";  -- A = 9, B = 8
        WAIT FOR 10 ns;

        -- End of simulation
        WAIT;
    end process;

end behavior;

