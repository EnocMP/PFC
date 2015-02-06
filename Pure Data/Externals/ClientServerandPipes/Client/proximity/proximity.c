#include "m_pd.h"
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/types.h>
#include<sys/wait.h>

#define PIPE 1
#define BANG 1
#define _GNU_SOURCE   /* See feature_test_macros(7) */

/*Pipe2 usage:
 * pipe2(fd, NON_BLOCK);
 * fd[1] write end, fd[0] read end*/

/***************************CLASS DECLARATION***************************/

static t_class *proximity_class; //create proximity class
const char *path = "/home/enoc/projecte/Background_Pipe/ComTest";
//const char *path = "/home/enoc/projecte/BGS_Impl1/output";

/***************************DATA SPACE***************************/
//variables of the class
typedef struct _proximity {
	t_object x_obj; //object properties for PD environment
	t_int channel; // pipe file descriptor
	t_int buffer;
	t_int pixels;
	t_outlet *out;
} 
t_proximity;


/***************************METHODS***************************/
void proximity_bang (t_proximity *x) {
  int buffer=99, value=99, ret=99, channel;
  post("            BANG");
#if BANG
  channel=x->channel;
  ret=read(channel, &buffer, sizeof(int));
  if (ret<0){
    post("error PIPE, ret %d", ret);
  }
  else if(ret==0){
    post("Bang, empty pipe", ret, buffer);
  }
  else{
    value=buffer;
    outlet_float(x->out, value);
    post("Bang, read %d bytes, value %d", ret, buffer);
  }
#endif
}

/***************************CONSTRUCTOR***************************/

void *proximity_new(t_symbol *s, int argc, t_atom *argv) {
  
  int ret, PID, newPID, fd[2], dataIn, dataOut, arg;
  
#if PIPE 
  //if pipe>0 execute fork, exec and pipe
  ret=pipe2(fd, O_NONBLOCK);
  if(ret<0) post("error when piping, ret %d", ret);
  else post("Pipe creation retunred %d, fd[0]=%d, fd[1]=%d",ret, fd[0], fd[1]);
#endif 
  //fork 
  PID=getpid();
  if (fork()<0 ) perror("error while forking\n");
  
  else {
  newPID=getpid();
  }
  
  if (newPID!=PID) {//son to be mutated
      printf("channel sent: %d\n", fd[1]);
      //close(fd[1]);//closing writing end
      arg=fd[1];
      ret=execl(path, path, &arg, (void *)NULL);
      printf("Mod Communication Exec Error\n");
      exit (-1);
  }
  else {
   if(read(fd[0], &buffer, sizeof(int)) >0 ) post("test int read %d",buffer);
  }
  
  /********PD INITIALIZATION**********/
  t_proximity *x = (t_proximity *)pd_new(proximity_class); 	

  x->out = 		//object outlet field f_out
	  outlet_new(	//creates a new outlet and returns a pointeR
	  &x-> x_obj,	//pointer to the internal object
	  &s_float);	//defines the output data type
  x-> channel=fd[0];

	return (void *)x;
}




/***************************SETUP***************************/

void proximity_setup(void) {
	proximity_class=class_new	//Create the new class
		(gensym("proximity"),	//symbolic name of the class
		(t_newmethod)proximity_new,//constructor (called when PD 
					   //instantiates a new object)
		0,			//destructor(never in this case)
		sizeof(t_proximity),	//logic space of the object
		CLASS_DEFAULT, 		//graphical representation of the object
		0,
		0); 			//0 indicate the ending of the list

	class_addbang(		//new method 
		proximity_class, 	//belonging class
		proximity_bang); 	//adding the bang method


	//class_sethelpsymbol(proximity_class, gensym("help-proximity")); 
//help location for the proximity class
}

