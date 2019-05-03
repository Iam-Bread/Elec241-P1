-- test bench for the master controller

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY master_controller_vhd_tst IS
END master_controller_vhd_tst;
ARCHITECTURE master_controller_arch OF master_controller_vhd_tst IS
-- constants  
constant Tclk      : time  := 10 ns;
constant Tsim	   : time  := 2000 ns;                                               
-- signals                                                   

-- inputs
SIGNAL areset : STD_LOGIC:= '1';
SIGNAL clk : STD_LOGIC:= '1';
SIGNAL INSTR : STD_LOGIC_VECTOR(3 DOWNTO 0):= "0000";
SIGNAL SPI_SLAVE_BUSYRX : STD_LOGIC:= '0';
SIGNAL SPI_SLAVE_BUSYTX : STD_LOGIC:= '0';

-- outputs
SIGNAL ADC_ENABLE : STD_LOGIC;
SIGNAL INSTR_REG_LD : STD_LOGIC;
SIGNAL LCD_ENABLE : STD_LOGIC;
SIGNAL LED_REG_LD : STD_LOGIC;
SIGNAL mastDBG : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL MOTOR_ENABLE : STD_LOGIC;
SIGNAL OPER_REG_LD : STD_LOGIC;
SIGNAL READ_ADC_BUFF : STD_LOGIC;
SIGNAL SEL : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL SET_ANGLE_ENABLE : STD_LOGIC;
SIGNAL SPI_SLAVE_RXREG_LD : STD_LOGIC;
SIGNAL SPI_SLAVE_TXREG_LD : STD_LOGIC;
SIGNAL SW_REG_LD : STD_LOGIC;

--Simple procedures to wait on clock edges
procedure waitForClockToFall is
begin
	wait until (clk'DELAYED(1 ps)'EVENT and clk = '0');
end waitForClockToFall;

procedure waitForClockToRise is
begin
	wait until (clk'DELAYED(1 ps)'EVENT and clk = '1');
end waitForClockToRise;

COMPONENT master_controller
	PORT (
	ADC_ENABLE : OUT STD_LOGIC;
	areset : IN STD_LOGIC;
	clk : IN STD_LOGIC;
	INSTR : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	INSTR_REG_LD : OUT STD_LOGIC;
	LCD_ENABLE : OUT STD_LOGIC;
	LED_REG_LD : OUT STD_LOGIC;
	mastDBG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	MOTOR_ENABLE : OUT STD_LOGIC;
	OPER_REG_LD : OUT STD_LOGIC;
	READ_ADC_BUFF : OUT STD_LOGIC;
	SEL : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	SET_ANGLE_ENABLE : OUT STD_LOGIC;
	SPI_SLAVE_BUSYRX : IN STD_LOGIC;
	SPI_SLAVE_BUSYTX : IN STD_LOGIC;
	SPI_SLAVE_RXREG_LD : OUT STD_LOGIC;
	SPI_SLAVE_TXREG_LD : OUT STD_LOGIC;
	SW_REG_LD : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : master_controller
	PORT MAP (
-- list connections between master ports and signals
	ADC_ENABLE => ADC_ENABLE,
	areset => areset,
	clk => clk,
	INSTR => INSTR,
	INSTR_REG_LD => INSTR_REG_LD,
	LCD_ENABLE => LCD_ENABLE,
	LED_REG_LD => LED_REG_LD,
	mastDBG => mastDBG,
	MOTOR_ENABLE => MOTOR_ENABLE,
	OPER_REG_LD => OPER_REG_LD,
	READ_ADC_BUFF => READ_ADC_BUFF,
	SEL => SEL,
	SET_ANGLE_ENABLE => SET_ANGLE_ENABLE,
	SPI_SLAVE_BUSYRX => SPI_SLAVE_BUSYRX,
	SPI_SLAVE_BUSYTX => SPI_SLAVE_BUSYTX,
	SPI_SLAVE_RXREG_LD => SPI_SLAVE_RXREG_LD,
	SPI_SLAVE_TXREG_LD => SPI_SLAVE_TXREG_LD,
	SW_REG_LD => SW_REG_LD
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
BEGIN   

-- Test for the ADC.  ADC_
waitForClockToRise;                                                  
INSTR <= "0001";
assert(ADC_ENABLE = '1');
report"ADC test failed" serrity error;

                 
WAIT;                                                       
END PROCESS init;                                           
                                       
END master_controller_arch;
