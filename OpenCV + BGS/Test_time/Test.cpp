/*
  This program substracts the background and returns the number of non-black 
pixels, so it means the number of pixels that are not background.
*/
#include "libraries.h"

//#include <sys/time.h>                // for gettimeofday()

int main(int argc, char *argv[])
{
  
  CvCapture *capture = 0;
  int resize_factor = 50;
  int channel=99, ret, data;
  channel = (int)*argv[1];
  printf("Received channel %d\n", channel);
  

  capture = cvCaptureFromCAM(0);
  if(!capture)
  {
    std::cerr << "Cannot initialize video!" << std::endl;
    return -1;
  }
  
  int choose = 4;
  /*if (argc > 1) { 
   choose = atoi (argv[1]);
  }

  printf("Chosen method: %d\n ", choose);*/
  
  IplImage *frame_aux = cvQueryFrame(capture);
  IplImage *frame = cvCreateImage(cvSize((int)((frame_aux->width*resize_factor)/100) , (int)((frame_aux->height*resize_factor)/100)), frame_aux->depth, frame_aux->nChannels);
  cvResize(frame_aux, frame);

  //Background Subtraction Methods 
  IBGS *bgs;
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

 
  int key = 0;
  while(key != 'q')
  {
    frame_aux = cvQueryFrame(capture);
    if(!frame_aux) break;

    cvResize(frame_aux, frame);
    cv::Mat img_input(frame);
    cv::Mat img_mask;
    cv::Mat img_bkgmodel;
    bgs->process(img_input, img_mask, img_bkgmodel); // by default, it shows automatically the foreground mask image
    
    int ZeroPixels = countNonZero(img_mask);
    data = ZeroPixels;
    
   // cout<<"The number of white pixels is "<<ZeroPixels<<endl;
    ret=write(channel, &data, sizeof(int));
    printf("return %d\n", ret);
    key = cvWaitKey(33);
  }
  delete bgs;
  cvDestroyAllWindows();
  cvReleaseCapture(&capture);
  return 0;
}
