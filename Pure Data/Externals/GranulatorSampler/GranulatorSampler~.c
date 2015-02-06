/**************************WAVETABLE EXTERNAL**************************
This external is a oscillator generator, including granulators.

It takes a ramp as reference from the first inlet. 

1 - Grain Length
3- Grain duration


and then generates an output according to the output selector.
***********************************************************************/
#include "m_pd.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define FS 44100
#define RAND_SEQ 10000

#define SAMPLES 4096
#define PI 3.141592654
#define e 2.71828183

float* GaussFunction(int samples);
float* InitializeRandom(int samples);


/***************************CLASS DECLARATION***************************/
static t_class *GranulatorSampler_tilde_class; //create GranulatorSampler_class

/***************************DATA SPACE***************************/
//variables of the class
typedef struct _GranulatorSampler_tilde {
  t_object x_obj; //object properties for PD environment
  
  t_int GrainTime; //nominal length in samples
  
  t_int GrainLength, TransientLength, WaitLength, SteadyLength;
    
  t_float SampleRate;
  
  //Variables to be modified with outlets
  t_float randomness;
  t_float density;
  t_float transient;
  //calculated variables
  t_float increment;
  t_int counter;
  t_float ramp;
  t_float PositionRan;
  
  t_int On;
   
  t_float GrainShapeIn;
  t_int GrainShape; //0- Gauss, 1-linear, 2-pow 2, 3-linear
 
  int RanControl;
  
  int samples, CurrentSample, StartSample;
  
  t_float *RandomTable, *GaussTable;
  t_outlet *x_out, *SamplerOut;
} 
t_GranulatorSampler_tilde;


float Random(t_GranulatorSampler_tilde *x);
float TransientValue (t_GranulatorSampler_tilde *x, float ramp);
void CalculateNextGrain (t_GranulatorSampler_tilde *x);


/***************************METHODS***************************/

/*The perform routine contains the functionality of the external*/
t_int *GranulatorSampler_tilde_perform(t_int *w) {
  t_GranulatorSampler_tilde *x = (t_GranulatorSampler_tilde *)(w[1]); 
  if(x->On) {
      t_sample *out = (t_sample *)(w[2]); 	//cast to the first output
      t_sample *SamplerOut=(t_sample *)(w[3]);
      int n=(int)(w[4]); 	    		//cast to the length of the 

      ////printf("DSP convertions done, received %d samples\n", n);
      t_sample output;
      int counter, sample;
      float ramp, increment;
      ramp=x->ramp;
      counter=x->counter;
      increment = x->increment;
      sample=x->CurrentSample;
      while(n--) { //*****attack
	if (counter<x->TransientLength) {
	  ramp += increment;
	  if (ramp>1) ramp = 1.0; //bounding the ramp to 1
	  output=TransientValue(x,ramp);
	  sample++;
	}
	else if (counter<x->TransientLength+x->SteadyLength){//*****steady
	  output=1;
	  sample++;
	}
	else if (counter<x->GrainLength){//*****decay
	  ramp-=increment;
	  if(ramp<0.0) ramp=0.0;
	  output=TransientValue(x, ramp);
	  sample++;
	}
	else {//******wait
	  output=0;
	}
	counter++;
	*out++=output;
	//*SamplerOut++=(t_sample)sample/x->samples;
	*SamplerOut++=(t_sample)sample;

      }
	x->CurrentSample=sample;

	if (counter>x->GrainLength+x->WaitLength) {
	  counter=0;
	  CalculateNextGrain(x);
	}
      
      x->ramp=ramp;
      x->counter=counter;
  }
     return(w+5);
}

float TransientValue (t_GranulatorSampler_tilde *x, float ramp) {
  float value;
  int index;
  if (x->GrainShape==0) {
    index = ramp*SAMPLES;
    value=*(x->GaussTable+index);
  }
  
  else if (x->GrainShape==1) {//linear
   value=ramp;
  }
  else if (x->GrainShape==2) {//sqrt
    value=pow(ramp, 0.5);  
  }
  else{ //pow2
    value=pow(ramp, 2);
  }
  return value;
}

void GrainTime(t_GranulatorSampler_tilde *x, t_floatarg f) { //pointer
  x->GrainTime = f*(float)(x->SampleRate/1000);
}

