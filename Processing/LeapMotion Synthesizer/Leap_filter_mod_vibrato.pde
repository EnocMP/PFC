/***************LIBRARIES*************/
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import de.voidplus.leapmotion.*;


/***************OBJECTS***************/
LeapMotion leap;
Minim minim;
AudioOutput out;
Oscil Modulation;   // FM Modulation Oscilator
Oscil Carrier;      // Output Oscilator
Oscil Vibrato;      // AM or Vibrato Oscilator
IIRFilter filt;     // FILTER
//deviation variables

float frequency = 220.0;

void setup() {
  size(800, 500, P3D);
  background(255);
  stroke(100); 
  fill(50);

  /***************OBJECTS***************/
  leap = new LeapMotion(this);
  minim = new Minim( this );
  out   = minim.getLineOut(); //create the output
  filt = new LowPassFS(400, out.sampleRate()); //create the filter

  // Create the oscilators
  Carrier = new Oscil( 0, 0.8, Waves.SINE ); //frequency and amplitude parameters are changed later
  Modulation = new Oscil( 0, 0.8, Waves.TRIANGLE ); //frequency and amplitude parameters are changed later
  Carrier = new Oscil( 0, 0.8, Waves.SAW ); //frequency and amplitude parameters are changed later

  //set the values to the oscillators
  Modulation.setAmplitude(0);
  Modulation.offset.setLastValue(frequency);
  Modulation.patch(Carrier.frequency);
  Carrier.setFrequency(frequency);
  Carrier.setAmplitude(0);
  
  //patch the oscillators
  Carrier.patch(filt).patch(out);
}

void draw() {
  /*****************************VARIABLES**************************/

  float volume=0.0;
  float cutoff = 65.0;
  float modulation = 0.0;
  float deviation;
  float[] xfingers = new float[5];//={ 0, 0, 0, 0, 0}; 
  float[] yfingers = new float[5];//={ 0, 0, 0, 0, 0}; 
  float[] zfingers = new float[5];//={ 0, 0, 0, 0, 0}; 
  int i=0;
  
  float   hand_roll        = 0;
  float   hand_pitch       = 0;
  float   hand_yaw         = 0;
  
  int fingers=5;
  for (i=0; i< 5; i++) {
    xfingers[i] = 0.0;
    yfingers[i] =0.0;
    zfingers[i]= 0.0;
  }
  i=0;

  /*****************************LEAP MOTION**************************/
  background(255);
  // ...
  int fps = leap.getFrameRate();

  // HANDS
  for (Hand hand : leap.getHands ()) {

    hand.draw();
    PVector hand_position    = hand.getPosition();
       hand_roll        = hand.getRoll();
       hand_pitch       = hand.getPitch();
       hand_yaw         = hand.getYaw();
  
    
    /******Volume calculation*******/
    volume =  1-hand_position.y/450;
    if (volume > 1.0) volume=1.0;
    else if (volume < 0.0) volume= 0.0;
    volume = pow(volume, 2);


    // FINGERS
    for (Finger finger : hand.getFingers ()) {

      finger.draw();
      PVector finger_position   = finger.getPosition();
      xfingers[i] = finger_position.x;
      yfingers[i] = finger_position.y;
      zfingers[i] = finger_position.z;
      i++;
    }
    fingers = i;
  }
  
     text( "hand roll: " +hand_roll , 5, 155 );
     text( "hand pitch: "+hand_pitch , 5, 170 );
     text( "hand yaw: " +hand_yaw, 5, 185 );
  
  /******modulation calculation*******/
  modulation = map(hand_roll, 0, 30, 0, 3000);
  if (modulation < 0) modulation = 0.0;
  text("Modulation: " +modulation, 5, 40);
  Modulation.setAmplitude(modulation);
  
  /******cutoff calculation*******/
  deviation = standard_deviation(xfingers, yfingers, zfingers, fingers);
  deviation = map(deviation, 50, 95, 0, 1);
  cutoff = frequency*(1+pow(deviation, 4)*10);
  text("Cutoff frequency: " +cutoff, 5, 25);
  /*****************************ACTION**************************/
  Carrier.setAmplitude(volume);
  //filt.setFreq(cutoff);
  filt.setFreq(20000);
}





float standard_deviation (float[] x, float[] y, float[] z, int fingers) {
  float sumx = 0.0;
  float sumy = 0.0;
  float sumz = 0.0;

  float psumx = 0.0;
  float psumy = 0.0;
  float psumz = 0.0;

  for (int j=0; j<fingers; j++) {
    psumx += pow(x[j], 2);
    psumy += pow(y[j], 2);
    psumz += pow(z[j], 2);     
    sumx += x[j];
    sumy += y[j];
    sumz += z[j];
  }

  sumx = sumx/fingers;
  sumy = sumy/fingers;
  sumz = sumz/fingers;     
  psumx = psumx/fingers;
  psumy = psumy /fingers;
  psumz = psumz/fingers;
  float Sx = sqrt(psumx - pow(sumx, 2));
  float Sy = sqrt(psumy - pow(sumy, 2));
  float Sz = sqrt(psumz - pow(sumz, 2));
  float kx = 1.0, ky = 2.0, kz = 1.0; // ponderation constants
  float result = sqrt(kx*pow(Sx, 2) + ky*pow(Sy, 2) + kz*pow(Sz, 2)); //modified standard deviation
  text("Deviation parameters", 660, 185);  
  text( "Sx: " +Sx, 660, 200 );
  text( "Sy: " +Sy, 660, 215 );
  text( "Sz: " +Sz, 660, 230 );
  text("Deviation: "+result, 660, 250);
  return result;
}

