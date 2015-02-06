#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "waves.h"

#define FS 44100
#define SAMPLES 2147483647 //s^31 -1 
#define PI 3.14159
#define WAVE_SAMPLES 10


void main(){
    float *point;
    point=SineFunction();
    int i;
    for (i=0; i<WAVE_SAMPLES; i++){
     printf("SineVec %d = %f\n", i, *(point+i)); 
    }
    free(point);
  
}

