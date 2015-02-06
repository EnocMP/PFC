/*
This file is part of BGSLibrary.

BGSLibrary is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

BGSLibrary is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with BGSLibrary.  If not, see <http://www.gnu.org/licenses/>.
*/


#include <iostream>
#include<sys/time.h>
#include <opencv2/opencv.hpp>


#include "package_bgs/FrameDifferenceBGS.h"
#include "package_bgs/StaticFrameDifferenceBGS.h"
#include "package_bgs/WeightedMovingMeanBGS.h"
#include "package_bgs/WeightedMovingVarianceBGS.h"
#include "package_bgs/MixtureOfGaussianV1BGS.h"
#include "package_bgs/MixtureOfGaussianV2BGS.h"
#include "package_bgs/AdaptiveBackgroundLearning.h"
#include "package_bgs/AdaptiveSelectiveBackgroundLearning.h"

#if CV_MAJOR_VERSION >= 2 && CV_MINOR_VERSION >= 4 && CV_SUBMINOR_VERSION >= 3
#include "package_bgs/GMG.h"
#endif

#include "package_bgs/dp/DPAdaptiveMedianBGS.h"
#include "package_bgs/dp/DPGrimsonGMMBGS.h"
#include "package_bgs/dp/DPZivkovicAGMMBGS.h"
#include "package_bgs/dp/DPMeanBGS.h"
#include "package_bgs/dp/DPWrenGABGS.h"
#include "package_bgs/dp/DPPratiMediodBGS.h"
#include "package_bgs/dp/DPEigenbackgroundBGS.h"
#include "package_bgs/dp/DPTextureBGS.h"

#include "package_bgs/tb/T2FGMM_UM.h"
#include "package_bgs/tb/T2FGMM_UV.h"
#include "package_bgs/tb/T2FMRF_UM.h"
#include "package_bgs/tb/T2FMRF_UV.h"
#include "package_bgs/tb/FuzzySugenoIntegral.h"
#include "package_bgs/tb/FuzzyChoquetIntegral.h"

#include "package_bgs/lb/LBSimpleGaussian.h"
#include "package_bgs/lb/LBFuzzyGaussian.h"
#include "package_bgs/lb/LBMixtureOfGaussians.h"
#include "package_bgs/lb/LBAdaptiveSOM.h"
#include "package_bgs/lb/LBFuzzyAdaptiveSOM.h"

#include "package_bgs/ck/LbpMrf.h"
#include "package_bgs/jmo/MultiLayerBGS.h"
// The PBAS algorithm was removed from BGSLibrary because it is
// based on patented algorithm ViBE
// http://www2.ulg.ac.be/telecom/research/vibe/
//#include "package_bgs/pt/PixelBasedAdaptiveSegmenter.h"
#include "package_bgs/av/VuMeter.h"
#include "package_bgs/ae/KDE.h"
#include "package_bgs/db/IndependentMultimodalBGS.h"
#include "package_bgs/sjn/SJN_MultiCueBGS.h"
#include "package_bgs/bl/SigmaDeltaBGS.h"

#include "package_bgs/pl/SuBSENSE.h"
#include "package_bgs/pl/LOBSTER.h"

#define FRAMES 10


using namespace std;

