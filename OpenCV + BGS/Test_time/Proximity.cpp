/*
  This program substracts the background and returns the number of non-black 
pixels, so it means the number of pixels that are not background. Then sends 
this number throuhg a pipe
*/
#include "libraries.h"

#define PIPE 0
#define BGS 1
#define OPENCV 1


int main(int argc, char *argv[])
{
 int key=0, data;
  //Pipe and communications Variables
#if PIPE //configuring the channel
  int channel;
  channel = (int)*argv[1];
  printf("Received channel %d\n", channel);

#endif
  
  
  
#if OPENCV //configure OPEN CV
    CvCapture *capture = 0;
  int resize_factor = 50;

  capture = cvCaptureFromCAM(0);
  if(!capture)
  {
    std::cerr << "Cannot initialize video!" << std::endl;
    return -1;
  }
  IplImage *frame_aux = cvQueryFrame(capture);
  IplImage *frame = 
      cvCreateImage(cvSize((int)((frame_aux->width*resize_factor)/100) , 
      (int)((frame_aux->height*resize_factor)/100)), frame_aux->depth, 
      frame_aux->nChannels);
  cvResize(frame_aux, frame);
#endif
  
#if BGS
   IBGS *bgs;//BGS model
  bgs = new DPAdaptiveMedianBGS; //bgs method
#endif

  while(key != 'q')
  {
#if OPENCV
    frame_aux = cvQueryFrame(capture);
    if(!frame_aux) break;
    cvResize(frame_aux, frame);
    cv::Mat img_input(frame);
    cv::Mat img_mask;
    cv::Mat img_bkgmodel;
#endif
    
#if BGS
    bgs->process(img_input, img_mask, img_bkgmodel); 
    // by default, it shows automatically the foreground mask image
   /* int ZeroPixels = countNonZero(img_mask);
    data = ZeroPixels;*/
#endif
    
#if PIPE
    ret=write(channel, &data, sizeof(int));
    printf("return %d\n", ret);
#endif
    key = cvWaitKey(33);
  }
#if BGS
  delete bgs;
#endif
  
#if OPENCV
  cvDestroyAllWindows();
  cvReleaseCapture(&capture);
#endif
  return 0;
}
