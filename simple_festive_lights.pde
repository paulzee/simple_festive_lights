/*
 Xmas Lights
 
 This example provides a button controlled main loop 
 that calls various LED effect sub functions
 These sub functions are versatile in that they can
 be called with various delay and fade increment parameters
 
 This code is based on primarily from examples available 
 in the public domain at http://arduino.cc/en/Tutorial:
  /Blink
  /Fade
  /ButtonStateChange
  /EEPROM.Read
  /EEPROM.Write

*/

#include <EEPROM.h>
 
// Constants don't change

//Pin assignments
const int buttonPin = 10;         // 2 the pin that the pushbutton is attached to
const int ledLightsPin = 9;       // the pin that the LED is attached to
const int ledStatusPin = 13;      // the pin that the Status LED is attached to

//Brightness relative values
const int pwmMaximum = 255;       // maximum brightness value
const int pwmHigh = 192;          // high brightness value
const int pwmMediumHigh = 128;    // medium-high brightness value
const int pwmMedium = 48;         // medium brightness value
const int pwmMediumLow = 32;      // medium-low brightness value
const int pwmLow = 12;            // low brightness value
const int pwmDim = 3;             // dim brightness value

//Number of available button pushes/ light routines
const int buttonMaxCounter = 12;    // Maximum for the button counter number

// Variables will change:

int buttonPushCounter = 1;    // counter for the number of button presses
int buttonState = 0;          // current state of the button
int lastButtonState = 0;      // previous state of the button
int IsNewCycle = HIGH;        // flag for New Cycle indicator for routines

int brightLower = 0;          // brightness lower range
int brightUpper = 255;        // brightness lower range
int brightLowerDefault = 0;   // brightness lower range Default Value
int brightUpperDefault = 255; // brightness lower range Default Value
int brightness = 0;           // how bright the LED is
int cycleFadeAmount = 0;      // work variable for how many points to fade the LED by
//int fadeAmount = 0;        

int buttonAddress = 0;        // EEPROM address to store button selection
byte bButtonValue;            // work variable for EEPROM address data

void setup()  { 

  // initialize the button pin as an input
  pinMode(buttonPin, INPUT);
  // initialize the Status LED pin as an output
  pinMode(ledStatusPin, OUTPUT);
  // initialize the LED Light pin as an output
  pinMode(ledLightsPin, OUTPUT);
  // initialize serial communication
  Serial.begin(9600);

  // Check for and setup last selection choice
  // read a byte from the button address of the EEPROM
  bButtonValue = EEPROM.read(buttonAddress);
  buttonPushCounter = int(bButtonValue);
  if (buttonPushCounter == 0) {
    // Emulate first button press
    IsNewCycle = HIGH;
  }
  
  // Set Default Values for Upper and Lower Brightness Bounds.
  brightLowerDefault = 0;
  brightUpperDefault = pwmMediumHigh;
} 

