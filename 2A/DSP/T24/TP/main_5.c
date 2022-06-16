// INCLUDE SECTION ///////////////////////////////

#include <math.h>

// VISIBILITY SECTION //////////////////////////////////
extern int	test(int,int,float);
extern int gene_sinus_LUT_asm_v1(int);
extern int gene_sinus_LUT_asm_v2(float, float, float);
extern int FSK_Modulator_Opt (float freq_1, float freq_0, float f_sampling);
float Oscillo[512]={};
float Oscilloscope_2[10024]={};
float pm LUT_sinus[512] = {
#include "LUT_512.dat"
};

int Data = 0;
float baud = 0;
int N_sample = 0;
int addr = LUT_sinus; 
int addr_oscillo = Oscilloscope_2;



int FSK_Modulator (float freq_1, float freq_0, float f_sampling, int Data, int Baud ){
		float N_sample = f_sampling/Baud;	
        int j;	
		for (j = 1; j <= 10; j++){
			if ((1<<j) & Data){
				addr = gene_sinus_LUT_asm_v2(freq_1,  f_sampling, N_sample);		
			}
			else{
				addr = gene_sinus_LUT_asm_v2(freq_0, f_sampling,N_sample);
			}
			N_sample = (int)(N_sample)+N_sample;
		}
	return 1;
}


// CODE SECTION //////////////////////////////////

int pas = 10;
void	main()
{
	

	
while(1){	
	//	FSK_Modulator (980, 1120, 8000, 0x55, 300);
		Data = 0x55;
		baud = 100;
		FSK_Modulator_Opt (500,1500,8000);	
}
}	



	
