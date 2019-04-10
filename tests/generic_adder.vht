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
-- Generated on "03/17/2019 15:20:02"
                                                            
-- Vhdl Test Bench template for design  :  generic_adder
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;   
USE ieee.numeric_std.ALL;                             

ENTITY generic_adder_vhd_tst IS
END generic_adder_vhd_tst;
ARCHITECTURE generic_adder_arch OF generic_adder_vhd_tst IS
-- constants     
constant DATAWIDTH : natural := 3;                     
type carry_outputs is array (63 downto 0) of std_logic;          
type overf_outputs is array (63 downto 0)of std_logic;           
type sum_outputs is array (63 downto 0) of std_logic_vector(DataWidth-1 downto 0) ;           --create array of size 2^datawidth                        
-- signals                                                   
SIGNAL Asig : STD_LOGIC_VECTOR(DATAWIDTH-1 DOWNTO 0);
SIGNAL Bsig : STD_LOGIC_VECTOR(DATAWIDTH-1 DOWNTO 0);

SIGNAL Csig : STD_LOGIC;
SIGNAL Osig : STD_LOGIC;
SIGNAL Ssig : STD_LOGIC_VECTOR(DATAWIDTH-1 DOWNTO 0);

signal carryO: carry_outputs; 
signal overfO: overf_outputs; 
signal sumO: sum_outputs; 

