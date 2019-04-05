#include "mbed.h"
#include "elec241.h"
#include "BinaryType.hpp"

#define RELEASED 0
#define PRESSED 1

void updateState();
void sw1RisingEdge();
void sw1FallingEdge();

//Define an instance of SPI - this is a SPI master device
SPI spi(PA_7, PA_6, PA_5);      // Ordered as: mosi, miso, sclk could use forth parameter ssel

//We often use a separate signal for the chip select. It is VITAL that for each SPI port, only ONE SPI slave device is enabled.
DigitalOut cs(PC_6);            // Chip Select for Basic Outputs to illuminate Onboard FPGA DEO nano LEDs CN7 pin 1
DigitalOut    led(LED1);
InterruptIn   sw1(USER_BUTTON);

// **************************************************************************
// ******************** NB the following line for F429ZI ******************** 
// *    The following line is essential when using this ribbon connector    *
// **************************************************************************
DigitalIn DO_NOT_USE(PB_12);    // MAKE PB_12 (D19) an INPUT do NOT make an OUTPUT under any circumstances !!!!! ************* !!!!!!!!!!!
                                // This Pin is connected to the 5VDC from the FPGA card and an INPUT that is 5V Tolerant
// **********************************************************************************************************


// **************************************** Function prototypes *********************************************
uint16_t read_switches(void);    //Read 4 Sliding switches on FPGA (Simulating OPTO-Switches from Motor(s)
uint16_t adc_read();
void adc_samples();
uint16_t spi_write(uint16_t data);  
uint16_t spi_read(uint16_t data);  
int bitExtracted(uint16_t,int,int);

// **********************************************************************************************************


// **********************************************************************************************************
// Main function	
// **********************************************************************************************************
using namespace std;
int main() {
    cs = 1;                     // Chip must be deselected, Chip Select is active LOW
    spi.format(16,0);           // Setup the DATA frame SPI for 16 bit wide word, Clock Polarity 0 and Clock Phase 0 (0)
    spi.frequency(1000000);     // 1MHz clock rate
//		wait_ms(10);
//		spi_readwrite(fpgaWord(LEDS_AND_SWITCHES, 0x0FFF));
//		wait_ms(1000);
//		spi_readwrite(fpgaWord(LEDS_AND_SWITCHES, 0x0000));
//		wait_ms(1000);
	
		printf("TEST\n\r");
	
    //Set LED to ON
    led    = 1;
		
		//value to set ADC sampling on and off
		int toggle = 0;
	
		//
		int k = 16;
		int p = 13;
		//stores first 4 bits for instruction
		int instruction;
	
		// value to store instruction to stop ADC sampling
		uint16_t received_adc;
	
    while(true)                 //Loop forever Knight Rider Display on FPGA
    {
				//Read switch state and write to PuTTY
        read_switches();
			
				//function to keep FPGA to start ADC sampling and determine value returned from SPI
				if(toggle == 1){
				//send command to start ADC sampling to FPGA and store value to determine if FPGA should stop sampling
				received_adc = spi_read(0x3000);
				}
				
				//store the first 4 bit of the spi data returned into an 8 bit value
				instruction = bitExtracted(received_adc,k,p);
				
				if(instruction == 0b00001000){
					//send instruction to stop ADC sampling
					toggle = 0;
					//send 0010 as first 4 bit value for instruction to stop sampling
					spi.write(0x2000);
				}
				
				//stop reading adc values - pending existence
				if(instruction == 0b00000100){}
			
				if(sw1 == PRESSED){
				toggle = 1;
				//print samples on Putty
				adc_samples();				
				//LED Chaser display KIT lives on!
        for (uint16_t i=1;i<=128;i*=2) {
            spi_write(fpgaWord(LEDS_AND_SWITCHES, i));
            wait_ms(20);
        }
        for (uint16_t i=128;i>=1;i/=2) {
            spi_write(fpgaWord(LEDS_AND_SWITCHES, i));
            wait_ms(20);
        }
				};
				
        led = !led;	
    }
}

// **********************************************************************************************************
// Function to read back the state of the switches
//
// uint16_t read_switches(void)
// Return data - the data returned from the FPGA to the MCU over the SPI interface (via MISO)
// **********************************************************************************************************

uint16_t read_switches(void){
		spi_write(fpgaWord(LEDS_AND_SWITCHES, 0));
		wait_us(100);
    uint16_t sw_val = spi_write(fpgaWord(LEDS_AND_SWITCHES, 0));	//Turn off all LEDs + read switches (in one full-duplex transaction)

    if (sw_val&(1<<0)){ printf("Switch 0 :"); }
    if (sw_val&(1<<1)){ printf("Switch 1 :"); }
    if (sw_val&(1<<2)){ printf("Switch 2 :"); }
    if (sw_val&(1<<3)){ printf("Switch 3 :"); }
    if (sw_val>0)     { printf("\r\n");       }
    return sw_val;    
}


// **********************************************************************************************************
// Function to ADC Read function
//
// uint16_t adc_read()
// Return data - 16 bit unsigned value (top 4 bits should always be 0)
// **********************************************************************************************************

uint16_t adc_read() {
		cout << "ADC READ TEST" << endl; 

		spi_write(fpgaWord(ADC_READ, 0));	//READ ADC COMMAND
		wait_ms(2);
		uint16_t ret_val = spi_write(fpgaWord(ADC_READ, 0));	//READ ADC COMMAND + RESULT
		cout << endl;
		cout << "******************************" << endl;
		cout << "******************************" << endl;
		cout << "*  ADC VALUE RETURNED: " << ret_val << endl;
		cout << "******************************" << endl;
		cout << "******************************" << endl;
	
		return ret_val;
}

void adc_samples(){
	uint16_t buffered[16];
	
	for(int i=0;i<16;i++)
	{
	buffered[i] = adc_read();
	}
	spi_write(12288);
	wait_ms(20);
}

// Function to extract k bits from p position 
// and returns the extracted value as integer 
int bitExtracted(uint16_t number, int k, int p) 
{ 
    return (((1 << k) - 1) & (number >> (p - 1))); 
} 


// **********************************************************************************************************
// uint16_t spi_readwrite(uint16_t data)
//
// Function for writing to the SPI with the correct timing
// data - this parameter is the data to be sent from the MCU to the FPGA over the SPI interface (via MOSI)
// return data - the data returned from the FPGA to the MCU over the SPI interface (via MISO)
// **********************************************************************************************************
uint16_t spi_write(uint16_t data) {	
	cs = 0;             														//Select the device by seting chip select LOW
	uint16_t rx = (uint16_t)spi.write(data);				//Send the data - ignore the return data
	wait_us(1);																			//wait for last clock cycle to clear
	cs = 1;             												//De-Select the device by seting chip select HIGH
	wait_us(1);
	return rx;
}

// **********************************************************************************************************
// uint16_t spi_readwrite(uint16_t data)
//
// Function for writing to the SPI with the correct timing
// data - this parameter is the data to be sent from the MCU to the FPGA over the SPI interface (via MOSI)
// return data - the data returned from the FPGA to the MCU over the SPI interface (via MISO)
// **********************************************************************************************************
uint16_t spi_read(uint16_t data) {	
	cs = 0;             														//Select the device by seting chip select LOW
	wait_us(1);
	// Send a dummy byte to receive the contents of SPI
  int rx = spi.write(data);
	wait_us(1);																			//wait for last clock cycle to clear
	cs = 1;             												//De-Select the device by seting chip select HIGH
	wait_us(1);
	return rx;
}
