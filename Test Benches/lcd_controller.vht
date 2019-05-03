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
-- Generated on "05/01/2019 12:47:46"
                                                            
-- Vhdl Test Bench template for design  :  lcd_controller
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY lcd_controller_vhd_tst IS
END lcd_controller_vhd_tst;
ARCHITECTURE lcd_controller_arch OF lcd_controller_vhd_tst IS
-- constants
constant Tclk      : time  := 100 ns;
constant Tsim	   : time  := 20000 ns;                                                  

-- signals 
--inputs                                                  
SIGNAL CLK : STD_LOGIC:= '0';
SIGNAL lcd_bus : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL lcd_enable : STD_LOGIC:='0';
SIGNAL reset_n : STD_LOGIC:= '1';

--Outputs
SIGNAL lcd_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL e : STD_LOGIC;
SIGNAL rs : STD_LOGIC;
SIGNAL rw : STD_LOGIC;
SIGNAL busy : STD_LOGIC;  

--Simple procedures to wait on clock edges
procedure waitForClockToFall is
begin
	wait until (CLK'DELAYED(1 ps)'EVENT and CLK = '0');
end waitForClockToFall;

procedure waitForClockToRise is
begin
	wait until (CLK'DELAYED(1 ps)'EVENT and CLK = '1');
end waitForClockToRise;

COMPONENT lcd_controller
	PORT (
	busy : OUT STD_LOGIC;
	CLK : IN STD_LOGIC;
	e : OUT STD_LOGIC;
	lcd_bus : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
	lcd_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	lcd_enable : IN STD_LOGIC;
	reset_n : IN STD_LOGIC;
	rs : OUT STD_LOGIC;
	rw : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : lcd_controller
	PORT MAP (
-- list connections between master ports and signals
	busy => busy,
	clk => CLK,
	e => e,
	lcd_bus => lcd_bus,
	lcd_data => lcd_data,
	lcd_enable => lcd_enable,
	reset_n => reset_n,
	rs => rs,
	rw => rw
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

LCD_reset : PROCESS                                               
-- variable declarations  
                                   
BEGIN 
waitForClockToRise;
lcd_data <= "01010101";                                                       
waitForClockToRise;
reset_n <= '0';
waitForClockToFall;
reset_n <= '1';

assert(lcd_data = "11111111")
       report "test 1a failed - intput not 1111 1111 1111" severity error;
                          
WAIT;                                                       
END PROCESS LCD_reset;   

LCD_recData : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
waitForClockToRise;
lcd_bus <= "1011111111";
waitForClocktoFall;
lcd_enable <= '1';
waitForClockToRise;
assert(lcd_data = "11111111")
       report "test 1a failed - intput not 1111 1111 1111" severity error;
                          
WAIT;                                                       
END PROCESS LCD_recData;                                           

LCD_busy : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
waitForClockToRise;
lcd_bus <= "1011111111";
waitForClocktoFall;
lcd_enable <= '1';
waitForClockToRise;
assert(lcd_data = "11111111")
       report "test 1a failed - intput not 1111 1111 1111" severity error;
                          
WAIT;                                                       
END PROCESS LCD_busy;  
                                         
END lcd_controller_arch;
