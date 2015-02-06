/**************************pipe EXTERNAL*********************************
This external implements a simple communication external involving a pipe 
between PD and another executable

INPUTS:
	1 - Signal input to be multiplied by the envelope
***********************************************************************/
#include "m_pd.h" 
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
/***************************CLASS DECLARATION***************************/

static t_class *pipe_read_tilde_class; //create pipe_tilde_class
const char *path = "/home/enoc/projecte/son2";

/***************************DATA SPACE***************************/
//variables of the class
typedef struct _pipe_read_tilde {
	t_object x_obj; //object properties for PD environment
	t_sample f; //t_sample type is an audio signal value (floating point)
	t_outlet *out; //pointer to an output
	//t_int fdRead, fdWrite;
	
	t_float buffer;
	
	t_int fd1;
	int PID;
} 
t_pipe_read_tilde;

/***************************METHODS***************************/
t_int *pipe_read_tilde_perform(t_int *w) {
/*The perform routine contains the functionality of the external*/

	t_pipe_read_tilde *x = (t_pipe_read_tilde *)(w[1]); //the first 
//argument is the object
	t_sample *in1 = (t_sample *)(w[2]); 	//cast to the first signal inlet
	//int n= (int)(w[3]); 	    		//cast to the length of the signal vector
	t_float buffer;
	buffer = *in1;
	
	
	if (read(x->fd1, &buffer, sizeof(float))<0) //last_value = data;
	
	outlet_float(x->out, buffer); //send the counter level
	return (w+4); //return the next memory position
}

/*The pipe_tilde_dsp method adds a perform-routine to the DSP-tree.*/
void pipe_read_tilde_dsp(
	t_pipe_read_tilde *x, //pointer to the class data space
	t_signal **sp) { //pointer to the sp array (1)

	dsp_add(
		pipe_read_tilde_perform,//performing routine
		3,		//number of the following pointers to variables passed
				//to the pipe_tilde_perform routine
		x,		//pointer to the data space 
		sp[0]->s_vec, 	//first in-signal (2)
		sp[0]->s_n);	//pointer to the length of the signal (3)

}

/*------------------------SP, S_VEC AND S_N----------------------------
1- SP:The vector sp is an array of signals containing pointers to each 
signal in object. The signals are read in the graphical representation 
clockwisely. Each signal sp[n] has a pointer ().s_vec (array of t_samples)
and the length of this signal-vector ().s_n

2-S_VEC: pointer to the signal vector (array of sample of type t_sample)

3-S_N: length of the signal vector
---------------------------------------------------------------*/

/***************************DESTRUCTOR***************************/
void pipe_read_tilde_free(t_pipe_read_tilde *x) {

	outlet_free(x->out); //free the output x_out*/
}

/*As the first inlet is generated automatically it is also freed automatically, so
no inlet_free is needed*/

/***************************CONSTRUCTOR***************************/

void *pipe_read_tilde_new()  {
  int fd[2], PID=34, newPID, ret, readbuffer=0;
  //Initialization of all variables
  //opening the pipe
  ret=pipe(fd);
  if(ret<0) printf("error when piping\n");
  
  //fork 
  PID=getpid();
  if (fork()<0 ) perror("error while forking\n");
  
  else {
  newPID=getpid();
  }
  
  if (newPID!=PID) {//son to be mutated
      printf("channel sent: %d\n", fd[0]);
      close(fd[1]);//closing writing end
      ret=execl(path, path, &fd[0], (void *)NULL);
      printf("This is not supposed to happen\n");
      exit (-1);
  }
  close(fd[0]); //closing reading end
  //father
  
  //PD initialization
  t_pipe_read_tilde *x = //pointer *x to a t_pipe_tilde object
  (t_pipe_read_tilde *) pd_new(pipe_read_tilde_class); 	// creates (casts) a new 
//pointer to a t_pipe_tilde
  t_outlet *x_out; //pointer to an output
  x->out = outlet_new( &x->x_obj, //pointer to the internal object
  &s_float);//selector "float"
  
  post("PID %d, new PID %d", PID, newPID);
  x-> fd1=fd[1];
  //x->fd0=fd[0];

  /*int i;
  for (i=0; i<10; i++) {
    write(fd[1], &i, sizeof(int));
  }
  //post("data received %d", readbuffer);
  sleep(1);*/
  return (void *)x;
  
  
}
/*------------------------------------INLET GENERATION--------------------------------------------------
1- active means that a class method is called each time a message is sent to an active inlet. The first
inlet is always active. 
2- the selector defined with the third argument is to be substituted with the fourth argument selector.
Because of this substitution of selectors a message on a certain right inlet (a float variable in this case) 
can be treated as a message with a certain selector on the leftmost inlet. This means:
	* The substituting selector has to be declared by class_method in the setup-routine
	* It is possible to simulate a certain right inlet, by sending a message with this inlet's selector
	  to the leftmost inlet
	* It is not possible to add methods for more than one selector to a right inlet. Particularly it is
	  not possible to add a universal method for arbitrary selectors to a right inlet.
3 - Passive inlets allow parts of the data space-memory to be written directly from the outside. 
--------------------------------------------------------------------------------------------------*/

/***************************SETUP***************************/
void pipe_read_tilde_setup(void) {
	pipe_read_tilde_class=class_new	//Create the new class
		(gensym("pipe_read~"),		//symbolic name of the class
		(t_newmethod)pipe_read_tilde_new,//constructor (called when PD 
//instantiates a new object)
		(t_method)pipe_read_tilde_free, //destructor (needed to free the 
//resources)
		sizeof(t_pipe_read_tilde),	//logic space of the object
		CLASS_DEFAULT, 		//graphical representation of the object		
		0); 			//0 indicate the ending of the list of arguments
	
	class_addmethod(		//new method 
		pipe_read_tilde_class, 	//belonging class
		(t_method)pipe_read_tilde_dsp,//defines the method
		gensym("dsp"),		//defining the method for dsp (1)
		0); 	
//add class for key_pressed and key release

	CLASS_MAINSIGNALIN(	//(2)
		pipe_read_tilde_class,//pointer to the signal class
		t_pipe_read_tilde, 	//pointer to the class' data space
		f);		//(3)this is a dummy-variable out of the data space
				
//class_sethelpsymbol(pipe_tilde_class, gensym("help-pipe_tilde")); //help location for the pipe_tilde class
}
/*----------------------DSP INITIALIZATION------------------------------------------------
 1- When PD audio generator is started a message with the selector "dsp" is sent to 
    each object. Each class that has a method for the dsp message is recognized as a
    signal class. 
 2- signal classes that want to provide signal-inlets have to declare this via the 
    CLASS_MAINSIGNALIN macro. This enables signals at the first (default) inlet. If 
    more than one signal-inlet is needed, they have to be created explicitly in the
    constructor method. Inlets that are declared as signal-inlets cannot provide methods
    for float messages any longer.
 3- The last argument of CLASS_MAINSIGNALIN is a dummy variable out of the data space that
    is needed to replace non-existing signal at the signal-inlet(s) with t_float messages
-----------------------------------------------------------------------------------------*/
