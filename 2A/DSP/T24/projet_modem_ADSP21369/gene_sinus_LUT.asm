#include<asm_sprt.h>
.extern _LUT_sinus;
.extern _pointer_LUT;

.SEGMENT/PM   seg_pmco;
///////////////////////////////////////////////////////
//  float gene_sinus_LUT(int pas)
///////////////////////////////////////////////////////
.GLOBAL _gene_sinus_LUT;
_gene_sinus_LUT:
		///
		
		
		//A compléter
		
		///
	exit;					// Pour retourner dans le C.
	//rts à la place de exit pour retourner dans l'assembleur
_gene_sinus_LUT.end :  


//////////////////////////////////////////////////////
// void init_gene_sinus_LUT(void)
/////////////////////////////////////////////////////// 
.GLOBAL _init_gene_sinus_LUT;
_init_gene_sinus_LUT:
b12 = _LUT_sinus;  	// init pointer on LUT : @ circular %512
l12 = 512;
r0=dm(_pointer_LUT);
i12=r0;
exit;
_init_gene_sinus_LUT.end : 
.ENDSEG;