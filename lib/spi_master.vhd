library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_master is

	generic (
		DATA_WIDTH : natural := 16;
		CLK_DIV    : natural := 25
	);

	port (
		MISO 	: in   std_logic;		--Master In Slave Out
		MOSI 	: out  std_logic;		--Master Out Slave In
		SCLK 	: out  std_logic;		--SPI Serial CLock (1MHz)
		CS    : out  std_logic;		--Chip select
		CLK 	: in   std_logic;		--FPGA Clock
		RESET  : in   std_logic;		--Async Reset
		DATATX : in   std_logic_vector((DATA_WIDTH-1) downto 0);	-- data to be sent over MOSI (msb first)
		START : in   std_logic;		--Start Conversion
		RXSYNC  : out  std_logic;		--HIGH when a valid value is loaded into RX
		RX    : out  std_logic_vector((DATA_WIDTH-1) downto 0);	-- Received data
		DBG   : out  natural range 0 to 31
	);

end entity;

architecture v1 of spi_master is
-- ******************************************
-- DO NOT MODIFY ANYTHING ABOVE THIS LINE --
-- ******************************************

	type state_type is (IDLE,RUNNING,DONE);
	signal state: state_type := IDLE; 	--default state is idle
	signal SCLK_internal: std_logic := '0';	
	signal RX_Buffer : std_logic_vector((DATA_WIDTH-1) downto 0);	--buffer for recievinbg data
	signal RX_Done : std_logic := '0';
	signal TX_Done : std_logic := '0';
	signal CS_internal : std_logic;

begin
	DBG <= 0;
	SCLK <= SCLK_internal;	--set up internal signals to be used
	CS <= CS_internal;

Clock_Div: process(CLK,CS_internal)
	variable count: integer := 0;		--variable for counting
	begin
		if(CS_internal = '0')then	--if check chip select is low
			if(rising_edge(CLK)) then 	-- on rising edge of 50mhz clock
				count := count + 1;	--increment count
					if(count > CLK_DIV) then		--if count is greater than 25
						SCLK_internal <= not SCLK_internal;		--toggle sclk
						--SCLK <= SCLK_Copy;
						count := 0;	--reset count
					end if;
			end if;
		else
			SCLK_internal <= '1';		--if CS is 1 then set sclk to high
		end if;
end process Clock_Div;

--next state logic
process(CLK,RESET,START,state,RX_Done) 	--sensitivity list
	begin		
		if(RESET = '0')then	--if reset is 0 set state to idle
			state <= IDLE;
		elsif(rising_edge(CLK))then	--on rising edge of 50MHz clock
			case state is		--check state
				when IDLE =>	
					if(START = '1')then	--if start is 1 and idle
						state <= RUNNING;	--change state to running
					end if;
				when RUNNING =>
					if(RX_Done = '1' and TX_Done = '1')then	--if rx-done is 1 and running
						state <= DONE;	--change state to done
					end if;
				when DONE =>			
					if(RXSYNC = '1')then	--if done and RXSYNC high
						state <= IDLE;	--change state to idle
					end if;
			end case;
		end if;
end process;	

process(state,SCLK_internal)
	begin	
		case(state) is 		--check state
			when IDLE =>	
				CS_internal <= '1';	--set defaults
				RXSYNC <= '0';		
			when RUNNING =>
				CS_internal <= '0';	--set cs to low triggering SCLK
			when DONE =>
				RX <= RX_Buffer(DATA_WIDTH-1 downto 0);	--copy rx buffer onto rx
				RXSYNC <= '1';				--set RXSYCN to hish as RX holds all 16 values
		end case;
end process;

risingEdge: process(SCLK_internal,state)
variable RX_Count: integer := DATA_WIDTH;	--count variable for recieving data
	begin
		if(rising_edge(SCLK_internal)) then	--on rising edge of SCLK
					RX_Buffer(RX_Count-1) <= MISO; --set MSB of MISO to MSB of buffer
					RX_Count := RX_Count -1;	--decrement RX count
				end if;
				if(RX_Count = 0) then		--when RX count is 0
					RX_Count := DATA_WIDTH;	--reset count
					RX_Done <= '1';		--set RX done to high
				end if;
				if(state = IDLE)then		--when idle
					RX_Done <= '0';		--set rx done to low
				end if;
end process;

fallingEdge: process(SCLK_internal,state)
variable TX_Count: integer := DATA_WIDTH;	--count variable for sending data
	begin
				if(falling_edge(SCLK_internal)) then	--if falling Edge of SCLK
					MOSI <= DATATX(TX_Count-1);	--output MSB of DATA to MOSI
					TX_Count := TX_Count -1;	--decrement TX count
				end if;
				if(TX_Count = 0) then		--when TX count is 0
					TX_Count := DATA_WIDTH;	--Reset TX Count
					TX_Done <= '1';		--set TX done to high
				end if;
				if(state = IDLE)then		--when idle
					MOSI <= '0';		--set MOSI and tx done to low
					TX_Done <= '0';
				end if;
end process;
end v1;