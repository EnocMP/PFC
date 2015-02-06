/**************************adsr EXTERNAL*********************************
This external implements an ADSR envelope. Attack, decay, sustain, release and 
slope are inputs, while the generated envelope is the only output. It has no 
signal inlets. There is also a "On/Off" inlet, when it is turned to 0 this 
external will always outupt "1".

There are methods for start and stop envelope (to start the attack or the 
release phase). To start or stop the envelope a selector "start" or "stop" 
should be sent to the first inlet.

INPUTS:
  1-"Start" and "Stop" selectors
  2- Attack (ms)
  3- Decay (ms)
  4- sustain (0 to 1)
  5- Release (ms)
  6- Slope
  7- On/Off
 
 OUTLET:
  1- Envelope (signal)
  
  
***********************************************************************/

#include "m_pd.h"
#include <math.h>
#include <stdio.h>

/***************************CLASS DECLARATION***************************/
static t_class *adsr_tilde_class; //create adsr_tilde_class
typedef struct _adsr_tilde {
  t_object x_obj; //object properties for PD environment	  
  
  //values from the inlets
  t_float AttackTime, DecayTime, sustain,ReleaseTime,slope;
  //values to increase/decrease the accumulator
  t_float attack, release,decay;
  
  t_sample accumulator, envelope, AttackOffset;
  t_int state; 	//This variable contains the state of the adsr
    // 0 - non-active (waiting for a key)
    // 1 - attack
    // 2 - decay
    // 3 - sustain
    // 4 - release
   t_float On;
   t_float SampleRate; //PD sample rate
   t_float kd, kr, ka; //constants to multiply the ramp during decay and release
   
  //inlets and outlets
  t_inlet *in2; //pointer to an inlet
  t_inlet *in3; //pointer to an inlet
  t_inlet *in4; //pointer to an inlet
  t_inlet *in5; //pointer to an inlet
  t_inlet *in6; //pointer to an inlet
  t_inlet *in7; //pointer to an inlet

  t_outlet *out; //pointer to an output
  
} 
t_adsr_tilde;

/***************************METHODS***************************/

//-------------------START-----------------------//
void adsr_tilde_Start (t_adsr_tilde *x) {

  x->attack = 1000/(x->AttackTime*x->SampleRate);//peak level always 1
  x->decay = 1000/(x->DecayTime*x->SampleRate);  
  x->state = 1;//start the adsr
  x->accumulator=0.0;
  x->ka=1-x->envelope;
  x->kd=1-x->sustain;//constant to adjust the accumulator value to the desired 
		     //levels during the decay
  x->AttackOffset=x->envelope;
}

//-------------------STOP-----------------------//
void adsr_tilde_Stop (t_adsr_tilde *x) {
  x-> state = 4;//start the adsr
  x-> release = 1000/(x->ReleaseTime*x->SampleRate); // release time
  x->accumulator=1;
  x->kr=x->envelope; //constant to adjust the accumulator value to the desired 
		     //levels during the release

}

//-------------------PERFORM-----------------------//
t_int *adsr_tilde_perform(t_int *w) {
  t_adsr_tilde *x = (t_adsr_tilde *)(w[1]); //the first argument is the object
  t_sample *out = (t_sample *)(w[2]); 	//cast to the first output
  int n= (int)(w[3]); 	    		//cast to the length of the
  
  t_sample envelope=x->envelope;

  t_sample accumulator = x->accumulator;
  
  while(n--){
      if (x->On>0){
      switch(x->state) {
	case 1: //attack
	  accumulator+=x->attack;
	  if(accumulator>=1){
	    accumulator = 1;
	    x->state++;
	  }
	  envelope=pow(accumulator, x->slope)*x->ka+x->AttackOffset;
	  break;
	  
	case 2: //decay
	  accumulator-=x->decay;
	  if(accumulator<=0){
	    accumulator = 0;
	    x->state++;
	  }
	  envelope=pow(accumulator,x->slope)*x->kd+x->sustain;
	  break;
	  
	case 3: //sustain
	  envelope=x->sustain;
	  break;
	  
	case 4: //release
	  accumulator-=x->release;
	  if(accumulator<=0) {
	    x->state =0; 
	  }
	  envelope=pow(accumulator,x->slope)*x->kr;
	  break;
	  
	default:
	  envelope=0;
	  break;
      }
       *out++ = envelope;
     }
     else{
       *out++=1.0;
       envelope=0;
     }
   }
  x->accumulator=accumulator;
  x->envelope=envelope;
  return(w+4);
}

