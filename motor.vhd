-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;

entity Motor is
	generic
	(
        -- Constants
		DATA_WIDTH	: integer  := 12
	);
	port
	(
		-- Inputs
		motorEnable : in std_logic; 

		ANGLE : in std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
		
		SET_ANGLE : in std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
		
		state : out std_logic
	);
end Motor;

architecture logic of Motor is

begin
	process(motorEnable,ANGLE,SET_ANGLE)    --sensitivity list
	begin
		if(SET_ANGLE = ANGLE)then
			state <= '0';
		elsif(motorEnable = '1')then
			state <= '1';
		end if;
			
	end process;
end logic;