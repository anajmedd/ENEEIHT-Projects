#include<math.h>


float LUT_sinus[512] = {
#include "LUT_512.dat"
} ;
float Oscilloscope[1064];
float Oscilloscope_2[10024]={};

int fs=980;
int fe=8000;

/* Génération d'un tableaux de sinus en utilisant la fonction sinf  */ 
int gene_sinus(float frequence, float freq_sampling,int N_sample) {
    int i;
    for(i=0;i<N_sample;i++) {
		Oscilloscope[i] = sinf(i*2*M_PI*frequence/freq_sampling);
	}
	return 1;
}


/* Génération du sinus à partir d'un tableau LUT */
int gene_sinus_LUT_C(float frequence, float freq_sampling,int N_sample) {
    int i;
    for(i=1;i<N_sample;i++) {
        int pas = 512*frequence*i/freq_sampling;
        Oscilloscope[i]=LUT_sinus[(int)(pas * i)%512];
    }
    return 1;
}
/* Génération du signal modulé FSK */
Int FSK_Modulator(float freq_1, float freq_0, float f_sampling, int Data, int Baud ) {
    // Condition sur le dernier bit de Data.
    if (Data & 1) {
        int N_sample = f_sampling/Baud;
        int k;
        for (k = 1; k <= 10; k++) {
            // Créer un signal sinusoïdale de frequence freq_1 ou freq_0
            if ((1<<k) & Data) {
                gene_sinus_LUT_C(freq_1,f_sampling,N_sample,k);
            } else {
                gene_sinus_LUT_C(freq_0,f_sampling,N_sample,k);
            }
        }
    }
    return 1;
}

int main(void) {
    //gene_sinus(fs, fe, 267);
	//gene_sinus_LUT_C(fs, fe, 267,0);
	//FSK_Modulator (980, 1180, 8000, 0x199, 300);
    return 1;
}