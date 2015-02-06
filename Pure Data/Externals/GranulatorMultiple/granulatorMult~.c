/**************************WAVETABLE EXTERNAL**************************
This external is a oscillator generator, including granulatorMults.

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
#define MAX_GRAINS 50
#define _GNU_SOURCE

#define SAMPLES 4096
#define PI 3.141592654
#define e 2.71828183

float* GaussFunction(int samples);
float* InitializeRandom(int samples);


/***************************CLASS DECLARATION***************************/
static t_class *granulatorMult_tilde_class; //create granulatorMult_tilde_class

/***************************DATA SPACE***************************/
//variables of the class
typedef struct _granulatorMult_tilde {
  t_object x_obj; //object properties for PD environment
  
  t_int GrainTime; //nominal length in samples
  
  int GrainLength[MAX_GRAINS], TransientLength[MAX_GRAINS];
  int WaitLength[MAX_GRAINS], SteadyLength[MAX_GRAINS];
  int GrainChannels;
    
  t_float SampleRate;
  
  //Variables to be modified with outlets
  t_float randomness;
  t_float density;
  t_float transient;
  //calculated variables
  t_float increment[MAX_GRAINS];
  t_int counter[MAX_GRAINS];
  t_float ramp[MAX_GRAINS];
   
  t_float GrainShapeIn;
  t_int GrainShape; //0- Gauss, 1-linear, 2-pow 2, 3-linear
  
  t_float *RandomTable, *GaussTable;
  t_outlet *x_out;
} 
t_granulatorMult_tilde;


float Random(t_granulatorMult_tilde *x);
float TransientValue (t_granulatorMult_tilde *x, float ramp);
void CalculateNextGrain (t_granulatorMult_tilde *x, int index);


/***************************METHODS***************************/

/*The perform routine contains the functionality of the external*/
t_int *granulatorMult_tilde_perform(t_int *w) {
  t_granulatorMult_tilde *x = (t_granulatorMult_tilde *)(w[1]); //the first 
     
    t_sample *out = (t_sample *)(w[2]); 	//cast to the first output
    int n=(int)(w[3]); 	    		//cast to the length of the 

    t_sample output=0.0, outputBuffer=0.0;
    int counter, i;
    while(n--) { 
      for (i=0; i<x->GrainChannels; i++) {
	if (x->counter[i]<x->TransientLength[i]) {//*****attack
	  x->ramp[i] += x->increment[i];
	  if (x->ramp[i]>1) x->ramp[i] = 1.0; //bounding the ramp to 1
	  outputBuffer+=TransientValue(x, x->ramp[i]);
	}
	//Stady
	else if (x->counter[i]<x->TransientLength[i]+x->SteadyLength[i]){
	  outputBuffer+=1;
	}
	else if (x->counter[i]<x->GrainLength[i]){//*****decay
	  x->ramp[i]-=x->increment[i];
	  if(x->ramp[i]<0.0) x->ramp[i]=0.0;
	  outputBuffer+=TransientValue(x, x->ramp[i]);
	}
	else {//******wait
	  outputBuffer+=0;
	}
	  x->counter[i]++;
	  outputBuffer+=output;
	  if (x->counter[i]>x->GrainLength[i]+x->WaitLength[i]) {
	    x->counter[i]=0;
	    CalculateNextGrain(x, i);
	  }	  
      }
      *out++=outputBuffer/(float)x->GrainChannels;
      outputBuffer=0.0; 
      }

     return(w+4);
}

