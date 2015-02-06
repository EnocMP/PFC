#include <TimerOne.h>
#include<Firmata.h>

//Compiling options
#define PRINT 0
#define FIRMATA 1

//Numerical parameters
#define POLINOMIAL_ORDER 6 //order of the polinomic method
#define SAMPLES 10 //define the number of samples to promediate each interrupt
#define AVERAGE_WINDOW 10 //define the window to calculate the AVERAGE_WINDOW filter
#define DEAD_ZONE_THRESHOLD 1

int sensorValue, i; // variable to store the value coming from the sensor
int TimeInterrupt;
//FIR filter variables
double  FilterAcumulator, FilteredData;
//Average window filter variables
double AverageRegister[AVERAGE_WINDOW], AveragedData, AverageAcumulator;

//Measuring and interrupt variables
double Measures[SAMPLES], RawData, NewRawData;
double Data, NewData ;
double  DeadZoneMax = 0.0, DeadZoneMin = 0.0;
boolean DataAvailable = false;
int iteration = 0;
double PolinomialCoefficients[POLINOMIAL_ORDER + 1] = {
  //2446, -338.67,24.819,-1.007,0.0227,-0.0003,1e-6} ;//ORDER 6
  1857.2, -186.15, 9.74, -0.2711, 0.0038, -2e-5
}; //ORDER 5
double DistanceValue, OldData[2], Derivative[2];

boolean DeadZone = true;

/**************************************** SETUP*****************************************/
void setup() {
  pinMode(A0, INPUT);
  pinMode(13, OUTPUT);
  analogReference(EXTERNAL); //connect the reference to the 3.3V pin
#if FIRMATA
  Firmata.setFirmwareVersion(0, 1); //initializing Firmata
  Firmata.attach(ANALOG_MESSAGE, analogWriteCallback);
  Firmata.begin(57600);
#endif

#if PRINT
  Serial.begin(57500);
  Serial.print("Max\t");
  Serial.print("Min\t");
  Serial.print("RawData\t");
  Serial.println("AverageFilter\t");
  //Serial.println("FIR Filter");
#endif

  //Average Filter Initialization
  for (i = 0; i < (AVERAGE_WINDOW * 3); i++) {
    ReadSensor();
    Data = NewData;
    RawData =  NewRawData;
    AveragedData = AverageWindowFilter(Data);
    Print();

  }
  //Searching for the DeadPoinZone
  DeadZoneMin = RawData + 100;
  DeadZoneMax = RawData - 100;
  for (i = 0; i < 100; i++) {
    ReadSensor();
    Data = NewData;
    RawData = NewRawData;
    AveragedData = AverageWindowFilter(Data);
    if (DeadZoneMin > AveragedData) DeadZoneMin = AveragedData;
    else if (DeadZoneMax < AveragedData) DeadZoneMax = AveragedData;
    Print();

  }
  DeadZoneMax = DeadZoneMax * 1.02;
  DeadZoneMin = DeadZoneMin * 0.98;
  OldData[0] = AveragedData;
  OldData[1] = AveragedData;
  Timer1.initialize(10000); //Initializing the timer at 50Hz (20ms)
  Timer1.attachInterrupt(ReadSensor);
}

/****************************************************************LOOP********************************************************/
void loop() {
#if FIRMATA
  while (Firmata.available()) { //receiving Firmata inputs
    Firmata.processInput();
  }
#endif
  if (DataAvailable) { //if new data is available (depends on the timer)
    DataAvailable = false;

    Data = NewData;
    RawData = NewRawData;
    /*-------AVERAGE_WINDOW FILTER--------*/
    AveragedData = AverageWindowFilter(Data);

    /*---------DEAD ZONE--------*/
    Derivative[1] = Derivative[0];
    Derivative[0] = abs(AveragedData - OldData[0]);

    OldData[1] = OldData[0];
    OldData[0] = AveragedData;

    if (AveragedData < DeadZoneMax && AveragedData > DeadZoneMin) {
      if (DEAD_ZONE_THRESHOLD > Derivative[0] && DEAD_ZONE_THRESHOLD < Derivative[1]) {
        DeadZone = true;
        Firmata.sendAnalog(1, 0); //0 volume
        digitalWrite(13, HIGH);
      }
    }
    else {
      if (DeadZone) {
        digitalWrite(13, LOW);
        DeadZone = false;
        Firmata.sendAnalog(1, 1); //1 volume

      }
    }


#if PRINT
    Print();
#endif
#if FIRMATA
    double val = 10000*PolinomialCaracterization(AveragedData);
    int note = (int)val;
    Firmata.sendAnalog(0, note);
#endif
  }
}

/****************************************************************FUNCTIONS********************************************************/

void ReadSensor() {
  NewData = 0.0;
  for (int k = 0; k < SAMPLES; k++) { //samples to promediate
    NewRawData = (double)analogRead(A0);
    NewData += NewRawData;
  }
  NewData = NewData / SAMPLES;
  DataAvailable = true;
}


void analogWriteCallback(byte pin, int value) {
  if (IS_PIN_PWM(pin)) {
    pinMode(PIN_TO_DIGITAL(pin), OUTPUT);
    analogWrite(PIN_TO_PWM(pin), value);
  }
}


double PolinomialCaracterization(float value) {
  double distance;
  distance = PolinomialCoefficients[1] + pow(value, 1) * PolinomialCoefficients[2] * pow(value, 2) +
             pow(value, 3) * PolinomialCoefficients[3] + PolinomialCoefficients[4] * pow(value, 4) +
             pow(value, 5) * PolinomialCoefficients[5] + PolinomialCoefficients[6] * pow(value, 6);
  return distance;
}

double AverageWindowFilter (double input) {
  double output;
  AverageAcumulator = 0.0;
  for (int j = AVERAGE_WINDOW - 1; j > 0; j--) {
    AverageRegister[j] = AverageRegister[j - 1]; //shifting the register
    AverageAcumulator += AverageRegister[j];//adding the value to the acumulator
  }
  AverageRegister[0] = input;
  AverageAcumulator += AverageRegister[0];
  output = AverageAcumulator / AVERAGE_WINDOW;
  return output;

}

void Print() {
  //  Serial.print(DeadZoneMax);
  Serial.print(RawData);
  Serial.print("\t");
  //Serial.print(DeadZoneMin);
  Serial.print(Data-50);
  Serial.print("\t");
  Serial.println(AveragedData-100);
  //Serial.print("\t");
  //Serial.println(Derivative[0]*10);
}
