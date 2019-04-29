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
		
		direction : in std_logic; --0 is clockwise 1 is anticlockwise

      Angle_A : out std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
      Angle_B : out std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
		
		A : OUT STD_LOGIC;
		B : OUT STD_LOGIC

	);
end AngleTracker;

architecture logic of AngleTracker is
   -- type state_type is (clockwise,anticlockwise);
   -- signal state: state_type := clockwise; 	--default state is clockwise
    
    signal countA : std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
    signal countB : std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
begin

    Angle_A <= countA;
    Angle_B <= countB;

    --determine the direction the motor is going
	process(OPTOA,OPTOB,direction)
    begin
--        if(falling_edge(OPTOA))then 
--            if(OPTOB = '1')then
--					state <= clockwise;
--				end if;
--				if(OPTOB = '0')then
--					state <= anticlockwise;	
--				end if;
--			end if;	
--			
				 if(direction = '1')then
                --if(to_integer(unsigned(countA)) = MAX_ANGLE)then
                --    countA <= (others => '0'); 
               -- else
                    countA <= std_logic_vector(unsigned(countA) + 1);   --increment A
               -- end if;
						A <= '1';
						B <='0';
			
            elsif(direction = '0')then
              --  if(to_integer(unsigned(countA)) = 0)then
               --     countA <= std_logic_vector(to_unsigned(MAX_ANGLE, DATA_WIDTH));
               -- else
                    countA <= std_logic_vector(unsigned(countA) - 1);   --decrement A
               -- end if;
					A <= '0';
					B <='1';
            end if;   
      
    end process;

    --counter for optical encoder A
--	Acount : process(OPTOA)    --sensitivity list
--    begin
--        if(rising_edge(OPTOA))then
--            if(state = clockwise)then
--                if(to_integer(unsigned(countA)) = MAX_ANGLE)then
--                    countA <= (others => '0'); 
--                else
--                    countA <= std_logic_vector(unsigned(countA) + 1);   --increment A
--                end if;
--            else
--                if(to_integer(unsigned(countA)) = 0)then
--                    countA <= std_logic_vector(to_unsigned(MAX_ANGLE, DATA_WIDTH));
--                else
--                    countA <= std_logic_vector(unsigned(countA) - 1);   --decrement A
--                end if;
--            end if;   
--        end if;
--    end process Acount;
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