int main(int argc, char **argv)
{
 // std::cout << "Using OpenCV " << CV_MAJOR_VERSION << "." << CV_MINOR_VERSION << "." << CV_SUBMINOR_VERSION << std::endl;

  CvCapture *capture = 0;
  int resize_factor = 50;

 /* if(argc > 1)
  {
    std::cout << "Openning: " << argv[1] << std::endl;
    capture = cvCaptureFromAVI(argv[1]);
  }
  else
  {
    capture = cvCaptureFromCAM(0);
    resize_factor = 50; // set size = 50% of original image
  }*/
    capture = cvCaptureFromCAM(0);
    
  if(!capture)
  {
    std::cerr << "Cannot initialize video!" << std::endl;
    return -1;
  }
  
  int choose = 0;
  /*if (argc > 1) { 
   choose = atoi (argv[1]);
  }*/

  //printf("Chosen method: %d\n ", choose);
  
  IplImage *frame_aux = cvQueryFrame(capture);
  IplImage *frame = cvCreateImage(cvSize((int)((frame_aux->width*resize_factor)/100) , (int)((frame_aux->height*resize_factor)/100)), frame_aux->depth, frame_aux->nChannels);
  cvResize(frame_aux, frame);

  /* Background Subtraction Methods */


  /*** Default Package ***/
/*  
  switch (choose){
    case 1:
      bgs = new StaticFrameDifferenceBGS; //OK, detecta la mà tot i estar quita, l'únic problema és un mal manteniment del Background
      break;
      
    case 2: 
      bgs = new MixtureOfGaussianV2BGS; //5 OK bona detecció de contorn i moviment, la imatge està buida per dins
      break;
     
    case 3:
      bgs = new AdaptiveSelectiveBackgroundLearning; //7 OK molt robust, nomésconfon una mica el fons
      break;
      
    case 4:
      bgs = new DPAdaptiveMedianBGS; //9  OK relativament bo, confon la mà amb el fons
      break;
      

      
    case 5:
       bgs = new DPZivkovicAGMMBGS; // 11 OK deteccio acceptable
      break;
      
    case 6:
       bgs = new DPEigenbackgroundBGS;// 15 Ok, detecció bastant bona
      break;
      
    case 7:
      bgs = new LBSimpleGaussian;//25 OK ràpid, efectiu i estable, s'ha de filtrar
      break;
      
    case 8:
        bgs = new T2FGMM_UV; //18 OK
      break;
      
    case 9:
        bgs = new LBFuzzyGaussian;//26 OK, falta filtrar més lent que l'anterior
      break;
      
    case 10: 
        bgs = new LBMixtureOfGaussians; //27 OK
      break;
    case 11:
      bgs = new DPGrimsonGMMBGS; // 10 OK bona deteccio
      break;
      
    default:
        bgs = new KDE;//32 OK relativament ràpid i funcional, s'ha de filtrar
  }

  */

 cout << "-------------BSG Time Test starting time testing------------------\n";
  
  int i, iteration;
 
  for (iteration = 1; iteration < 12; iteration++) {
  IBGS *bgs;
    switch (iteration){
    case 1:
      bgs = new StaticFrameDifferenceBGS; //OK, detecta la mà tot i estar quita, l'únic problema és un mal manteniment del Background
      break;
      
    case 2: 
      bgs = new MixtureOfGaussianV2BGS; //5 OK bona detecció de contorn i moviment, la imatge està buida per dins
      break;
     
    case 3:
      bgs = new AdaptiveSelectiveBackgroundLearning; //7 OK molt robust, nomésconfon una mica el fons
      break;
      
    case 4:
      bgs = new DPAdaptiveMedianBGS; //9  OK relativament bo, confon la mà amb el fons
      break;      
    case 5:
       bgs = new DPZivkovicAGMMBGS; // 11 OK deteccio acceptable
      break;
      
    case 6:
       bgs = new DPEigenbackgroundBGS;// 15 Ok, detecció bastant bona
      break;
      
    case 7:
      bgs = new LBSimpleGaussian;//25 OK ràpid, efectiu i estable, s'ha de filtrar
      break;
      
    case 8:
        bgs = new T2FGMM_UV; //18 OK
      break;
      
    case 9:
        bgs = new LBFuzzyGaussian;//26 OK, falta filtrar més lent que l'anterior
      break;
      
    case 10: 
        bgs = new LBMixtureOfGaussians; //27 OK
      break;
    case 11:
      bgs = new DPGrimsonGMMBGS; // 10 OK bona deteccio
      break;
      
    default:
        bgs = new KDE;//32 OK relativament ràpid i funcional, s'ha de filtrar
  }
    
    timeval t1, t2;
    double elapsedTime;

    // start timer
    gettimeofday(&t1, NULL);

    // do something
    //get and process 1000 frames
    //printf("arribo als frames\n");
    i=0;
    for (i=0; i<100; i++) {
      //      printf("* \n");

      frame_aux = cvQueryFrame(capture);
      if(!frame_aux) break;

      cvResize(frame_aux, frame);
      
      cv::Mat img_input(frame);
      cv::imshow("input", img_input);

      cv::Mat img_mask;
      cv::Mat img_bkgmodel;
      
      bgs->process(img_input, img_mask, img_bkgmodel); // by default, it shows automatically the foreground mask image
      
      //if(!img_mask.empty())
      //  cv::imshow("Foreground", img_mask);
      //  do something    
    }
    printf("\n");
      delete bgs;

  //cvDestroyAllWindows();
  //cvReleaseCapture(&capture);

    // ...

    // stop timer
    gettimeofday(&t2, NULL);

    // compute and print the elapsed time in millisec
    elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000.0;      // sec to ms
    elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0;   // us to ms
    cout <<"method "<< iteration << "   " <<   elapsedTime << " ms.\n";   
  }
  cout << "BSL time testing done\n";
}
  
  
 
