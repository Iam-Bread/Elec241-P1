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
		SETANGLE	: in  std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
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

begin


    process(clk,reset)    --sensitivity list


    begin

    end process;
end logic;