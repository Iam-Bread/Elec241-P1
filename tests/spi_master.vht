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
-- Generated on "03/25/2019 14:16:08"
                                                            
-- Vhdl Test Bench template for design  :  spi_master
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY spi_master_vhd_tst IS
END spi_master_vhd_tst;
ARCHITECTURE spi_master_arch OF spi_master_vhd_tst IS
-- constants      
	constant DATA_WIDTH : natural := 16;
	constant clkPeriod : time := 20 ns;  
	constant simTime : time := 100000 ns;                                              
-- signals                                                   
SIGNAL CLK : STD_LOGIC;
SIGNAL CS : STD_LOGIC;
SIGNAL DATATX : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
SIGNAL DBG : NATURAL RANGE 0 TO 31;
SIGNAL MISO : STD_LOGIC;
SIGNAL MOSI : STD_LOGIC;
SIGNAL RESET : STD_LOGIC;
SIGNAL RX : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
SIGNAL RXSYNC : STD_LOGIC;
SIGNAL SCLK : STD_LOGIC;
SIGNAL START : STD_LOGIC;

COMPONENT spi_master
	Generic (DATA_WIDTH : natural :=16);
	PORT (
	CLK : IN STD_LOGIC;
	CS : OUT STD_LOGIC;
	DATATX : IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
	DBG : OUT NATURAL RANGE 0 TO 31;
	MISO : IN STD_LOGIC;
	MOSI : OUT STD_LOGIC;
	RESET : IN STD_LOGIC;
	RX : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
	RXSYNC : OUT STD_LOGIC;
	SCLK : OUT STD_LOGIC;
	START : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : spi_master
	generic map(DATA_WIDTH => DATA_WIDTH)
	PORT MAP (
-- list connections between master ports and signals
	CLK => CLK,
	CS => CS,
	DATATX => DATATX,
	DBG => DBG,
	MISO => MISO,
	MOSI => MOSI,
	RESET => RESET,
	RX => RX,
	RXSYNC => RXSYNC,
	SCLK => SCLK,
	START => START
	);



 --clock process simulates a clock signal
clk_process :PROCESS
variable t: time := 0 ns;
begin
	loop
		CLK <= '0';
		wait for clkPeriod/2;
		CLK <= '1';
		wait for clkPeriod/2;
		t := t + clkPeriod;
		exit when t = simTime;
	end loop;
	wait;
end process;
                                        
PROCESS                                                                                           
--variable declarations   
--Procedures
procedure waitForRisingEdge is
	begin
		wait until (rising_edge(CLK));
end procedure;

--wait for Falling edge of clock
procedure waitForFallingEdge is
	begin
		wait until (falling_edge(CLK));
end procedure;

--wait for rising edge of SCLK
procedure waitForRisingEdgeSCLK is
	begin
		wait until (rising_edge(SCLK));
end procedure;

--wait for Falling edge of SCLK
procedure waitForFallingEdgeSCLK is
	begin
		wait until (falling_edge(SCLK));
end procedure;    
--pulse Start for clock period
procedure pulseStart is 
	begin
		waitForFallingEdge;
		START <= '1';
		waitForFallingEdge;
		START <= '0';
end procedure;                             
BEGIN                                                         
        -- code executes for every event on sensitivity list  
	
	----set defualts----
	DATATX <= (others => '0');
	MISO <= '0';
	START <= '0';
	RESET <= '1';

	----TEST 1 MISO COPIED ONTO RX----
	MISO <= '1';
	waitForRisingEdge;
	pulseStart;
	wait until RXSYNC ='1';
	assert(RX = "1111111111111111") report "FAILED TEST 1" severity error;
	assert not(RX = "1111111111111111") report "PASSED TEST 1" severity note;

	----TEST 2 MISO COPPIED IN CORRECT ORDER----
	wait until RXSYNC  = '0';
	pulseStart;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	wait until RXSYNC = '1';
	wait until RXSYNC = '0';
	assert(RX = "1110011000110110") report "FAILED TEST 2" severity error;
	assert not(RX = "1110011000110110") report "PASSED TEST 2" severity note;

	----TEST 3 RESET (return to idle state)----
	--RX LATCHED
	RESET <= '0';
	wait for 10 ns;
	assert(RX = "1110011000110110") report "fail 3" severity error;
	assert(CS = '1') report "FAILED TEST 3" severity error;
	assert(MOSI = '0') report "FAILED TEST 3" severity error;
	assert(RXSYNC = '0') report "FAILED TEST 3" severity error;
	assert not(RX = "1110011000110110") report "PASSED TEST 3" severity note;
	RESET <= '1';
	waitForRisingEdge;

	----TEST 4 rx sync goes high ----
	pulseStart;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '1';
	waitForRisingEdgeSCLK;
	waitForFallingEdgeSCLK;
	MISO <= '0';
	waitForRisingEdgeSCLK;
	waitForRisingEdge;
	waitForFallingEdge;
	assert(RXSYNC = '1') report "FAILED TEST 4" severity error;
	assert not(RXSYNC = '1') report "PASSED TEST 4" severity note;
	waitForRisingEdge;
	waitForFallingEdge;
	assert(RXSYNC = '0') report "FAILED TEST 4.2" severity error;
	assert not(RXSYNC = '0') report "PASSED TEST 4.2" severity note;

	----TEST 5 time between CS and SCLK edge is at least 500ns----
	wait for 60 ns;
	MISO <= '0';	
	waitForRisingEdge;
	pulseStart;
	wait for 500 ns;
	assert(SCLK = '0') report "FAILED TEST 5" severity error;
	assert not(SCLK = '0') report "PASSED TEST 5" severity note;

	----TEST 6 DATATX sets mosi----
	DATATX <= "0101010101010101";		--set datatx 
	pulseStart;
	waitForFallingEdgeSCLK;		--wait for the foalling edge of sclk
	assert(MOSI = '0') report "FAILED TEST 6" severity error;
	assert not(MOSI = '0') report "PASSED TEST 6" severity note;
	waitForFallingEdgeSCLK;
	assert(MOSI = '1') report "FAILED TEST 6.2" severity error;
	assert not(MOSI = '1') report "PASSED TEST 6.2" severity note;


WAIT;                                                        
END PROCESS;                                          
END spi_master_arch;
