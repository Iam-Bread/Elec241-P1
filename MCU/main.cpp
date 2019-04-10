#include "mbed.h"
#include "elec241.h"
#include "BinaryType.hpp"

//Define an instance of SPI - this is a SPI master device
SPI spi(PA_7, PA_6, PA_5);      // Ordered as: mosi, miso, sclk could use forth parameter ssel

//We often use a separate signal for the chip select. It is VITAL that for each SPI port, only ONE SPI slave device is enabled.
DigitalOut cs(PC_6);            // Chip Select for Basic Outputs to illuminate Onboard FPGA DEO nano LEDs CN7 pin 1

// **************************************************************************
// ******************** NB the following line for F429ZI ******************** 
// *    The following line is essential when using this ribbon connector    *
// **************************************************************************
DigitalIn DO_NOT_USE(PB_12);    // MAKE PB_12 (D19) an INPUT do NOT make an OUTPUT under any circumstances !!!!! ************* !!!!!!!!!!!
                                // This Pin is connected to the 5VDC from the FPGA card and an INPUT that is 5V Tolerant
// **********************************************************************************************************


// **************************************** Function prototypes *********************************************
uint16_t read_switches(void);    //Read 4 Sliding switches on FPGA (Simulating OPTO-Switches from Motor(s)
void ping();
void inter_test(void);
void add_test();
void pc_test();
void adc_read();
uint16_t spi_readwrite(uint16_t data);  

// **********************************************************************************************************


// **********************************************************************************************************
// Main function	
// **********************************************************************************************************
using namespace std;

int main() {
    cs = 1;                     // Chip must be deselected, Chip Select is active LOW
    spi.format(16,0);           // Setup the DATA frame SPI for 16 bit wide word, Clock Polarity 0 and Clock Phase 0 (0)
    spi.frequency(1000000);     // 1MHz clock rate
		wait_ms(10);
		spi_readwrite(fpgaWord(LEDS_AND_SWITCHES, 0x0FFF));
		wait_ms(1000);
		spi_readwrite(fpgaWord(LEDS_AND_SWITCHES, 0x0000));
		wait_ms(1000);
	
		printf("TEST\n\r");
		
	
    while(true)                 //Loop forever Knight Rider Display on FPGA
    {
				//Read switch state and write to PuTTY
        read_switches();
				
        //LED Chaser display KIT lives on!
        for (uint16_t i=1;i<=128;i*=2) {
            spi_readwrite(fpgaWord(LEDS_AND_SWITCHES, i));
            wait_ms(20);
        }
        for (uint16_t i=128;i>=1;i/=2) {
            spi_readwrite(fpgaWord(LEDS_AND_SWITCHES, i));
            wait_ms(20);
        }
				
				//Wait for 1 second
				wait_ms(1000);
				
				//Test SPI commnication is working
				ping();
						
				//Check the interleave
				inter_test();	
			
				//Check the adder
				add_test();
				
				// Check the PC
				pc_test();
								
				//ADC
				adc_read();
    }
}

// **********************************************************************************************************
// Function to read back the state of the switches
//
// uint16_t read_switches(void)
// Return data - the data returned from the FPGA to the MCU over the SPI interface (via MISO)
// **********************************************************************************************************

uint16_t read_switches(void){
		spi_readwrite(fpgaWord(LEDS_AND_SWITCHES, 0));
		wait_us(100);
    uint16_t sw_val = spi_readwrite(fpgaWord(LEDS_AND_SWITCHES, 0));	//Turn off all LEDs + read switches (in one full-duplex transaction)

    if (sw_val&(1<<0)){ printf("Switch 0 :"); }
    if (sw_val&(1<<1)){ printf("Switch 1 :"); }
    if (sw_val&(1<<2)){ printf("Switch 2 :"); }
    if (sw_val&(1<<3)){ printf("Switch 3 :"); }
    if (sw_val>0)     { printf("\r\n");       }
    return sw_val;    
}

// **********************************************************************************************************
// Function to read back the value previously sent and echo to the screen
//
// void ping()
// Return data - none
// **********************************************************************************************************

void ping() {
		cout << "READBACK TEST" << endl; 
		for (unsigned short u=0; u<10; u++) {
			uint16_t rnd = rand() & 0x0FFF;
			uint16_t ret_val = spi_readwrite(fpgaWord(READBACK, rnd));	//Turn off all LEDs + read switches (in one full-duplex transaction)
			wait_ms(20);
			printf("Out: %X, In: %X\n\r", rnd, ret_val);
		}
}


// **********************************************************************************************************
// Function to ADC Read function
//
// uint16_t adc_read()
// Return data - 16 bit unsigned value (top 4 bits should always be 0)
// **********************************************************************************************************

