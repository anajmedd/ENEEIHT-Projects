// INCLUDE SECTION ///////////////////////////////

#include <math.h>

// VISIBILITY SECTION //////////////////////////////////
extern int	test(int,int,float);
extern int gene_sinus_LUT_asm_v1(int);
extern int gene_sinus_LUT_asm_v2(float, float, float);
float Oscillo[512]={};

float pm LUT_sinus[512] = {
#include "LUT_512.dat"
};
// CODE SECTION //////////////////////////////////

int pas = 10;
int s;
void	main()
{
int toto;
	while(1) {
		s =	gene_sinus_LUT_asm_v2(980, 8000, 128);
	}

}
