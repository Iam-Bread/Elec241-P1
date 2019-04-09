-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
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

begin

	variable count : integer := 0; 
	process(clk,reset)    --sensitivity list
	begin
		if(reset = '0')then		--asynchronous reset to default values
			ANGLE <= (others=>'0') ;
			MOTORA <= '0';
			MOTORB <= '0';
		elsif(STATE = '1')then
			if(SETANGLE <= MAX_ANGLE)then	--check if angle is valid
				if(count = SETANGLE)then
					MOTORA <= '0';
					MOTORB <= '0';
					count := '0';
				elsif(SETANGLE > ANGLE)then	--check what direction to go 
					MOTORA <= '1';			--go Clockwise
					MOTORB <= '0';
				elsif(SETANGLE < ANGLE)then
					MOTORA <= '0';			--go anticlockwise
					MOTORB <= '1';
				end if;
			end if;
		end if;
	end process;

	counter: process(OPTOA,OPTOB)
	begin
		if(rising_edge(OPTOA))then
			count := count + 1;
		else
			if(rising_edge(OPTOB))then
				count := count + 1;
			end if;
		end if;
		
	end process counter;
end logic;