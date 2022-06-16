///////////////////////////////////////////////////////////////////////////////////////
//NAME:     SPORTisr.c (Block-based Talkthrough)
//DATE:     7/29/05
//PURPOSE:  Talkthrough framework for sending and receiving samples to the AD1835.
//
//USAGE:    This file contains SPORT0 Interrupt Service Routine. Three buffers are used
//          for this example. One is filled by the ADC, another is sent to the DAC, and
//          the final buffer is processed. Each buffer rotates between these functions
//          upon each SP0 interrupt received.
///////////////////////////////////////////////////////////////////////////////////////
/*
   Here is the mapping between the SPORTS and the DACS
   ADC -> DSP  : SPORT0A : I2S
   DSP -> DAC1 : SPORT1A : I2S
   DSP -> DAC2 : SPORT1B : I2S
   DSP -> DAC3 : SPORT2A : I2S
   DSP -> DAC4 : SPORT2B : I2S
*/

#include "tt.h"
#include <stdio.h>
#include "modem.h"


extern void	Receive_Samples(void);
extern void	Transmit_Samples(void);
extern int bit_data;

extern float Left_Channel_Out0;
extern float Right_Channel_Out0;
extern float Left_Channel_Out1;
extern float Right_Channel_Out1;
extern float Left_Channel_In0;
extern float Right_Channel_In0;
extern float gene_sinus_LUT(int);



// Semaphore to indicate to main that a block is ready for processing
int blockReady=0;

// Semaphore to indicate to the isr that the processing has not completed before the   
// buffer will be overwritten.   
int isProcessing=0; 
  
int cmpt=0;
float oscilloscope[1920];


void TalkThroughISR(int sig_int)
{
	float k;
	
	Receive_Samples();
	
	   	oscilloscope[cmpt%1920]=Left_Channel_In0;   // ou sur l'autre entr�e possible :
     // oscilloscope[cmpt%1920]=Right_Channel_In0;
  		cmpt++;
/////////////////// copie de l'�chantillon d'entr�e sur les sorties
	k=	oscilloscope[cmpt%1920];
	////////////////////////
	/* Out data is the same for all output*/
	Left_Channel_Out0 	= k;
	Right_Channel_Out0 	= k;
	
	Left_Channel_Out1 	= k;
	Right_Channel_Out1 	= k;	
	
	/* debug local ***********************/

	
	blockReady = 1;
	Transmit_Samples();
}
