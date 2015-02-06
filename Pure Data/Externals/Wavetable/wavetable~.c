/**************************WAVETABLE EXTERNAL**************************
This external implements a wavetable oscillator. It generates an output with
the selected frequnecy, phase and waveform. It also has feedback control, to 
distort the signal. With the Activate inlet it is possible to disable the
oscillator (the output will be always 0.0).

Inlets:
1- Reference ramp
2- Phase
3- Feedback
4- Waveform
5- Activate/Desactivate

The first inlet should be a reference ramp with the desired frequency
***********************************************************************/
#include "m_pd.h"
//#include "waves.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#define FS 44100
#define SAMPLES 65535
#define PI 3.141592654
#define e 2.71828183

float* SineFunction(int samples);
float* GaussFunction(int samples);
float* WhiteNoiseFunction(int samples);



/***************************CLASS DECLARATION***************************/
static t_class *wavetable_tilde_class; //create wavetable_tilde_class

/***************************DATA SPACE***************************/
//variables of the class
typedef struct _wavetable_tilde {
	t_object x_obj; //object properties for PD environment
	t_sample f_wavetable; 
	t_sample LastValue;
	
	//Pointers to the waveform tables
	t_float* SineTable;
	t_float* GaussTable;
	t_float* WhiteNoiseTable;

	t_float feedback;
	t_float phase;
	t_float waveform;
	t_int activate;
	
	//Activate
	t_int ON;
	t_sample f;
	t_outlet *x_out; //pointer to an output
} 
t_wavetable_tilde;

/***************************METHODS***************************/

/*The perform routine contains the functionality of the external*/
t_int *wavetable_tilde_perform(t_int *w) {
  t_wavetable_tilde *x = (t_wavetable_tilde *)(w[1]); //the first 

    t_sample *freq = (t_sample *)(w[2]);//cast to the first signal inlet
    t_sample *out = (t_sample *)(w[3]); //cast to the first output
    int n=(int)(w[4]); 	    		//cast to the length of the 
  
    t_float ramp;
    t_sample output;
    float *Sine, *Gauss, *WhiteNoise;
    Sine = x->SineTable;
    Gauss = x->GaussTable;
    WhiteNoise = x->WhiteNoiseTable;
    int index;
    /*------------------WAVEFORMS------------------*/
    while (n--) {
     if(x->activate) {
      ramp = *freq++;
      ramp +=x->phase;	
      
      if (x->feedback>0.01) {
	ramp+= x->LastValue*x->feedback;
      }
      while(ramp>1.0) ramp-=1.0;
      while(ramp<0) ramp +=1.0;   
      
      index = (int)((float)(SAMPLES)*ramp);
      if(x->waveform<1){//-----------------------------------SINE
      index=index*4;
	if (index<SAMPLES) { //1r quadrant
	  output=*(Sine+index);
	}
	else if (index < 2*SAMPLES) { //2n quadrant
	  index=2*SAMPLES-index;
	  output=*(Sine+index);
	}
	else if (index < 3*SAMPLES) { //3r quadrant
	  index= index-2*SAMPLES;
	  output=*(Sine+index)*(-1);
	}
	else if(index>3*SAMPLES) { //4t quadrant
	  index=(4*SAMPLES-index);
	  output=*(Sine+index)*(-1);
	}    }
      
      else if(x->waveform<2){ //-------------------------TRIANGLE
	if(ramp<0.25) output=ramp*4;
	else if(ramp<0.75) output = 2-ramp*4;
	else output = ramp*4-4;
      }
      
      else if (x->waveform<3){//---------------------------SQUARE
	if (ramp<0.5) output = -1.0;
	else output= 1.0;
      }
      
      else if (x->waveform<4){ //------------------------SAWTOOTH
	output=2*ramp-1;
      } 
      else if (x->waveform<5){//-------------------------GAUSSIAN
	index=index*4;
	if (index<SAMPLES) {//1r quadrant
	  output=*(Gauss+index);
	}
	else if (index < 2*SAMPLES) { //2n quadrant
	  index=2*SAMPLES-index;
	  output=*(Gauss+index);
	}    
	else if (index < 3*SAMPLES) { //3r quadrant
	  index= index-2*SAMPLES;
	  output=*(Gauss+index)*(-1);
	}
	else if(index>3*SAMPLES) { //4t quadrant
	  index=(4*SAMPLES-index);
	  output=*(Gauss+index)*(-1);
	}      
      }
      else if (x->waveform<6){//----------------------WHITE NOISE
	
	output=*(WhiteNoise+(rand()% SAMPLES));
      }
     }
     else{
       output=0.0;
     }
      *out++ = output;
      x->LastValue=output;
    }
    return(w+5);
}

