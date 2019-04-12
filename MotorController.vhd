-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;

entity MotorController is
	generic
	(
        -- Constants
		DATA_WIDTH	: integer  := 12;
		MAX_ANGLE	: integer  := 3017
	);
	port
	(
		-- Inputs
		STATE : in std_logic; --1 is on, 0 is off
        SETANGLE : in  std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
        
        Angle_A : in std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
        Angle_B : in std_logic_vector(DATA_WIDTH-1 DOWNTO 0);

        reset : in  std_logic;

		-- Outputs
		--outputs connected to hbridge to control motor
		MOTORA : out std_logic;
		MOTORB : out std_logic;

		ANGLE : out std_logic_vector(DATA_WIDTH DOWNTO 0)
	);
end MotorController;

architecture logic of MotorController is

begin
	process(STATE,reset,Angle_A)    --sensitivity list
	begin
		if(reset = '0')then		--asynchronous reset to default values
			--count <= (others=>'0') ;
			MOTORA <= '1';
			MOTORB <= '1';
		elsif(STATE = '1')then
			if(to_integer(unsigned(SETANGLE)) < MAX_ANGLE)then	--check if angle is valid
				if(Angle_A = SETANGLE)then
					MOTORA <= '1';
					MOTORB <= '1';
				elsif(unsigned(SETANGLE) > unsigned(Angle_A))then	--check what direction to go 
					MOTORA <= '1';			--go Clockwise
					MOTORB <= '0';
				elsif(unsigned(SETANGLE) < unsigned(Angle_A))then
					MOTORA <= '0';			--go anticlockwise
					MOTORB <= '1';
                  end if;
            else
                MOTORA <= '1';
                MOTORB <= '1';
            end if;
                
        end if;
	end process;
end logic;