void CalculateNextGrain(t_GranulatorSampler_tilde *x){
  int GrainLength;
  int TransientLength, SteadyLength, WaitLength;
  float ran = Random(x);
  GrainLength=x->GrainTime*(1+x->randomness*ran);
  TransientLength=x->transient*GrainLength/2;
  WaitLength = x->GrainLength*(1/x->density-1);
 
  x->GrainShape=(int)x->GrainShapeIn;
  x->GrainLength = GrainLength;
  x->TransientLength = TransientLength;
  x->SteadyLength = GrainLength-2*TransientLength;
  x->WaitLength = WaitLength;
  x->increment = 1/(float)x->TransientLength;   
  if (x->increment > 1) x->increment = 1;
  else if (x->increment <-1) x->increment = -1;
  
  x->ramp=0.0;

  //SampleOut=0;
  int NewStartPoint, limit, samples;
  samples=x->samples;
  ran = Random(x);
  //StartSample=x->StartSample;
 
  limit = x->samples - GrainLength;
  
  if (x->RanControl) {
    ran=rand()%limit;
    NewStartPoint = x->StartSample + x->PositionRan*(ran-x->StartSample);
    if(NewStartPoint<0) {
      NewStartPoint = 1;
    }
    else if (NewStartPoint>=limit) {
      NewStartPoint=limit-1;
    }
  }
  else{
    NewStartPoint=rand()%limit;
    x->CurrentSample=NewStartPoint;
    
  }
  //printf("Start Sample %d\n", NewStartPoint);
  //StartSample=rand()%limit;
  x->CurrentSample=NewStartPoint;
 
  /**********************************************
   *       ---------
   *     - |       |-
   *    -  |       | -
   *   -   |       |  -
   *  -    |       |   -                   -
   * -     |       |    - ________________-
   *|attack|steady|decay| wait           |
   * *******************************************/
}
 
/*The GranulatorSampler_dsp method adds a perform-routine to the DSP-tree.*/
void GranulatorSampler_tilde_dsp(
  t_GranulatorSampler_tilde *x, //pointer to the class data space
  t_signal **sp) { //pointer to the sp array (1)
  dsp_add(
    GranulatorSampler_tilde_perform,//performing routine
    4,	//number of the following pointers to variables passed
		    //to the GranulatorSampler_perform routine
    x,		//pointer to the data space 
    sp[0]->s_vec, 	//out-signal
    sp[1]->s_vec, 	//out-signal
    sp[0]->s_n);	//pointer to the length of the signal (3)

  x->SampleRate = sp[0]->s_sr;
  //printf("DSP Initialized\n");
}
void Samples(t_GranulatorSampler_tilde *x, t_floatarg f) {
	x->samples=(int)f;
	//printf("Samples: %d\n", x->samples);
}

/***************************DESTRUCTOR***************************/
void GranulatorSampler_tilde_free(t_GranulatorSampler_tilde *x) {
	outlet_free(x->x_out); //free the output x_out

}

void On(t_GranulatorSampler_tilde *x) {
	x->On=1;
	//printf("On, %d\n", (int)x->On);
}

void Off(t_GranulatorSampler_tilde *x) {
	x->On=0;
	//printf("Off, %d\n", (int)x->On);
}

void StartSample(t_GranulatorSampler_tilde *x, t_floatarg f) {
	x->StartSample=(int)f;
	if(x->StartSample > x->samples) {
	 //printf("Error, StartSample exceed samples limit\n"); 
	}
	else {
	 //printf("New Start sample %d\n", x->StartSample); 
	}
}

void PositionRan(t_GranulatorSampler_tilde *x, t_floatarg f) {
	x->PositionRan=f;
	if(x->PositionRan< 0 || x->PositionRan>1) {
	  //printf("Error, position random should be between 0 and 1\n"); 
	  x->PositionRan=0.5;
	}
}

void RanControl(t_GranulatorSampler_tilde *x, t_floatarg f) {
  int a;
  a=(int)f;
  if (a) {
    x->RanControl=1;
    //printf("Control over the starting position activated\n");
  }
  else {
    x->RanControl=0;
    //printf("Control over the starting position desactivated\n");
  }
}


/***************************CONSTRUCTOR***************************/

void *GranulatorSampler_tilde_new(t_floatarg f) { 
  t_GranulatorSampler_tilde *x =(t_GranulatorSampler_tilde *) 
      pd_new(GranulatorSampler_tilde_class);
  
  floatinlet_new(&x->x_obj, &x->density); 	//writes  the input data from 
  floatinlet_new(&x->x_obj, &x->transient);
  floatinlet_new(&x->x_obj, &x->randomness);
  floatinlet_new(&x->x_obj, &x->GrainShapeIn);

  x->GrainShape=0;
  x->counter=0;
  x-> SamplerOut= outlet_new(&x->x_obj, &s_signal);//selector "signal"
  x-> x_out = outlet_new(&x->x_obj, &s_signal);//selector "signal"

  
  x->counter=0;
  //Initialize variables  
  x->GrainTime=4410; //nominal length in samples    
  
  //Variables to be modified with outlets
  x->randomness=0;
  x-> density=0.5;
  x-> transient=0.5;
  //calculated variables
  x->increment=0.0;
  x-> counter=0;
  x-> ramp=0;
  
  x->GrainShapeIn=0;
  x->GrainShape=0; //0- Gauss, 1-linear, 2-pow 2, 3-linear
  
  x->samples=10000;
  x->RanControl=0;
  x->On=0;
  
  t_float *RandomTable, *GaussTable;
  x->GaussTable=GaussFunction(SAMPLES+1);
  x->RandomTable=InitializeRandom(RAND_SEQ+1);
  
  CalculateNextGrain(x);
  return (void *)x;
  f++;
}