void adc_read() {
		cout << "ADC READ TEST" << endl; 

		spi_readwrite(fpgaWord(ADC_READ, 0));	//READ ADC COMMAND
		wait_ms(2);
		uint16_t ret_val = spi_readwrite(fpgaWord(ADC_READ, 0));	//READ ADC COMMAND + RESULT
		cout << endl;
		cout << "******************************" << endl;
		cout << "******************************" << endl;
		cout << "*  ADC VALUE RETURED: " << ret_val << endl;
		cout << "******************************" << endl;
		cout << "******************************" << endl;
}

// **********************************************************************************************************
// Function to test the PC register component (25% for LD; 25% for latch; 25% for inc; 25% for priority)
//
void pc_test()
{
		const uint16_t LD  = 1 << 8;
		const uint16_t INC = 1 << 9;
	
		//Load value into register
		uint16_t payload = 0b10101100;
		BinaryType<uint16_t> p(payload);
	
		spi_readwrite(fpgaWord(PC_TEST, payload | LD));
		uint16_t ret_val = spi_readwrite(fpgaWord(PC_TEST, payload | INC ));
		BinaryType<uint16_t> rx(ret_val);
		if (ret_val == payload) {
				cout << "  PC Reg LD PASSED" << endl;
		}
		ret_val = spi_readwrite(fpgaWord(PC_TEST, payload | INC));
		if (ret_val == payload + 2) {
				cout << "  PC REG INC behaviour PASSED" << endl;
		}		
		
}

// Return data - score between 0 and 1.0
// **********************************************************************************************************

// **********************************************************************************************************
// Function to test the add component 
//
// **********************************************************************************************************
void add_test() {
		cout << "*********" << endl;
		cout << "* ADDER *" << endl;
		cout << "*********" << endl;
	
		uint16_t p,q,y,ret_val,sum = 0;
		uint8_t overf, carry;
	
		p = 0b0110;
		q = 0b0001;			
		y = (p << 4) | q;
		spi_readwrite(fpgaWord(ADD_TEST, y));
		ret_val = spi_readwrite(fpgaWord(ADD_TEST, y)); //Dummy write to read back previous result
		
		sum   = ret_val & 0x000F;
		carry = (ret_val & (1 << 4)) >> 4;
		overf = (ret_val & (1 << 5)) >> 5;	
		
		BinaryType<uint8_t> pp(p);
		BinaryType<uint8_t> qq(q);
		BinaryType<uint8_t> yy(sum);

		pp.display(); 
		cout << " + ";
		qq.display();
		cout << " = ";
		yy.display();
		cout << endl;	
		cout << "Carry  " << unsigned(carry) << endl;
		cout << "Overflot " << unsigned(overf) << endl;
			
}

// **********************************************************************************************************
// Function to test the interleave component and echo to the screen
//
// bool inter_test(bool correctly_aligned)
//
// correctly_aligned - set to true to test for perfect alignment, with lsb of upper nibble in lsb of result; 
//                     set to false to see if they got it the wrong way around (half marks)
// Return data - true if the test is passed
// **********************************************************************************************************
void inter_test() 
{
	uint8_t u ,y = 0;

	cout << "*******************" << endl;
	cout << "* INTERLEAVE TEST *" << endl;	
	cout << "*******************" << endl;

	u = (uint16_t)(rand() & 0x00FF);
	spi_readwrite(fpgaWord(INTERLEAVE_TEST, u));	
	uint16_t ret_val = spi_readwrite(fpgaWord(INTERLEAVE_TEST, u));	
	y = (uint8_t)(ret_val & 0x00FF);
		
	BinaryType<uint8_t> uu(u >> 4);			//most significant nibble
	BinaryType<uint8_t> vv(u & 0x000F);	//
	BinaryType<uint8_t> yy(y);	

	cout << "Sent ";
	uu.display();
	cout << " and ";
	vv.display();
	cout << " : Recevied ";
	yy.display();
	
	cout << endl;
}


// **********************************************************************************************************
// uint16_t spi_readwrite(uint16_t data)
//
// Function for writing to the SPI with the correct timing
// data - this parameter is the data to be sent from the MCU to the FPGA over the SPI interface (via MOSI)
// return data - the data returned from the FPGA to the MCU over the SPI interface (via MISO)
// **********************************************************************************************************

uint16_t spi_readwrite(uint16_t data) {	
	cs = 0;             									//Select the device by seting chip select LOW
	uint16_t rx = (uint16_t)spi.write(data);				//Send the data - ignore the return data
	wait_us(1);													//wait for last clock cycle to clear
	cs = 1;             									//De-Select the device by seting chip select HIGH
	wait_us(1);
	return rx;
}
