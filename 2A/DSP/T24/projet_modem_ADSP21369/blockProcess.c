#include "tt.h"
#include "modem.h"  

// VISIBILITY SECTION /////////////////////////////
//extern float gene_sinus_LUT(int);
//extern int bit_data;

// DATA SECTION //////////////////////////////////

//int k;


// Place the audio processing algorith here. The input and output are given
// as unsigned integer pointers.
void processBlock(unsigned int *block_ptr)
{
    int i;
    float temp_out; 

    //Clear the Block Ready Semaphore
    blockReady = 0;
    
    //Set the Processing Active Semaphore before starting processing
  isProcessing = 1;
    
    
    for (i = 0; i < NUM_SAMPLES; i++)  //NUM_SAMPLES=2  ds tt.h
    {
       *(block_ptr+i)=*(block_ptr+i); 
    }

/*	/////////////////////////////////////////////////////////////
	if (bit_data !=0){
		k=gene_sinus_LUT(PAS_F1); // read data type F1 from LUT
	}else{
		k=gene_sinus_LUT(PAS_F0); // read data type F0 from LUT	
					  	}

// Out data is the same for  output0  , voir ds Driver : rx_tx_samples.asm

	Transmit_Samples();*/

    //Clear the Processing Active Semaphore after processing is complete
    isProcessing = 0;
}
