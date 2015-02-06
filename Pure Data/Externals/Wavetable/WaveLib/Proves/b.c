#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

//#include "waves.h"

#define FS 44100
#define SAMPLES 2147483647 //s^31 -1 
#define PI 3.14159

float* SineFunction();

void main(){
    float *point, value;
    point=SineFunction();
    int i;
    for (i=0; i<10; i++){
     printf("SineVec %d = %f\n", i, *(point+i)); 
    }
    
    //printf("point %d, *point %d\n", point, *point)  
}

float* SineFunction(){
  float SineVector[10]={1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0};
  float *pointer;
  pointer = malloc(10*sizeof(float));
  /*for(i=0; i<10; i++){
   *(pointer+i)=SineVector[i];
  }*/
  memcpy(pointer, SineVector, 10*sizeof(float));
  //realloc(pointer, 10*sizeof(float));
 
  return pointer;
}
/*
void main(){
    int *point, value;
    printf("size of float: %d\n\n", sizeof(float));
    point=SineFunction();
    printf("	value 1: %d\n", *point);
    printf("	value 2: %d\n", *(point+1));
    printf("	value 3: %d,\n", *(point+2));
    int i;
    
    //printf("point %d, *point %d\n", point, *point)  
}

int* SineFunction(){
  float SineVector[10]={1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0};
  int  i, value[3]={48, 49, 50};
  int *pointer;
  //pointer = (int *) malloc(10*sizeof(float));
  
  
  pointer = malloc(3*sizeof(int));
  for(i=0; i<3; i++){
   *(pointer+i)=value[i];
  }
  printf("value %d\n", *pointer);
  printf("value %d\n", *(pointer+1));
  printf("value %d\n", *(pointer+2));
  return pointer;
}*/