/*The wavetable_tilde_dsp method adds a perform-routine to the DSP-tree.*/
void wavetable_tilde_dsp(
	t_wavetable_tilde *x, //pointer to the class data space
	t_signal **sp) { //pointer to the sp array (1)

	dsp_add(
		wavetable_tilde_perform,//performing routine
		4,		//number of the following pointers to variables 
//passed
				//to the wavetable_tilde_perform routine
		x,		//pointer to the data space 
		sp[0]->s_vec, 	//first in-signal (2)
		sp[1]->s_vec, 	//out-signal
		sp[0]->s_n);	//pointer to the length of the signal (3)
}
/***************************DESTRUCTOR***************************/
void wavetable_tilde_free(t_wavetable_tilde *x) {
	outlet_free(x->x_out); //free the output x_out
	free(x->SineTable);
}
/*As the first inlet is generated automatically it is also freed automatically, 
so no inlet_free is needed*/

/***************************CONSTRUCTOR***************************/
void *wavetable_tilde_new(   //Constructor function
	t_floatarg f) {  //float argument
	
	t_wavetable_tilde *x = //pointer *x to a t_wavetable_tilde object
		(t_wavetable_tilde *) pd_new(wavetable_tilde_class); 	// 
//(casts) a new pointer to a t_wavetable_tilde
		
  floatinlet_new(&x->x_obj, &x->phase);
  floatinlet_new(&x->x_obj, &x->feedback); 	//writes  the input data from 
  floatinlet_new(&x->x_obj, &x->waveform);
  floatinlet_new(&x->x_obj, &x->activate);
  x->phase=0;
  x->feedback=0.0;
  x->waveform=0;
  x->activate=1.0;
  x->LastValue=0.0;
  f++; //avoid warning, f needed to be there, but not used

  //Initialize all the tables
  x->SineTable=SineFunction(SAMPLES+1);
  x->GaussTable=GaussFunction(SAMPLES+1);
  x->WhiteNoiseTable=WhiteNoiseFunction(SAMPLES+1);
  x-> x_out = outlet_new( &x->x_obj, &s_signal);
  return (void *)x;
}

/***************************SETUP***************************/
void wavetable_tilde_setup(void) {
	wavetable_tilde_class=class_new	//Create the new class
		(gensym("wavetable~"),		//symbolic name of the class
		(t_newmethod)wavetable_tilde_new,//constructor (called when PD 
//instantiates a new object)
		(t_method)wavetable_tilde_free, //destructor (needed to free 

//resources)
		sizeof(t_wavetable_tilde),	//logic space of the object
		CLASS_DEFAULT, 		//graphical representation of the object
		A_DEFFLOAT, 		//float input
		0); 			//0 indicate the ending of the list of 
//arguments
	
	class_addmethod(		//new method 
		wavetable_tilde_class, 	//belonging class
		(t_method)wavetable_tilde_dsp,//defines the method
		gensym("dsp"),		//defining the method for dsp (1)
		0); 			//adding the method reset

	CLASS_MAINSIGNALIN(	//(2)
		wavetable_tilde_class,//pointer to the signal class
		t_wavetable_tilde, 	//pointer to the class's data space
		f);		//(3)this is a dummy-variable out of the data 
//space
				
//class_sethelpsymbol(wavetable_tilde_class, gensym("help-wavetable_tilde")); 
//help 
//location for the wavetable_tilde class
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
   *
   ************************************/
  double exponent;
  double x, a=1, b=1, c=0.3;
  double num, den;
   
  
  //Calculates and fills the Gauss SineTable
  for (index=0; index<samples; index++) {
    x=(double)index/samples;
    num=x-b;
    num= - pow(num, 2);
    den = 2*pow(c,2);
    exponent=num/den;
    GaussTable[index]=a*pow(e, exponent);
  }
   //allocate the table into memory
  float *pointer;
  pointer = malloc(samples*sizeof(float));
  memcpy(pointer, GaussTable, samples*sizeof(float));
  return pointer;
  
  } 
float* SineFunction(int samples){
 int index=0;
 float SineTable[samples], x;
 /****Sine Fucntion**********
  *     f(x)=sin(2·pi·x), x->
  * **************************/
  for (index=0; index<samples; index++) {
    x=(double)index/(4*samples); // 0 < x < 0.25, only 1/4 of a sine is required
    SineTable[index]=sin(2*PI*x);
  }
  //allocate the table into memory
  
 float *pointer;
  pointer = malloc(samples*sizeof(float));
  memcpy(pointer, SineTable, samples*sizeof(float));
  return pointer;
  } 
  
float* WhiteNoiseFunction(int samples){
 int index=0;
 float WhiteNoiseTable[samples];

 
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
  return pointer;
  } 
  
