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

  int fatherPID, newPID, i, data, buffer, ret;
  int fd[2];
  buffer = 99;
  
  ret=pipe2(fd, O_NONBLOCK);
  
  if(ret<0) printf("Error fent la pipe\n");
  else printf("Retorn de la pipe %d\n", ret);
  
  //creating fork
  fatherPID=getpid();
  if (fork()<0) {
   printf("Fork error");
  }
  if(fatherPID==getpid()) {
    printf("Sent channel %d\n", fd[0]);
    printf("Reading channel%d\n", fd[1]);
    sleep(3);
    while(1){
     for(i=0; i<30;i++){
	ret=read(fd[0], &data, sizeof(int));
	if(ret>0){
	  printf("Received %d bytes, data received %d\n", ret, data);
	}
	else{
	  printf("Nothing to read, returned %d\n", ret);
	}
	sleep(1);
      }
    }
  }
   
  else{
      for(i=0;i<10;i++) {
	ret=write(fd[1], &i, sizeof(int));
	printf("		write returned %d\n", ret);
	sleep(1);
      }
  }
  
}
