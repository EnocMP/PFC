#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<fcntl.h>

//the father process writes random numbers into the pipe
//fd[0] = input side
//fd[1] = output side

const char *path = "/home/enoc/projecte/Background_Pipe/output";

void main (int argc, char *argv[] ) {
  
  printf("\n\n***********Com Test Module*************\n\n");
  
  int fatherPID, newPID, i, data, buffer, ret;
  int arg=(int)*argv[1];
  int PD;//Pd pipe channel
  printf("Channel received %d\n", arg);
  
  /****Test Pipe******/
  printf("\n*****Pipe Test*******\n");
  data=123;
  ret=write(arg, &data, sizeof(int));
  if(ret<0) printf("Error %d when writing\n", ret);
  else printf("Write to pipe succesful\n");
  printf("\n\n");
  /*******************/
  
  
  PD=arg;
  
  
  int BgsFd[2];
  buffer = 99;
  //pipe
  /*ret=pipe2(BgsFd, O_NONBLOCK);
  //ret=  pipe(BgsFd);
  if(ret<0) printf("Error fent la pipe\n");
  else printf("Retorn de la pipe %d\n", ret);*/
  //creating fork
  fatherPID=getpid();
  /*if (fork()<0) {
   printf("Fork error");
  }*/
  if(fatherPID==getpid()) {
    printf("Sent channel %d\n", BgsFd[0]);
    printf("Reading channel%d\n", BgsFd[1]);
    while(1){
     for(i=0; i<30;i++){
	ret=read(BgsFd[0], &data, sizeof(int));
	if(ret>0){
	  printf("Received %d bytes, data received %d\n", ret, data);
	  ret=write(PD, &data, sizeof(int));
	  if(ret<4) printf("PD pipe writing error");
	}
      }
    }
  }
   
  else{
   //son 
     if(execl(path, path, &BgsFd[1], (void *)NULL)<0) {
      printf("Error while execl\n");
      exit(-1);
    }
  }
}
