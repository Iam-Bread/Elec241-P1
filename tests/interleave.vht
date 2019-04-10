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
-- Generated on "03/07/2019 14:30:25"
                                                            
-- Vhdl Test Bench template for design  :  interleave
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;         
USE IEEE.std_logic_unsigned.all;         
USE ieee.numeric_std.ALL;
             

ENTITY interleave_vhd_tst IS
END interleave_vhd_tst;

ARCHITECTURE interleave_arch OF interleave_vhd_tst IS
-- constants      
constant DataWidth : natural := 2;                                           

type t_outputs is array (15 downto 0) of std_logic_vector((2*DataWidth)-1 downto 0) ;           --create array of size 2^datawidth  

-- signals                                                   
SIGNAL Asig : STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
SIGNAL Bsig : STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);

SIGNAL Ysig : STD_LOGIC_VECTOR((2*DataWidth)-1 DOWNTO 0);

signal output: t_outputs; 

COMPONENT interleave
	Generic (N : natural :=2);
	PORT (
	A : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	Y : OUT STD_LOGIC_VECTOR((2*N)-1 DOWNTO 0)
	);
END COMPONENT;

BEGIN
	i1 : interleave
	generic map(N => DataWidth)
	PORT MAP (
-- list connections between master ports and signals
	A => Asig,		--Map port A onto signal A	
	B => Bsig,		--Map prot B onto signal B
	
	Y => Ysig		--Map output port Y onto signal Y
	);                                       
PROCESS  
	variable count: integer:=0;
                                                                                                                    
BEGIN          

	output(0) <= "0000";
	output(1) <= "0001";
	output(2) <= "0100";
	output(3) <= "0101";
	output(4) <= "0010";
	output(5) <= "0011";
	output(6) <= "0110";
	output(7) <= "0111";
	output(8) <= "1000";
	output(9) <= "1001";
	output(10) <= "1100";
	output(11) <= "1101";
	output(12) <= "1010";
	output(13) <= "1011";
	output(14) <= "1110";
	output(15) <= "1111";

                                               
        -- code executes for every event on sensitivity list  
	For i in 0 to ((2**DataWidth)-1) loop		--loop between 0 and 2^datawidth
		Asig <= STD_LOGIC_VECTOR (to_unsigned(i,DataWidth));		--set Asignal to current i count Value
		For j in 0 to ((2**DataWidth)-1) loop		--loop between 0 and 2^datawidth
			Bsig <= STD_LOGIC_VECTOR (to_unsigned(j,DataWidth));	--set B signal to current j count value
		  wait for 10 ns;	--add time delay			
		  assert (Ysig = output(count)) report "TEST:" & integer'image(count) & " FAILED" severity error;	--check output to expected output report error if failed
		  assert not(Ysig = output(count)) report "TEST:" & integer'image(count) & " PASSED" severity note;	--check output to expected output report note if passed
			count := count + 1;		--increment count variable
		End loop;		
		--Bsig <=(others => '0');	--reset b signal to 0
	End loop;	
	--Asig <=(others => '0');
WAIT;                                                        
END PROCESS;                                          
END interleave_arch;

