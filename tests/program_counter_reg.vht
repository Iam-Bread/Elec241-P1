-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "03/17/2019 17:35:11"
                                                            
-- Vhdl Test Bench template for design  :  program_counter_reg
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY program_counter_reg_vhd_tst IS
END program_counter_reg_vhd_tst;
ARCHITECTURE program_counter_reg_arch OF program_counter_reg_vhd_tst IS
-- constants            
	constant DataWidth : natural := 8;
	constant clkPeriod : time := 20 ns;  	
	constant simTime : time := 1000 ns;   --desired run time of the simulation                                  
-- signals                                                   
SIGNAL CLK : STD_LOGIC;
SIGNAL D : STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
SIGNAL INC : STD_LOGIC;
SIGNAL LD : STD_LOGIC;
SIGNAL RESET : STD_LOGIC;
SIGNAL Y : STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);

--procedures
-- check output against expected value
procedure checkOutput(expected : std_logic_vector;	--procedure with 2 inputs, expected value of the test and the current test that its on
			 test : INTEGER :=0) is
	begin
		assert(Y = expected) report "TEST:" & integer'image(test) & " FAILED" severity error;	--check y agaisnt expected value if it fails report FAILED
		assert not(Y = expected) report "TEST:" & integer'image(test) & " PASSED" severity note; --check y agaisnt expected value if it passes report PASSED
	end checkOutput;
--wait for rising edge of clock
procedure waitForRisingEdge is
	begin
		wait until (rising_edge(CLK));
end waitForRisingEdge;

--wait for Falling edge of clock
procedure waitForFallingEdge is
	begin
		wait until (falling_edge(CLK));
end waitForFallingEdge;

COMPONENT program_counter_reg
	Generic (DATA_WIDTH : natural :=8);
	PORT (
	CLK : IN STD_LOGIC;
	D : IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
	INC : IN STD_LOGIC;
	LD : IN STD_LOGIC;
	RESET : IN STD_LOGIC;
	Y : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : program_counter_reg
	generic map(DATA_WIDTH => DataWidth)
	PORT MAP (
-- list connections between master ports and signals
	CLK => CLK,
	D => D,
	INC => INC,
	LD => LD,
	RESET => RESET,
	Y => Y
	);

--clock process simulates a clock signal
clk_process :PROCESS
variable t: time := 0 ns;	-- variable t of type time set to 0ns
begin
	loop		--start a loop
		CLK <= '0';		--set clock to 0
		wait for clkPeriod/2;	--wait for half of clock period
		CLK <= '1';		--set clock to 1
		wait for clkPeriod/2;	--wait for half of clock period
		t := t + clkPeriod;	--increment t by clock peroid
		exit when t = simTime;	-- exit the loop when t is equal to desired simulation time
	end loop;
	wait;	--wait indefinetly 
end process;
                        
PROCESS                                                                                             
-- variable declarations                                      
BEGIN                                                         

	----test 1: reset has priority over everything----
	waitForFallingEdge;
	D <= (others => '1');
	LD <= '1';
	INC <= '1';
	RESET <= '0';
	waitForRisingEdge;
	waitForFallingEdge;
	checkOutput("00000000",test => 1);
	waitForFallingEdge;
	RESET <= '1';
	LD<= '0';
	INC<= '0';

	----test 2: INC increments Y by 1----
	D <= "11111110";
	LD <= '1';
	waitForRisingEdge;
	waitForFallingEdge;
	LD <= '0';
	waitForRisingEdge;
	waitForFallingEdge;
	INC <= '1';
	waitForRisingEdge;
	waitForFallingEdge;
	checkOutput("11111111",test => 2);
	
	----test 3: when D is max increment results to D = 0----
	waitForFallingEdge;
	--INC <= '1';
	--waitForRisingEdge;
	checkOutput("00000000",test => 3); 

	----test 4: LD has priority over INC----
	waitForFallingEdge;
	D <= "10101010";
	INC <= '1';
	LD <= '1';
	waitForRisingEdge;
	waitForFallingEdge;
	checkOutput("10101010", test => 4);


	----test 5: No signal means latched to last value----
	waitForFallingEdge;
	INC <= '0';
	LD <= '0';
	waitForRisingEdge;
	waitForFallingEdge;
	checkOutput("10101010", test => 5);

	----test 6: Test reset is asyncronous----
	RESET <= '0';
	wait for 10 ns;	
	checkOutput("00000000", test => 6);
	

	
WAIT;                                                        
END PROCESS;                                          
END program_counter_reg_arch;