void loop()  { 
  // read the pushbutton input pin:
  buttonState = digitalRead(buttonPin);
  Serial.println(" ");Serial.print(" buttonState ");Serial.print(buttonState); 

  // compare the buttonState to its previous state
  if (buttonState != lastButtonState) {
    // if the state has changed, increment the counter
    if (buttonState == HIGH) {
      // if the current state is HIGH then the button
      // went from off to on:
      
      if (buttonPushCounter == buttonMaxCounter) {
        // if the current button push count is past upper range, reset to Zero
        buttonPushCounter=0;
      } 
      buttonPushCounter++;
      bButtonValue = byte(buttonPushCounter);
      EEPROM.write(buttonAddress, bButtonValue);  // Store button push selection into EEPROM
      digitalWrite(ledStatusPin, HIGH);           // set the Status LED on
      delay(250);                                 // delay to show Status
      digitalWrite(ledStatusPin, LOW);            // set the Status LED off
      IsNewCycle=HIGH;                            // Reset New cycle indicator for next routine
      //Serial.println(" ");Serial.print("Button On - number of button pushes:  ");Serial.print(buttonPushCounter);
    } 
    else {
      // if the current state is LOW then the button went from on to off:
      //Serial.println(" ");Serial.print("off"); 
    }
  }
  // save the current state as the last state, 
  //for next time through the loop
  lastButtonState = buttonState;

  //Serial.print(" Loop end before case IsNewCycle ");Serial.print(IsNewCycle);
  //Serial.println(" ");Serial.print(" fadeAmount ");Serial.print(fadeAmount);
  
  // run light effect for selection (number of button pushes)
  switch (buttonPushCounter) {
  case 1:    // High
    //Serial.println(" ");Serial.print(buttonPushCounter);Serial.print(" High");
    xmasOn(brightUpperDefault);
    break;
    
  case 2:    // Medium
    //Serial.println(" ");Serial.print(buttonPushCounter);Serial.print(" Medium");
    xmasOn(pwmMedium);
    break;
    
  case 3:    // Low
    //Serial.println(" ");/Serial.print(buttonPushCounter);Serial.print(" Low");
    xmasOn(pwmLow);
    break;
    
  case 4:    // Dim
    //Serial.println(" ");Serial.print(buttonPushCounter);Serial.print(" Dim");
    xmasOn(pwmDim);
    break;
    
  case 5:    // fade
    //Serial.println(" ");Serial.print(buttonPushCounter);Serial.print(" Fade");
    // If first pass of New cycle, Set desired brightness range
    if (IsNewCycle == HIGH) { 
      brightLower = 1; brightUpper = brightUpperDefault;
    }
    xmasFader(IsNewCycle, 4, 150, 500);
    break;
    
  case 6:    // wave
    //Serial.println(" ");Serial.print(buttonPushCounter);Serial.print(" Wave");
    // If first pass of New cycle, Set desired brightness range
    if (IsNewCycle == HIGH) { 
      brightLower = 0; brightUpper = brightUpperDefault;
    }
    xmasFader(IsNewCycle, 4, 50, 1000);
    break;
    
  case 7:    // oscillate
    //Serial.println(" ");Serial.print(buttonPushCounter);Serial.print(" Oscillate");
    // If first pass of New cycle, Set desired brightness range
    if (IsNewCycle == HIGH) { 
      brightLower = 0; brightUpper = brightUpperDefault;
    }
    xmasFader(IsNewCycle, 2, 10, 400);
    break;
    
  case 8:    // blink
    //Serial.println(" ");Serial.print(buttonPushCounter);Serial.print(" Blink");
    if (IsNewCycle == HIGH) { 
      brightLower = 0; brightUpper = pwmMediumLow;
    }
    xmasFlasher(100, 5000);
    break;
    
  case 9:    // wink
    //Serial.println(" ");Serial.print(buttonPushCounter);Serial.print(" Wink");
    if (IsNewCycle == HIGH) { 
      brightLower = 0; brightUpper = pwmMediumLow;
    }
    xmasFlasher(500, 3000);
    break;
    
  case 10:    // flash
    //Serial.println(" ");Serial.print(buttonPushCounter);Serial.print(" Flash");
    if (IsNewCycle == HIGH) { 
      brightLower = 0; brightUpper = pwmMediumLow;
    }
    xmasFlasher(2000, 1000);
    break;
    
  case 11:    // Throb
    //Serial.println(" ");Serial.print(buttonPushCounter);Serial.print(" Throb");
    // If first pass of New cycle, Set desired brightness range
    if (IsNewCycle == HIGH) { 
      brightLower = 4; brightUpper = pwmMedium;
    }
    xmasFader(IsNewCycle, 4, 60, 1000);
    // At the ends of the fade, reverse the direction of the fading 
    if (brightness <= brightLower) {
        delay(4000);
    }     
    //Serial.println(" ");Serial.print(" brightness ");Serial.print(brightness);     
    break;
    
  case 12:    // Dimmer
    //Serial.println(" ");Serial.print(buttonPushCounter);Serial.print(" Dimmer");
    // If first pass of New cycle, Set desired brightness range
    if (IsNewCycle == HIGH) { 
      //Serial.print(" Set fadeAmount ");Serial.print(fadeAmount);
      brightLower = 4; brightUpper = pwmLow;
    }
    xmasFader(IsNewCycle, 2, 20, 200);
    if (brightness <= brightLower || brightness >= brightUpper ) {
       delay(3000);
    }     
    //Serial.println(" ");Serial.print(" brightness ");Serial.print(brightness);     
    break;
    
  default:   // else
    break;
  } 
  if (IsNewCycle == HIGH) {   // Turn off New cycle flag
    IsNewCycle=LOW;
  }
  //Serial.println(" ");Serial.print(" Reset High IsNewCycle ");Serial.print(IsNewCycle);
}

void xmasOn(int brightnessAmount) {
  //digitalWrite(ledLightsPin, brightnessAmount);   // set the LED on
  analogWrite(ledLightsPin, brightnessAmount);   // set the LED brightness
}

void xmasFader(int IsNewCycle, int fadeAmount, int fadeDelayBetween, int fadeDelayEnd) {
  //*
  
  //Serial.println(" ");Serial.print(" Start of Wave function IsNewCycle ");Serial.print(IsNewCycle);

  // If first pass of New cycle, Set desired fade value
  if (IsNewCycle == HIGH) {   
    //Serial.print(" Set fadeAmount ");Serial.print(fadeAmount);
    cycleFadeAmount=fadeAmount;
  }

  // change the brightness for this loop
  brightness = brightness + cycleFadeAmount;

  // If valid fade range exceeded, set to valid range limit
  if (brightness > brightUpper) {
    brightness = brightUpper;  
  } else if (brightness < brightLower) {
    brightness = brightLower;  
  }     

  // set the brightness of the LED pin
  analogWrite(ledLightsPin, brightness);    

  // Skip the delay if Button pressed 
  if (digitalRead(buttonPin)<=0) {
    // wait for n milliseconds to see the dimming effect
    delay(fadeDelayBetween);  
    }     
  //*  

  // At the ends of the fade, reverse the direction of the fading 
  if (brightness <= brightLower || brightness >= brightUpper) {
    // Skip the delay if Button pressed 
    if (digitalRead(buttonPin)<=0) {
      // extra delay for n milliseconds at range ends
      delay(fadeDelayEnd);  
    }     
    cycleFadeAmount = -cycleFadeAmount ; 
    //Serial.println(" ");Serial.print(" brightness ");Serial.print(brightness);
  }     
}

void xmasFlasher(int flashDelayOn, int flashDelayOff) {
  digitalWrite(ledLightsPin, brightUpper);   // set the LED on
  if (digitalRead(buttonPin)<=0) {
    delay(flashDelayOn);                // wait for light on delay
  }
  digitalWrite(ledLightsPin, brightLower);    // set the LED off
  if (digitalRead(buttonPin)<=0) {
    delay(flashDelayOff);               // wait for light off delay
  }
}

