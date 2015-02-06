#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <math.h>

#define BUFFER_LENGTH 20
#define PI 3.141592654
#define e 2.71828183

float function(int index, int samples);
//const char *coma = ", ";

int main(int argc,char *aa[]){
  int fd,fd1;
  int i,j=0, k, n;
  float value;


  if(argc!=3){
    printf("Usage : ./<program> <outputfile> <number of samples> \n");
    return -1;
  }
  fd1=open(aa[1],O_CREAT|O_RDWR, 0666);
  if(fd1==-1){
    printf("file creation error, exiting\n");
  }
  
   int samples=atoi(aa[2]);

  //Initializing the variables

  char a='a', b='b', new_line='\n', coma=',', tab='\t';
  char buffer[BUFFER_LENGTH];
  for (i=0; i<samples; i++) {
    buffer[i]= 0; 
  }
  for(i=0; i<samples;i++){
    n=0;

    if(i>0) {
      n+=write(fd1, &coma,1); // escribim coma
      if(j==7){ //cada 0 línies introduïm un salt de línia
	write(fd1, &new_line, 1);
	j=0;
      }
      else { 
	n+=write(fd1, &tab, 1);
      }
    }   
    
   /*mathematical function*/
    value=function(i, samples);
    sprintf(buffer, "%f", value);
    for(k=0; k<BUFFER_LENGTH; k++){
      if(buffer[k]!=0) { n+=write(fd1, &buffer[k],1); }
    }
    //printf("ha escrit %d bytes\n", n);
   j++;

  }
  write(fd1, &new_line, 1);
  close(fd1);
  exit(0);
}
float function(int index, int samples){

  /************************************
   * Gaussian function
   *
   * 		  -(x-b)²
   * f(x)= A·exp(_________)	
   * 		    2c²
   *
   ************************************/
  double result, exponent;
  double x, a=1, b=1, c=0.2;
  double num, den;
  x=(double)index/samples;
  num=x-b;
  num= - pow(num, 2);
  den = 2*pow(c,2);
  exponent=num/den;
  result=a*pow(e, exponent);  
  return (float)result;
}
