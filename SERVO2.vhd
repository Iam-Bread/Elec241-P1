-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;

entity SERVO is
	generic
	(
        -- Constants
		DATA_WIDTH	: integer  := 12;
		MAX_ANGLE	: integer  := 3018
	);
	port
	(
		-- Inputs
		STATE : in std_logic; --1 is on, 0 is off
		SETANGLE : in  std_logic_vector(DATA_WIDTH-1 DOWNTO 0);

		--optical encoder inputs
		OPTOA : in std_logic;	
		OPTOB : in std_logic;

		clk : in std_logic;
        reset : in  std_logic;

		-- Outputs
		--outputs connected to hbridge to control motor
		MOTORA : out std_logic;
		MOTORB : out std_logic;

		ANGLE : out std_logic_vector(DATA_WIDTH DOWNTO 0)
	);
end SERVO;

architecture logic of SERVO is
	signal countA : std_logic_vector(DATA_WIDTH DOWNTO 0) :=(others => '0');



begin
	ANGLE <= countA;

	process(STATE,clk,reset)    --sensitivity list
	begin
		if(reset = '0')then		--asynchronous reset to default values
			--count <= (others=>'0') ;
			MOTORA <= '0';
			MOTORB <= '0';
		elsif(rising_edge(clk))then
			if(STATE = '1')then
				if(to_integer(unsigned(SETANGLE)) <= MAX_ANGLE)then	--check if angle is valid
					if(countA = SETANGLE)then
						MOTORA <= '0';
						MOTORB <= '0';
					elsif(unsigned(SETANGLE) > unsigned(countA))then	--check what direction to go 
						MOTORA <= '1';			--go Clockwise
						MOTORB <= '0';
					elsif(unsigned(SETANGLE) < unsigned(countA))then
						MOTORA <= '0';			--go anticlockwise
						MOTORB <= '1';
					end if;
				end if;
			end if;
		end if;
	end process;

	counterA: process(OPTOA)	
	begin	
		if(rising_edge(OPTOA))then	--wait for rising edge of A
			if(unsigned(SETANGLE) > unsigned(countA))then
				countA <= std_logic_vector(unsigned(countA) + 1);		--increment the count value
			else 
				countA <= std_logic_vector(unsigned(countA) - 1);		--decrement the count value
			end if;
		end if;
	end process counterA;


end logic;