/***************************SETUP***************************/
void GranulatorSampler_tilde_setup(void) {
  GranulatorSampler_tilde_class=class_new	
    (gensym("GranulatorSampler~"),
    (t_newmethod)GranulatorSampler_tilde_new,
    (t_method)GranulatorSampler_tilde_free,
    sizeof(t_GranulatorSampler_tilde),
    CLASS_DEFAULT,
    0); 

  class_addmethod(
    GranulatorSampler_tilde_class,
    (t_method)GranulatorSampler_tilde_dsp,
    gensym("dsp"),
    0); 
	
  class_addmethod(		//new method 
    GranulatorSampler_tilde_class, 	//belonging class
    (t_method)GrainTime,//defines the method
    gensym("GrainTime"),		//defining the method for dsp (1)
    A_DEFFLOAT,
    0); 
  
   class_addmethod(		//new method 
    GranulatorSampler_tilde_class, 	//belonging class
    (t_method)On,//defines the method
    gensym("On"),		//defining the method for dsp (1)
    0); 
   
   class_addmethod(		//new method 
    GranulatorSampler_tilde_class, 	//belonging class
    (t_method)Off,//defines the method
    gensym("Off"),		//defining the method for dsp (1)
    0); 
  
  class_addmethod(		//new method 
    GranulatorSampler_tilde_class, 	//belonging class
    (t_method)Samples,//defines the method
    gensym("samples"),		//defining the method for dsp (1)
    A_DEFFLOAT,
    0); 
  
    class_addmethod(		//new method 
    GranulatorSampler_tilde_class, 	//belonging class
    (t_method)StartSample,//defines the method
    gensym("StartSample"),		//defining the method for dsp (1)
    A_DEFFLOAT,
    0); 
    
    class_addmethod(		//new method 
    GranulatorSampler_tilde_class, 	//belonging class
    (t_method)PositionRan,//defines the method
    gensym("PositionRan"),		//defining the method for dsp (1)
    A_DEFFLOAT,
    0); 
    class_addmethod(		//new method 
      GranulatorSampler_tilde_class, 	//belonging class
      (t_method)RanControl,//defines the method
      gensym("RanControl"),//defining the method for dsp (1)
      A_DEFFLOAT,
      0); 
      
class_addfloat(GranulatorSampler_tilde_class, GrainTime);
}

float* GaussFunction(int samples){
   float GaussTable[samples];
   int index=0;  
    /************************************
   * Gaussian function
   *
   * 		  -(x-b)²
   * f(x)= A·exp(_________)	
   * 		    2c²
   ************************************/
  double exponent;
  double x, a=1, b=1, c=0.4;
  double num, den, result, offset, scale;
   
  
  //Calculates and fills the Gauss SineTable
  for (index=0; index<samples; index++) {
    x=(double)index/samples;
    num=x-b;
    num= - pow(num, 2);
    den = 2*pow(c,2);
    exponent=num/den;
    result=a*pow(e, exponent);
    if(index==0)  offset=result;
    GaussTable[index]=(result-offset)*(1+offset); //starting at 0 and 
		//normalizint to 1
  }
   //allocate the table into memory
  float *pointer;
  pointer = malloc(samples*sizeof(float));
  memcpy(pointer, GaussTable, samples*sizeof(float));
  return pointer;
  } 

 float* InitializeRandom(int samples){
 int index=0, i;
 float WhiteNoiseTable[samples];
  srand(time(NULL));

  for (index=0; index<samples; index++) {
 /*****White Gaussian Noise Generator****/   
    double temp1, temp2, result;
    int p;
    p = 1;
    while( p > 0 )
    {
      temp2 = ( rand() / ( (double)RAND_MAX ) );
      if ( temp2 == 0 )
      {// temp2 is >= (RAND_MAX / 2)
	p = 1;
      }// end if
      else
      {// temp2 is < (RAND_MAX / 2)
	p = -1;
      }// end else
    }// end while()
    temp1 = cos( ( 2.0 * (double)PI ) * rand() / ( (double)RAND_MAX ) );
    result = sqrt( -2.0 * log( temp2 ) ) * temp1;
    result = result/3;
    WhiteNoiseTable[index]=(float)result;
  }
  //allocate the table into memory
  float *pointer;
  pointer = malloc(samples*sizeof(float));
  memcpy(pointer, WhiteNoiseTable, samples*sizeof(float));
  int count=0;
 return pointer;
}

float Random(t_GranulatorSampler_tilde *x) {
  float* table;
  float output;
  int offset;
  table = x-> RandomTable;
  offset=rand()%RAND_SEQ;
  output= *(table + offset);
  return output;
}