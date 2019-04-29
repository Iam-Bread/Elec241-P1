-- Quartus Prime VHDL Template
-- Four-State Mealy State Machine

-- A Mealy machine has outputs that depend on both the state and
-- the inputs.	When the inputs change, the outputs are updated
-- immediately, without waiting for a clock edge.  The outputs
-- can be written more than once per state or per clock cycle.

library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity AngleTracker is
		generic
	(
        -- Constants
		DATA_WIDTH	: integer  := 12;
		maxAngle : natural := 3017
	);
	port
	(
		clk		 : in	std_logic;
		OPTOA	 : in	std_logic;
		OPTOB	 : in	std_logic;
		
		A	 : in	std_logic;
		B	 : in	std_logic;

		ANGLE	 : out natural range 0 to maxAngle

		
	);

end entity;

architecture logic of AngleTracker is

	-- Build an enumerated type for the state machine
	type state_type is (s0,a1,a2,a3,a4,b1,b2,b3,b4);

	-- Register to hold the current state
	signal state : state_type := s0;
	signal current_angle : natural range 0 to maxAngle;
	signal currentDirection : std_logic;


begin

	ANGLE <= current_angle;
	
	process (clk, OPTOA, OPTOB)
	begin

		if (rising_edge(clk)) then
			case state is
				when s0=>
					if(A = '1' and B = '0')then
						state <= a1;
					elsif(A = '0' and B ='1')then
						state <= b1;
					end if;	
		
		
				when a1=>
					if(OPTOA='1')then
						state<=a2;
					else
						state<=a1;
					end if;
				when a2=>
					if(OPTOB='1')then
						state<=a3;
					else
						state<=a2;
					end if;
				when a3=>
					if(OPTOA='0')then
						state<= a4;
					else
						state <=a3;
					end if;
				when a4=>
					if(OPTOB='0')then
						current_Angle <= current_Angle +1;
						state<=s0;
					else
						state<=a4;
					end if;
				
				
				when b1=>
					if(OPTOB='1')then
						state<=b2;
					else
						state<=b1;
					end if;
				when b2=>
					if(OPTOA='1')then
						state<=b3;
					else
						state<=b2;
					end if;
				when b3=>
					if(OPTOB='0')then
						state<=b4;
					else
						state <=b3;
					end if;
				when b4=>
					if(OPTOA='0')then
						current_Angle <= current_Angle +1;
						state<=s0;
					else
						state<=b4;
					end if;
			
            end case;  
		end if;
	end process;
end logic;
