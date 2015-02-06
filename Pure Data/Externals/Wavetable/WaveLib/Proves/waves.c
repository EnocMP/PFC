//#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define WAVE_SAMPLES 10


float* SineFunction(){
  float SineVector[WAVE_SAMPLES]={1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 
2.0};
  float *pointer;
  pointer = malloc(WAVE_SAMPLES*sizeof(float));
  memcpy(pointer, SineVector, WAVE_SAMPLES*sizeof(float));
 
  return pointer;
  
  }