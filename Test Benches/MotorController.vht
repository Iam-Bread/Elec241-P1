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
-- Generated on "05/03/2019 10:39:23"
                                                            
-- Vhdl Test Bench template for design  :  MotorController
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY MotorController_vhd_tst IS
END MotorController_vhd_tst;
ARCHITECTURE MotorController_arch OF MotorController_vhd_tst IS
-- constants      
                                           
-- signals   
-- inputs                                                

SIGNAL AngleIN : STD_LOGIC_VECTOR(11 DOWNTO 0):= "000000000000";
SIGNAL reset : STD_LOGIC:= '1';
SIGNAL SETANGLE : STD_LOGIC_VECTOR(11 DOWNTO 0):= "000000000000";
SIGNAL STATE : STD_LOGIC:= '0';

-- outputs

SIGNAL MOTORA : STD_LOGIC;
SIGNAL MOTORB : STD_LOGIC;
SIGNAL ANGLE : STD_LOGIC_VECTOR(11 DOWNTO 0);

COMPONENT MotorController
	PORT (
	ANGLE : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
	AngleIN : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	MOTORA : OUT STD_LOGIC;
	MOTORB : OUT STD_LOGIC;
	reset : IN STD_LOGIC;
	SETANGLE : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	STATE : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : MotorController
	PORT MAP (
-- list connections between master ports and signals
	ANGLE => ANGLE,
	AngleIN => AngleIN,
	MOTORA => MOTORA,
	MOTORB => MOTORB,
	reset => reset,
	SETANGLE => SETANGLE,
	STATE => STATE
	);

init : PROCESS                                               
-- variable declarations  
variable CurrentAngle: STD_LOGIC_VECTOR(11 DOWNTO 0):= "000000000000";                                   
BEGIN  

wait for 2 ns;
  -- Test for Clockwise motion
	State <= '1';                                                    
      SETANGLE <= "000000001111";
      AngleIN <= "000000000001";
	assert(MOTORA = '1' and MOTORB = '0');
	report "Motor is moving Clockwise";

	wait for 10 ns;
  -- Test for Anti-Clockwise motion	
      SETANGLE <= "000000000000";
      AngleIN <= "000000001111";
	assert(MOTORA = '0' and MOTORB = '1');
	report "Motor is moving Anti-Clockwise";
	wait for 10 ns;
	
	-- Reset Test
	reset <= '0';
	assert(MOTORA = '1' and MOTORB = '1');
	report "Reset Successful";
	wait for 10 ns;
	reset <= '1';
	wait for 10 ns;
	                      
WAIT;                                                       
END PROCESS init;                                                                                   
END MotorController_arch;
