#include <asm_sprt.h>
#include<asm_sprt.h>

.segment /dm seg_dmda;

/* AD1835 stereo-channel data holders - used for DSP processing of audio data received from codec */
// input channels
.var 			_Left_Channel_In0;			/* Input values from the 2 AD1835 internal stereo ADCs */
.var 			_Right_Channel_In0;
//output channels
.var			_Left_Channel_Out0;			/* Output values for the 2 AD1835 internal stereo DACs */
.var			_Right_Channel_Out0;
.var			_Left_Channel_Out1;			/* Output values for the 2 AD1835 internal stereo DACs */
.var			_Right_Channel_Out1;

.global			_Left_Channel_In0;
.global			_Right_Channel_In0;
.global 		_Left_Channel_Out0;		
.global 		_Right_Channel_Out0;
.global 		_Left_Channel_Out1;		
.global 		_Right_Channel_Out1;

.extern			_Block_A;
.extern			_Block_B;
.extern			_Block_C;
.endseg;


.segment /pm seg_pmco;

_Receive_Samples:
.global _Receive_Samples;
//void	Receive_Samples();
	/* get AD1835 left channel input samples, save to data holders for processing */
	r1 = -19;
	r0 = dm(_Block_A + 1);	f0 = float r0 by r1;	dm(_Left_Channel_In0) = r0;			
	/* get AD1835 right channel input samples, save to data holders for processing */
	r0 = dm(_Block_A + 0);	f0 = float r0 by r1;	dm(_Right_Channel_In0) = r0;			
	
	leaf_exit;
_Receive_Samples.end:


_Transmit_Samples:
.global _Transmit_Samples;

	r1 = 19;

	/* output processed left ch0 audio samples to AD1835 */
	r0 = dm(_Left_Channel_Out0);	r0 = trunc f0 by r1;	dm(_Block_B + 1) = r0;

	/* output processed right ch0 audio samples to AD1835 */
	r0 = dm(_Right_Channel_Out0); 	r0 = trunc f0 by r1;	dm(_Block_B) = r0;

	/* output processed left ch1 audio samples to AD1835 */
	r0 = dm(_Left_Channel_Out1);	r0 = trunc f0 by r1;	dm(_Block_C + 1) = r0;

	/* output processed right ch1 audio samples to AD1835 */
	r0 = dm(_Right_Channel_Out1); 	r0 = trunc f0 by r1;	dm(_Block_C) = r0;
		leaf_exit;
_Transmit_Samples.end:

.endseg;