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
-- Generated on "05/03/2019 09:54:29"
                                                            
-- Vhdl Test Bench template for design  :  AngleTracker
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY AngleTracker_vhd_tst IS
END AngleTracker_vhd_tst;
ARCHITECTURE AngleTracker_arch OF AngleTracker_vhd_tst IS
-- constants  
constant Tclk      : time  := 50 ns;
constant Tsim	   : time  := 2000 ns;                                               
-- signals    

-- inputs
SIGNAL clk : STD_LOGIC := '0';                                               
SIGNAL A : STD_LOGIC := '0';
SIGNAL B : STD_LOGIC := '0';
SIGNAL OPTOA : STD_LOGIC := '0';
SIGNAL OPTOB : STD_LOGIC := '0';

-- outputs
SIGNAL ANGLE : STD_LOGIC_VECTOR(11 DOWNTO 0);

--Simple procedures to wait on clock edges
procedure waitForClockToFall is
begin
	wait until (clk'DELAYED(1 ps)'EVENT and clk = '0');
end waitForClockToFall;

procedure waitForClockToRise is
begin
	wait until (clk'DELAYED(1 ps)'EVENT and clk = '1');
end waitForClockToRise;

COMPONENT AngleTracker
	PORT (
	A : IN STD_LOGIC;
	ANGLE : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
	B : IN STD_LOGIC;
	clk : IN STD_LOGIC;
	OPTOA : IN STD_LOGIC;
	OPTOB : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : AngleTracker
	PORT MAP (
-- list connections between master ports and signals
	A => A,
	ANGLE => ANGLE,
	B => B,
	clk => clk,
	OPTOA => OPTOA,
	OPTOB => OPTOB
	);

clock_process: process
variable t : time := 0 ns;
	begin
		loop
			t := t + Tclk;
			wait for Tclk;
			clk <= not clk;
			exit when t >= Tsim;
		end loop;
		wait;
end process;

init : PROCESS                                               
-- variable declarations   
current_angle : std_logic_vector(DATA_WIDTH-1 downto 0);                                  
BEGIN   

 
	loop
	       waitForClockToRise;                                       
        	OPTOA <= '1';
		wait for 2 ns;
		OPTOB <= '1';
		waitForClockToFall;
		OPTOA <= '0';
		wait for 2 ns;
		OPTOB <= '0';   
	end loop;

WAIT;                                                       
END PROCESS init;                                                                                    
END AngleTracker_arch;
