-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity AngleTracker is
	generic
	(
        -- Constants
		DATA_WIDTH	: integer  := 12;
		MAX_ANGLE	: integer  := 3017
	);
	port
	(
		--optical encoder inputs
		OPTOA : in std_logic;	
		OPTOB : in std_logic;

        Angle_A : out std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
       Angle_B : out std_logic_vector(DATA_WIDTH-1 DOWNTO 0)
	);
end AngleTracker;

architecture logic of AngleTracker is
    type state_type is (clockwise,anticlockwise);
    signal state: state_type := clockwise; 	--default state is clockwise
    
    signal countA : std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
    signal countB : std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
begin

    Angle_A <= countA;
    Angle_B <= countB;

    --determine the direction the motor is going
    direction : process(OPTOA,OPTOB)
    begin
        if(rising_edge(OPTOA))then --if rising edge of A, and B is allready high then B must lead A
            if(OPTOB = '1')then
                state <= clockwise;
            else
                state <= anticlockwise; --A is leading B
            end if;
        end if;
    end process direction;

    --counter for optical encoder A
	Acount : process(OPTOA)    --sensitivity list
    begin
        if(rising_edge(OPTOA))then
            if(state = clockwise)then
                if(to_integer(unsigned(countA)) = MAX_ANGLE)then
                    countA <= (others => '0'); 
                else
                    countA <= std_logic_vector(unsigned(countA) + 1);   --increment A
                end if;
            else
                if(to_integer(unsigned(countA)) = 0)then
                    countA <= std_logic_vector(to_unsigned(MAX_ANGLE, DATA_WIDTH));
                else
                    countA <= std_logic_vector(unsigned(countA) - 1);   --decrement A
                end if;
            end if;   
        end if;
    end process Acount;
    --counter for optical encoder B
   -- Bcount : process(OPTOB)    --sensitivity list
    --begin
      --  if(rising_edge(OPTOB))then
        --    if(state = clockwise)then
          --      countB <= std_logic_vector(unsigned(countB) + 1);
           -- elsif(state = anticlockwise)then
            ---    countB <= std_logic_vector(unsigned(countB) - 1);
            --end if; 
    --    end if;
    --end process Bcount;
end logic;