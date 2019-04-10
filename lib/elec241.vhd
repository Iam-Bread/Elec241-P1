library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Package declaration
package elec241 is

	-- Type Declaration (optional)
	type instruction is (readback, leds_and_switches, interleave_test, add_test, pc_test, adc_read, illegal); -- Different instructions suppported 
	type data_source is (operand, switches, inter, sum, spi_slave_rx, pc, spi_master_rx, res); -- All data sources
	subtype select_lines is std_logic_vector(6 downto 0);
	
	-- Function declarations
	function select_source(aa : data_source ) return select_lines;
	function instruction_for(dat : std_logic_vector(3 downto 0)) return instruction;
	
end package elec241;

-- Package body - where the shared functions, constants, signals and procedures all live
package body elec241 is

	-- FUNCTIONS are similar to process blocks. They take parameters and can return results. They do not support wait statements.
	-- You can use procedures in testbenches as unlike functions, they support wait statements.

	-- Maps the funcion source to the select lines for the MUX block
	-- Again, done to make code cleaner.
/*
	SELECT LINE TABLE
	
S6	S5	S4	S3	S2	S1	S0	
			0		0	0	OPER_REG_DATA
			1		0	0	SW_REG_DATA
		0			1	0	INTER_DATA
		1			1	0	SUM_DATA
	0			0		1	SPIS_RX
	1			0		1	PC_DATA
0				1		1	SPIM_RX
1				1		1	RESERVED

*/
	
	function select_source(aa : data_source ) return select_lines is
	begin
		case aa is
			when operand =>
				return "0000000";
			when switches =>
				return "0001000";
			when inter =>
				return "0000010";
			when sum =>
				return "0010010";
			when spi_slave_rx =>
				return "0000001";
			when pc =>
				return "0100001";
			when spi_master_rx =>
				return "0000101";
			when res =>
				return "1000101";
		end case;
	end select_source;
	
	-- Maps the instructions bits to an instruction enumerated type. This is done simply to make the code cleaner and less error prone
	-- Case statements on enumerated types must have full coverage, or it will not compile.
	function instruction_for(dat : std_logic_vector(3 downto 0)) return instruction is
	begin	
		case dat is
			when "0000" =>
				return readback;
			when "0001" =>
				return leds_and_switches;
			when "0010" =>
				return interleave_test;
			when "0011" =>
				return add_test;
			when "0100" =>
				return pc_test;
			when "0101" =>
				return adc_read;
			when others =>
				return illegal;
		end case;
	end instruction_for;
	

end package body elec241;