float TransientValue (t_granulatorMult_tilde *x, float ramp) {
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

void GrainTime(t_granulatorMult_tilde *x, t_floatarg f) { //pointer
  x->GrainTime = f*(float)(x->SampleRate/1000);
}

void GrainChannels(t_granulatorMult_tilde *x, t_floatarg f) { //pointer
  x->GrainChannels = (int)f;
  if (x->GrainChannels<1) x->GrainChannels=1;
  else if (x->GrainChannels>MAX_GRAINS) x->GrainChannels = MAX_GRAINS;
  printf("Channels %d\n", x->GrainChannels);
}

void CalculateNextGrain(t_granulatorMult_tilde *x, int index){
  int GrainLength, TransientLength, SteadyLength, WaitLength;
  float ran = Random(x), increment;
  
  GrainLength=x->GrainTime*(1+x->randomness*ran);
  TransientLength=x->transient*GrainLength/2;
  SteadyLength=GrainLength-2*TransientLength;
  WaitLength = GrainLength*(1/x->density-1); 
  increment = 1/((float)TransientLength);
  if(increment >1 ) increment = 1.0;
  else if (increment < 0.0) increment =0.0;
  
  
  x->GrainShape=(int)x->GrainShapeIn;
  x->GrainLength[index] = GrainLength;
  x->TransientLength[index] = TransientLength;
  x->SteadyLength[index] = SteadyLength;
  x->WaitLength[index] = WaitLength;
  x->increment[index] = increment;
  x->ramp[index]=0.0;
  //printf("Grain Time %f, wait time %f\n", (float)x->GrainLength/44.1, 
	  //(float)x->WaitLength/44.1);
  //printf("ran %f\n", ran);
 
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
 
/*The granulatorMult_tilde_dsp method adds a perform-routine to the DSP-tree.*/
void granulatorMult_tilde_dsp(
  t_granulatorMult_tilde *x, //pointer to the class data space
  t_signal **sp) { //pointer to the sp array (1)
  dsp_add(
    granulatorMult_tilde_perform,//performing routine
    3,	//number of the following pointers to variables passed
		    //to the granulatorMult_tilde_perform routine
    x,		//pointer to the data space 
    sp[0]->s_vec, 	//out-signal
    sp[0]->s_n);	//pointer to the length of the signal (3)

  x->SampleRate = sp[0]->s_sr;
}

/***************************DESTRUCTOR***************************/
void granulatorMult_tilde_free(t_granulatorMult_tilde *x) {
	outlet_free(x->x_out); //free the output x_out

}

/***************************CONSTRUCTOR***************************/

void *granulatorMult_tilde_new(t_floatarg f) { 
  t_granulatorMult_tilde *x =(t_granulatorMult_tilde *) 
pd_new(granulatorMult_tilde_class);
  
  floatinlet_new(&x->x_obj, &x->density); 	//writes  the input data from 
  floatinlet_new(&x->x_obj, &x->transient);
  floatinlet_new(&x->x_obj, &x->randomness);
  floatinlet_new(&x->x_obj, &x->GrainShapeIn);

  int i;
  x->GrainChannels =1;
    x->GrainTime=4410; //nominal length in samples    

  
  for (i=0; i<MAX_GRAINS; i++){
    x->GrainLength[i]=0;
    x->TransientLength[i]=0;
    x->WaitLength[i]=0;
    x->SteadyLength[i]=0;
    x->increment[i]=0.0;
    x->counter[i]=0;
    x->ramp[i]=0.0;
  }

  
  //Variables to be modified with outlets
  t_float randomness=0;
  t_float density=0.5;
  t_float transient=0.5;
  //calculated variables
  t_float increment[MAX_GRAINS];
  t_int counter[MAX_GRAINS];
  t_float ramp[MAX_GRAINS];
   
  x->GrainShape=0; //0- Gauss, 1-linear, 2-pow 2, 3-linear
  
  t_float *RandomTable, *GaussTable;
  x->GrainShape=0;
  x-> x_out = outlet_new(&x->x_obj, &s_signal);//selector "signal"
  
  //Initialize variables 
 
  x->GaussTable=GaussFunction(SAMPLES+1);
  x->RandomTable=InitializeRandom(RAND_SEQ+1);
  
  for (i=0; i<MAX_GRAINS; i++) {
   CalculateNextGrain(x, i);
  }
  return (void *)x;
  f++;
}

/***************************SETUP***************************/
void granulatorMult_tilde_setup(void) {
  granulatorMult_tilde_class=class_new	//Create the new class
    (gensym("granulatorMult~"),		//symbolic name of the class
    (t_newmethod)granulatorMult_tilde_new,//constructor (called when PD 
	  //instantiates a new object)
    (t_method)granulatorMult_tilde_free, //destructor (needed to free 
	//resources)
    sizeof(t_granulatorMult_tilde),	//logic space of the object
    CLASS_DEFAULT, 		//graphical representation of the object
    A_DEFFLOAT, 		//float input
    0); 			//0 indicate the ending of the list of 
//arguments
	
    class_addmethod(		//new method 
      granulatorMult_tilde_class, 	//belonging class
      (t_method)granulatorMult_tilde_dsp,//defines the method
      gensym("dsp"),		//defining the method for dsp (1)
      0); 			//adding the method reset
	
  class_addmethod(		//new method 
    granulatorMult_tilde_class, 	//belonging class
    (t_method)GrainTime,//defines the method
    gensym("GrainTime"),		//defining the method for dsp (1)
    A_DEFFLOAT,
    0); 
   class_addmethod(		//new method 
    granulatorMult_tilde_class, 	//belonging class
    (t_method)GrainChannels,//defines the method
    gensym("channels"),		//defining the method for dsp (1)
    A_DEFFLOAT,
    0); 
	
class_addfloat(granulatorMult_tilde_class, GrainTime);
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

float Random(t_granulatorMult_tilde *x) {
  float* table;
  float output;
  int offset;
  table = x-> RandomTable;
  offset=rand()%RAND_SEQ;
  output= *(table + offset);
  return output;
}