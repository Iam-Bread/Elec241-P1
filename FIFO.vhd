-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;

entity FIFO is
	generic
	(
        -- Constants
		DATA_WIDTH	: integer  := 12;
		BUFFER_SIZE	: integer  := 512
	);
	port
	(
		-- Input ports
		Data_in	: in  std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
		write_Req	: in  std_logic;
      read_Req	: in  std_logic;
      Clk	: in  std_logic;
      reset	: in  std_logic;

		-- Output ports
		Data_out	: out std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
		empty : out std_logic := '1';
      full : out std_logic := '0';
      space_Avaliable : out std_logic_vector(8 DOWNTO 0)

	);
end FIFO;

architecture logic of FIFO is
    

    signal empty_internal : std_logic := '0';
    signal full_internal: std_logic := '0';
    type buffer_type is array (0 to BUFFER_SIZE-1) of std_logic_vector(DATA_WIDTH-1 downto 0);  --create the buffer which is an array of 512 samples at 12 bits wide
    signal FIFO_buffer : buffer_type;   --buffer for queue
	
begin

    empty <= empty_internal;    --map internal signals to ports
    full <= full_internal;
    process(clk,reset)    --sensitivity list

    variable first_Sample : natural range 0 to BUFFER_SIZE;     --points to the sample thats been in the buffer the longest (first sample)
    variable free_Space : natural range 0 to BUFFER_SIZE;     --points to the next space in the buffer
    variable numberOfValues: natural range 0 to BUFFER_SIZE-1;

    begin
       
        if(reset = '0')then     --reset values to defualts
            empty_internal <= '0';
            full_internal <= '0';
            first_Sample := 0;
            free_Space := 0;
        elsif(rising_edge(Clk))then     --on the rising edge of the clock
            --logic to write to the buffer
            if(write_Req = '1' and full_internal = '0')then --check for a write request
                FIFO_buffer(free_Space) <= Data_in;     --set buffer at the next free space to input
                free_Space := free_Space +1;        --increment the pointers
                numberOfValues := numberOfValues +1;
            end if;

            --logic to read from the buffer
            if(read_Req = '1' and empty_internal = '0')then  --check for a read request
                Data_out <= FIFO_buffer(first_Sample);    --set the data out to equal the first sample
                first_Sample := first_Sample +1;            --increment the pointers
                numberOfValues := numberOfValues -1;
            end if;

             --calculate to space avaliable left in the buffer
            space_Avaliable <= std_logic_vector(to_unsigned((BUFFER_SIZE-(abs(numberOfValues))),9));


				--work out if the buffer is full or empty
			  if(numberOfValues = 0)then
                    empty_internal <= '1';
                    full_internal <= '0';
			  elsif(numberOfValues = BUFFER_SIZE)then
                    full_internal <= '1';
                    empty_internal <= '0';
			  else 
					empty_internal <= '0';
					full_internal <= '0';
			  end if;
	
			  --check if the pointer variables have passed the size of the buffer, 
			  --reset them if so
			  if(first_Sample = BUFFER_SIZE-1)then
					first_Sample := 0;
			  end if;
			  if(free_Space = BUFFER_SIZE-1)then
					free_Space := 0;
			  end if; 

        end if;

    end process;
end logic;