COMPONENT generic_adder
	Generic (DATA_WIDTH : natural :=3);
	PORT (
	A : IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
	B : IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
	CARRY : OUT STD_LOGIC;
	OVERF : OUT STD_LOGIC;
	SUM : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : generic_adder
	generic map(DATA_WIDTH => DATAWIDTH)
	PORT MAP (
-- list connections between master ports and signals
	A => Asig,
	B => Bsig,
	CARRY => Csig,
	OVERF => Osig,
	SUM => Ssig
	);
	
                                        
PROCESS                                                                                         
-- variable declarations      
	variable count: integer:=0;                                
BEGIN           

--fill arrays with expected values
carryO(0) <= '0'; overfO(0) <= '0'; sumO(0) <= "000";   
carryO(1) <= '0'; overfO(1) <= '0'; sumO(1) <= "001"; 
carryO(2) <= '0'; overfO(2) <= '0'; sumO(2) <= "010"; 
carryO(3) <= '0'; overfO(3) <= '0'; sumO(3) <= "011"; 
carryO(4) <= '0'; overfO(4) <= '0'; sumO(4) <= "100";
carryO(5) <= '0'; overfO(5) <= '0'; sumO(5) <= "101";
carryO(6) <= '0'; overfO(6) <= '0'; sumO(6) <= "110";
carryO(7) <= '0'; overfO(7) <= '0'; sumO(7) <= "111"; 
carryO(8) <= '0'; overfO(8) <= '0'; sumO(8) <= "001";
carryO(9) <= '0'; overfO(9) <= '0'; sumO(9) <= "010"; 
carryO(10) <= '0'; overfO(10) <= '0'; sumO(10) <= "011"; 
carryO(11) <= '0'; overfO(11) <= '1'; sumO(11) <= "100";
carryO(12) <= '0'; overfO(12) <= '0'; sumO(12) <= "101";
carryO(13) <= '0'; overfO(13) <= '0'; sumO(13) <= "110"; 
carryO(14) <= '0'; overfO(14) <= '0'; sumO(14) <= "111";
carryO(15) <= '1'; overfO(15) <= '0'; sumO(15) <= "000"; 
carryO(16) <= '0'; overfO(16) <= '0'; sumO(16) <= "010";
carryO(17) <= '0'; overfO(17) <= '0'; sumO(17) <= "011";
carryO(18) <= '0'; overfO(18) <= '1'; sumO(18) <= "100"; 
carryO(19) <= '0'; overfO(19) <= '1'; sumO(19) <= "101";  
carryO(20) <= '0'; overfO(20) <= '0'; sumO(20) <= "110";   
carryO(21) <= '0'; overfO(21) <= '0'; sumO(21) <= "111"; 
carryO(22) <= '1'; overfO(22) <= '0'; sumO(22) <= "000"; 
carryO(23) <= '1'; overfO(23) <= '0'; sumO(23) <= "001"; 
carryO(24) <= '0'; overfO(24) <= '0'; sumO(24) <= "011";
carryO(25) <= '0'; overfO(25) <= '1'; sumO(25) <= "100";
carryO(26) <= '0'; overfO(26) <= '1'; sumO(26) <= "101"; 
carryO(27) <= '0'; overfO(27) <= '1'; sumO(27) <= "110";
carryO(28) <= '0'; overfO(28) <= '0'; sumO(28) <= "111";
carryO(29) <= '1'; overfO(29) <= '0'; sumO(29) <= "000";
carryO(30) <= '1'; overfO(30) <= '0'; sumO(30) <= "001"; 
carryO(31) <= '1'; overfO(31) <= '0'; sumO(31) <= "010"; 
carryO(32) <= '0'; overfO(32) <= '0'; sumO(32) <= "100"; 
carryO(33) <= '0'; overfO(33) <= '0'; sumO(33) <= "101"; 
carryO(34) <= '0'; overfO(34) <= '0'; sumO(34) <= "110";
carryO(35) <= '0'; overfO(35) <= '0'; sumO(35) <= "111"; 
carryO(36) <= '1'; overfO(36) <= '1'; sumO(36) <= "000";
carryO(37) <= '1'; overfO(37) <= '1'; sumO(37) <= "001"; 
carryO(38) <= '1'; overfO(38) <= '1'; sumO(38) <= "010";
carryO(39) <= '1'; overfO(39) <= '1'; sumO(39) <= "011"; 
carryO(40) <= '0'; overfO(40) <= '0'; sumO(40) <= "101";  
carryO(41) <= '0'; overfO(41) <= '0'; sumO(41) <= "110"; 
carryO(42) <= '0'; overfO(42) <= '0'; sumO(42) <= "111"; 
carryO(43) <= '1'; overfO(43) <= '0'; sumO(43) <= "000"; 
carryO(44) <= '1'; overfO(44) <= '1'; sumO(44) <= "001"; 
carryO(45) <= '1'; overfO(45) <= '1'; sumO(45) <= "010"; 
carryO(46) <= '1'; overfO(46) <= '1'; sumO(46) <= "011"; 
carryO(47) <= '1'; overfO(47) <= '0'; sumO(47) <= "100";
carryO(48) <= '0'; overfO(48) <= '0'; sumO(48) <= "110"; 
carryO(49) <= '0'; overfO(49) <= '0'; sumO(49) <= "111"; 
carryO(50) <= '1'; overfO(50) <= '0'; sumO(50) <= "000"; 
carryO(51) <= '1'; overfO(51) <= '0'; sumO(51) <= "001"; 
carryO(52) <= '1'; overfO(52) <= '1'; sumO(52) <= "010"; 
carryO(53) <= '1'; overfO(53) <= '1'; sumO(53) <= "011"; 
carryO(54) <= '1'; overfO(54) <= '0'; sumO(54) <= "100"; 
carryO(55) <= '1'; overfO(55) <= '0'; sumO(55) <= "101"; 
carryO(56) <= '0'; overfO(56) <= '0'; sumO(56) <= "111"; 
carryO(57) <= '1'; overfO(57) <= '0'; sumO(57) <= "000";  
carryO(58) <= '1'; overfO(58) <= '0'; sumO(58) <= "001"; 
carryO(59) <= '1'; overfO(59) <= '0'; sumO(59) <= "010"; 
carryO(60) <= '1'; overfO(60) <= '1'; sumO(60) <= "011"; 
carryO(61) <= '1'; overfO(61) <= '0'; sumO(61) <= "100"; 
carryO(62) <= '1'; overfO(62) <= '0'; sumO(62) <= "101"; 
carryO(63) <= '1'; overfO(63) <= '0'; sumO(63) <= "110"; 

--count up in binary from 000 untill 111 
	For i in 0 to ((2**DATAWIDTH)-1) loop
		--set A to current i value in binary
		Asig <= std_logic_vector(to_unsigned(i,DATAWIDTH));
		--count up in binary from 000 untill 111 
		For j in 0 to ((2**DATAWIDTH)-1) loop
			--set B to current i value in binary
			Bsig <= std_logic_vector(to_unsigned(j,DATAWIDTH));
			-- wait for 20 nano seconds to set the signals 
			wait for 20 ns;
				--check if the carry,sum and overflow are what they should be
				ASSERT(Osig = overfO(count)) REPORT "OVERFLOW FAILURE TEST:" & integer'image(count) SEVERITY ERROR;
				ASSERT(Csig = carryO(count)) REPORT "CARRRY FAILURE TEST:" & integer'image(count) SEVERITY ERROR;
				ASSERT(Ssig = sumO(count)) REPORT "SUM FAILURE TEST:"& integer'image(count) SEVERITY ERROR;
				count := count +1;
		End loop;
	End loop;
WAIT;                                                        
END PROCESS;                                          
END generic_adder_arch;