/*The adsr_tilde_dsp method adds a perform-routine to the DSP-tree.*/
void adsr_tilde_dsp( t_adsr_tilde *x, t_signal **sp) { 

  dsp_add(
    adsr_tilde_perform,//performing routine
    3,	//number of pointers to variables passed to perform routine
    x,	//pointer to the data space 
    sp[0]->s_vec, //out-signal
    sp[0]->s_n); //pointer to the length of the signal (samples)
    
    x->SampleRate = sp[0]->s_sr; //getting the sample rate
}


/***************************DESTRUCTOR***************************/
void adsr_tilde_free(t_adsr_tilde *x) {
	inlet_free(x->in2); //free the inlet x_in2
	inlet_free(x->in3); //free the inlet x_in2
	inlet_free(x->in4); //free the inlet x_in2
	inlet_free(x->in5); //free the inlet x_in2
	inlet_free(x->in6); //free the inlet x_in2
	inlet_free(x->in7); //free the inlet x_in2

	outlet_free(x->out); //free the output x_out*/

}

/***************************CONSTRUCTOR***************************/
void *adsr_tilde_new()  {
  t_adsr_tilde *x =(t_adsr_tilde *) pd_new(adsr_tilde_class);
  //Initialize variables
  x->state=0;
  x->envelope=0.0;
  x->AttackTime=10;
  x->DecayTime=10;
  x->sustain=1;
  x->ReleaseTime=10;
  x->slope=1;
  
  x->accumulator=0.0;
  x->On=1;
 
  //generating inlets
  x->in2 =floatinlet_new(&x->x_obj, &x-> AttackTime);
  x->in3 =floatinlet_new(&x->x_obj, &x->DecayTime);
  x->in4 =floatinlet_new(&x->x_obj, &x->sustain); 
  x->in5 =floatinlet_new(&x->x_obj, &x->ReleaseTime); 
  x->in6 =floatinlet_new(&x->x_obj, &x->slope);
  x->in7 =floatinlet_new(&x->x_obj, &x->On);

  //generating output
  x->out = outlet_new(&x->x_obj, &s_signal);
  return (void *)x;
}



/***************************SETUP***************************/
void adsr_tilde_setup(void) {
	adsr_tilde_class=class_new	//Create the new class
	  (gensym("adsr~"),		//symbolic name of the class
	  (t_newmethod)adsr_tilde_new,//constructor (called when PD 
// instantiates a new object)
	  (t_method)adsr_tilde_free, //destructor (needed to free the 
// resources)
	  sizeof(t_adsr_tilde),	//logic space of the object
	  CLASS_DEFAULT, 	//graphical representation of the object	
  	  0); 			//0 indicate the ending of the list of 
// arguments
  
  class_addmethod(		//new method 
	  adsr_tilde_class, 	//belonging class
	  (t_method)adsr_tilde_dsp,//defines the method
	  gensym("dsp"),		//defining the method for dsp (1)
	  0); 	
  
  class_addmethod(		//new method 
	  adsr_tilde_class, 	//belonging class
	  (t_method)adsr_tilde_Start,//defines the method
	  gensym("start"),//defining the method for dsp (1)
	  0);
  
  class_addmethod(		//new method 
	  adsr_tilde_class, 	//belonging class
	  (t_method)adsr_tilde_Stop,//defines the method
	  gensym("stop"),//defining the method for dsp (1)
	  0);
			
}
