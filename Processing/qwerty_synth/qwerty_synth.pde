/* 
//  Instrument no. 2: Qwerty Synth  (26/08/2014)
// 
//  Sound control mechanisms:
//   i) 2-D mouse position on the windows controls vibrato(X) and amount of FM Modulation(Y)
//   ii) keys 1-4 select carrier's waveform, keys 5-8 select modulation's waveform
     iii) keys asdfghjkl as white piano keys (C D E F G A B) and keys wetyu as black piano keys (C# D# F# G# A#)
     
     The output oscilator's frequency is modified by the Modulation oscilator (FM modulation) and
     its amplitude is modulated by the Vibrato oscilator (AM modulation with fixed frequency).  

*/


 // import everything necessary to make sound.
 import ddf.minim.*;
 import ddf.minim.signals.*;
 import ddf.minim.ugens.*;
  
 Minim minim;
 AudioOutput out;
 Oscil Modulation;   // FM Modulation Oscilator
 Oscil carrier;      // Output Oscilator
 Oscil Vibrato;      // AM or Vibrato Oscilator

 //global variables
  float ModulateAmount; 
  float VibratoAmount;
  int oct=2; 
  float result=0;
  char last_key = 0;


void setup() {
// Initializating function in Processing 

  size(700,700);  

  // Audio setup 
  
  minim = new Minim( this );
  out   = minim.getLineOut();

// Create the oscilators
  Vibrato = new Oscil( 12, 0.8, Waves.SINE ); //the frequency of the AM modulator is set to 12Hz to produce a Vibrato effect
  carrier = new Oscil( 0, 0.8, Waves.SINE ); //frequency and amplitude parameters are changed later
  Modulation = new Oscil(0, 0.8, Waves.SINE); //frequency and amplitude parameters are changed later

  Vibrato.offset.setLastValue(1); //default value of amplitude 1

//Map the oscillators
  Vibrato.patch(carrier.amplitude); // map the Vibrato output to the amplitude
  Modulation.patch( carrier.frequency); //map the modulation output to the frequency
  carrier.patch( out ); //map carrier to the output
  
  textFont(createFont("Arial", 12));
  stroke     ( 255 );   // draw using a white stroke
}

  void draw() {
// Executed continuously 


  background (  0  ); // background is black
  stroke     ( 255 );   // draw using a white stroke
 
 /* Draw the waveforms*/

  for( int i = 0; i < out.bufferSize() - 1; i++ )
  {
 
    // Find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    // Draw a line from one buffer position to the next for both channels
    line( x1, 250 + out.right.get(i)*50, x2, 250 + out.right.get(i+1)*50);
    
  }  
 
 
 
  //Assign to the key the correct functionality
  if (keyPressed) { 
    //Set frequency according to notes
    if (key == 'a' || key == 'A') {
      result =  110.0 ;
    }
    else if (key == 'w' || key == 'W') {
      result = (116.54 );
    }
    else if (key == 's' || key == 'S') {
      result = (123.47 );
    }
     else if (key == 'e' || key == 'E') {
      result = (130.81);
    }
     else if (key == 'd' || key == 'D') {
      result = (138.59 );
    }
     else if (key == 'f' || key == 'F') {
      result = (146.83 );
    }
     else if (key == 't' || key == 'T') {
      result = (  155.56 );
    }
    else if (key == 'g' || key == 'G') {
      result = ( 164.81 );
    }
    else if (key == 'y' || key == 'Y') {
      result = ( 174.61 );
    }
    else if (key == 'h' || key == 'H') {
      result = ( 185.0 );
    }
    else if (key == 'u' || key == 'U') {
      result = ( 196.0 );
    }
    else if (key == 'j' || key == 'J') {
      result = ( 207.65 );
    }
    else if (key == 'k' || key == 'K') {
      result = ( 220.0 );
    }
    
    //set waveforms
    else if(key == '1') {
      carrier.setWaveform( Waves.SINE );
    }
    else if(key == '2') {
      carrier.setWaveform( Waves.TRIANGLE );
    }
    else if(key == '3')  {
      carrier.setWaveform( Waves.SQUARE );
    }
    else if(key == '4'){
      carrier.setWaveform( Waves.SAW );
    }
    else if(key == '5') {
      Modulation.setWaveform( Waves.SINE );

    }
    else if(key == '6') {
      Modulation.setWaveform( Waves.TRIANGLE );
    }
    else if(key == '7')  {
      Modulation.setWaveform( Waves.SQUARE );
    }
    else if(key == '8'){
      Modulation.setWaveform( Waves.SAW );
    }
    //incresase or decrease octave
    else if(key == '9' && last_key != key){
     oct++;
    }
    else if (key == '0' && last_key != key && oct > 0) {
     oct--;
      
    }
    else {
      result = 0; // if another key is pressed the carrier is set to frequency 0Hz
    } 
    
    if (result>0) {
    last_key=key; //save the last value to avoid fast octave changes
    Modulation.offset.setLastValue(oct*result); //set the frequency of modulation and 
    Modulation.setFrequency(oct*result);        //carrier to the new value
    }
  }
  else {// key is not pressed
    last_key=0;
  }
  
  
  //Displaying parameters 
  text( "Carrier central frequency: " +oct*result, 5, 15 );
  text( "modulation frequency: " + Modulation.frequency.getLastValue(), 5, 30 );
  text( "Octave: " + oct, 5, 45);
  text( "Modulation: " +ModulateAmount, 5, 60 );
  text( "Vibrato: " +VibratoAmount, 5, 75 );


   text( "1-4 to select carrier waveform", 500, 500 );
   text( "1 - Sine wave", 510, 515 );
   text( "2 - Triangle wave", 510, 530 );
   text( "3 - Square wave", 510, 545);
   text( "4 - Sawtooth wave", 510, 560 );
   text( "5-8 to select modulator waveform", 500, 600 );
   text( "5 - Sine wave", 510, 615 );
   text( "6 - Triangle wave", 510, 630 );
   text( "7 - Square wave", 510, 645);
   text( "8 - Sawtooth wave", 510, 660 );

   
   text( "              INSTRUCTIONS            ", 150, 375 );
   text( "----------------------------------------- ", 150, 385 );
   text( "mouse X direction controls Vibrato", 150, 400 );
   text( "mouse Y direction controls Modulation", 150, 425 );
   text( "play keys asdfghjkl as white piano keys (C D E F G A B)", 150, 450 );
   text( "play keys wetyu as black piano keys", 150, 475 );
   text (" 1-8 to select waveforms", 150, 500);
   text( "9 - Increase Octave", 150, 525);
   text( "0 - Decrease Octave", 150, 550 ); 
}


void mouseMoved()
// We can change the parameters of the frequency modulation Oscil and the vibrato Oscil
// in real-time using the mouse.
{
   ModulateAmount = map( mouseY, 0, height, 2000, 1 );
   VibratoAmount = map( mouseX, 0, height, 0.1, 0.7 );

  if (VibratoAmount < 0.2) VibratoAmount = 0.0;   //if Vibrato is less than 0.2 it is set to 0
  
  else VibratoAmount += -0.2; //if it is greater than 0.2 it goes from 0 to 0.5 according the mouse position
  
  Vibrato.setAmplitude(VibratoAmount);
  Modulation.setAmplitude(ModulateAmount);
}

