#include "m_pd.h"
  
  
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

//const char *path = "/home/enoc/projecte/Bck/ComTest";
const char *path = "/home/enoc/projecte/Bck/a";

/***************************CLASS DECLARATION***************************/

static t_class *ComPipe_class; //create ComPipe class

/***************************DATA SPACE***************************/
//variables of the class
typedef struct _ComPipe {
	t_object x_obj; //object properties for PD environment
	t_float fd;	//channel to read
	t_outlet *f_out; //output
} 
t_ComPipe;


/***************************METHODS***************************/
void ComPipe_bang (t_ComPipe *x) {
	//post("Bang received");
	
	int channel, data, ret;
	channel=x->fd;
	post("Channel %d", channel);
	
	
	//ret=read(channel, &data, sizeof(int));
	if (ret<0) post("Nothing to read or error!");
	else outlet_float(x->f_out, data); //send the ComPipe level
	
}

/***************************CONSTRUCTOR***************************/

void *ComPipe_new(t_symbol *s, int argc, t_atom *argv) {
  
  
  
  /****Fork and Pipe*********/
  int ret, fd[2], data, buffer, PID, PPID;

/*
  printf("\n********Creating Pipe\n");
  //Pipe
  ret=pipe2(fd, O_NONBLOCK);
  if(ret<0) printf("Error %d creating Pipe\n", ret);
  else {
    printf("Pipe succesfull creation, returned %d\n", ret);
    printf("channels retunred fd[0]=%d, fd[1]=%d\n", fd[0], fd[1]);
  }
*/

  //Fork
  PPID=getpid();
  if (fork()<0) printf("Error while executing fork, ret %d\n", ret);
  
  PID=getpid();
  
  if(PID==PPID) { //Father 
    sleep(1);
   // ret=read(fd[0], &buffer, sizeof(int));
   // if(ret<0) printf("Error reading Pipe\n");
   // else printf("Read %d \n", buffer);
    
    
  }
  else { //Son
    data=123;
   // ret=write(fd[1], &data, sizeof(int));
    //if(ret<0) printf("		son, error writing\n");
     
    //Exec, change the code
    
    ret=execl(path, path, &fd[1], (void *)NULL);
    printf("Mod Communication Exec Error\n");
   
    //printf("		son, dying\n");
    exit(0);    
  }
  

  
  
  t_ComPipe *x = (t_ComPipe *)pd_new(ComPipe_class);
  x->fd=fd[0];
  x->f_out =  outlet_new(&x-> x_obj, &s_float);
  return (void *)x;
}

/***************************SETUP***************************/

void ComPipe_setup(void) {
	ComPipe_class=class_new	//Create the new class
		(gensym("ComPipe"),	//symbolic name of the class
		(t_newmethod)ComPipe_new,//constructor (called when PD 
		0,			//destructor(never in this case)
		sizeof(t_ComPipe),	//logic space of the object
		CLASS_DEFAULT, 		//graphical representation of the object
		0, 		//Variable number of inputs
		0); 			//0 indicate the ending of the list 

	class_addbang(		//new method 
		ComPipe_class, 	//belonging class
		ComPipe_bang); 	//adding the bang method


	//class_sethelpsymbol(ComPipe_class, gensym("help-ComPipe")); //help 
}

