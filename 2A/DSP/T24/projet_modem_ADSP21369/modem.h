////////////////////// DEFINE SECTION ////////////////////////////////
#define PI 					3.1451926
#define N_LUT				512
#define N_FIR               247
#define BAUD				300
#define NB_BIT_PER_DATA		12
#define F_SAMPLE			48000   // Fréquence d'échantillonnage du Codec
#define V21_F1				980	    // Fréquence f1
#define V21_F0				1180// Fréquence f0  ; 
#define PAS_F1				(N_LUT*V21_F1)/F_SAMPLE  //=> PAS_F1=10 (512*980/48000)
#define PAS_F0				(N_LUT*V21_F0)/F_SAMPLE  //=> PAS_F0=12 (512*1180/48000)
#define SAMPLE_PER_BIT		F_SAMPLE/BAUD // => SAMPLE_PER_BIT=160 (48000/300) 
#define TAILLE              1920

//Taille du  filtre moyenneur :
#define T_MELANGEUR			100     //=> BP=(fe/Nfiltre)=48000/100=480Hz
 
//pour passer aux registres secondaires :
#define enable_sec_reg bit set mode1 0x4f8; nop; nop; 
 //pour repasser aux registres primaires :
#define disable_sec_reg bit clr mode1 0x4f8; nop; nop; 
