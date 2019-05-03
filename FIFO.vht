-- Copyright (C) 2016  Intel Corporation. All rights reserved.
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
-- Generated on "04/28/2019 15:44:06"
                                                            
-- Vhdl Test Bench template for design  :  FIFO
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
USE IEEE.NUMERIC_STD.ALL;

ENTITY FIFO_vhd_tst IS
END FIFO_vhd_tst;
ARCHITECTURE FIFO_arch OF FIFO_vhd_tst IS

-- constants
constant Tclk      : time  := 50 ns;
constant Tsim	   : time  := 20000 ns;
                                                 
-- signals                                                   
SIGNAL CLK : STD_LOGIC:= '0';
SIGNAL Data_in : STD_LOGIC_VECTOR(11 DOWNTO 0) := (others => '0');
SIGNAL read_Req : STD_LOGIC:= '0';
SIGNAL reset : STD_LOGIC:= '1';
SIGNAL write_Req : STD_LOGIC:= '0';

--Outputs
signal empty	: std_logic;
signal full	: std_logic;
signal Data_out	: std_logic_vector(11 downto 0);
SIGNAL space_Avaliable : STD_LOGIC_VECTOR(8 DOWNTO 0);

--Simple procedure to check the level of a signal
procedure checkOutput(expected : std_logic_vector(11 downto 0)) is
begin
	assert(Data_out = expected)
	report "Output incorrect"
	severity error;
	end checkOutput;	

--Simple procedures to wait on clock edges
procedure waitForClockToFall is
begin
	wait until (CLK'DELAYED(1 ps)'EVENT and CLK = '0');
end waitForClockToFall;

procedure waitForClockToRise is
begin
	wait until (CLK'DELAYED(1 ps)'EVENT and CLK = '1');
end waitForClockToRise;


COMPONENT FIFO
	PORT (
	CLK : IN STD_LOGIC;
	Data_in : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	Data_out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
	empty : OUT STD_LOGIC;
	full : OUT STD_LOGIC;
	read_Req : IN STD_LOGIC;
	reset : IN STD_LOGIC;
	space_Avaliable : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
	write_Req : IN STD_LOGIC
	);
END COMPONENT;

BEGIN
	i1 : FIFO
	PORT MAP (
-- list connections between master ports and signals
	CLK => CLK,
	Data_in => Data_in,
	Data_out => Data_out,
	empty => empty,
	full => full,
	read_Req => read_Req,
	reset => reset,
	space_Avaliable => space_Avaliable,
	write_Req => write_Req
	);
	
clock_process: process
variable t : time := 0 ns;
	begin
		loop
			t := t + Tclk;
			wait for Tclk;
			CLK <= not CLK;
			exit when t >= Tsim;
		end loop;
		wait;
end process;

    
FIFO_test : process 
variable counter : unsigned (11 downto 0) := (others => '0');

begin              
-- TEST 1
-- Basic Reset test

waitForClockToRise;

full <= '1';
waitForClockToFall;
reset <= '0';

assert(full = '0')
	report "Reset did not work"
	severity error;  

reset <= '1';



-- TEST 2
--  Basic FIFO test.  It should recieve data and eventually become full.

		waitForClockToRise;
 
		for i in 1 to 4096 loop
			counter := counter + 1;
			
			Data_in <= std_logic_vector(counter);
			
			waitForClockToRise;
			read_Req <= '0';
			write_Req <= '1';
			
			waitForClockToRise;
			read_Req <= '1';
			write_Req <= '0';
		end loop;
		
		waitForClockToRise;
		
		for i in 1 to 4096 loop
			counter := counter - 1;
			
			Data_in <= std_logic_vector(counter);
			
			waitForClockToRise;
			read_Req <= '0';
			write_Req <= '1';
			
			waitForClockToRise;
			
			read_Req <= '1';
			write_Req <= '0';
		end loop;	

-- Read test
	
		waitForClockToFall;
			
		read_Req <= '1';
		
		waitForClockToFall;
		
		read_Req <= '0';
		
		waitForClockToFall;
		
		read_Req <= '1';
		
end process;                                 
END FIFO_arch;
