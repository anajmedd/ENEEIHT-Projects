///////////////////////////////////////////////////////////////////////////////////////
//NAME:     main.c (Block-based Talkthrough)
//
////////////////////////////////////////////////////////////////////////////////////////
#include "modem.h"
#include <def21161.h>
#include <signal.h>
#include <math.h>
#include <SPORTisr.c>

extern void init_gene_sinus_LUT(void);
void Process_Samples(int);


// DATA SECTION //////////////
float pm LUT_sinus [512] = {
	#include "LUT_512.dat"
	};

float* pointer_LUT;

int nb_sample_bit;
int nb_bit;
int masque_bit_data;
int bit_data;


// DATA TO SEND ///////////////////
int data_ASCII= 0xFFFFFD55;	
	

void main(void)
{

    //Initialize PLL to run at CCLK= 331.776 MHz & SDCLK= 165.888 MHz.
    //SDRAM is setup for use, but cannot be accessed until MSEN bit is enabled
    InitPLL_SDRAM();

    // Need to initialize DAI because the sport signals need to be routed
    InitSRU();

    // This function will configure the codec on the kit
    Init1835viaSPI();

    // Init Interrupt on receive data /////////////
	// pour 21161 :interruptf(	SIG_SP0I,Process_Samples);
    interrupt (SIG_SP0,TalkThroughISR);
    // Finally setup the sport to receive / transmit the data
    InitSPORT();
    
	pointer_LUT=&LUT_sinus [0]; // init pointer
	init_gene_sinus_LUT();		// init i12 as LUT pointer
	
	while(1)
	{
	//modulation CFSK
	nb_bit = 0;
	masque_bit_data=0x80000000;
	while(nb_bit < NB_BIT_PER_DATA) {
		if(data_ASCII & masque_bit_data) {
			bit_data = 1;
		}
		else {
			bit_data = 0;
		}
		nb_bit++;
		masque_bit_data = masque_bit_data >> 1;

		nb_sample_bit=0;
		// SYNCHRO ON IT . DO UNTIL NB SAMPLE PER BIT WILL SEND
		while(nb_sample_bit < SAMPLE_PER_BIT){
			 //Clear the Processing Active Semaphore after processing is complete
    		blockReady = 0;
			while(!blockReady);  // Wait for IT (f_sampling)
			nb_sample_bit++;
		}
		
	}
    }
}   

