int         stageW           = 1000;
int         stageH           = 1000;
color       clrBG            = #242424;
String      pathAssets       = "../../../assets/";

// ************************************************************************************

// THIS IS THE AUDIO VARS

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
AudioPlayer myAudioPlayer;
String      whichAudioFile   = "DM2.mp3";

AudioInput  myAudioInput;
boolean     myAudioToggle    = true; // true = myAudioPlayer / false = myAudioInput
boolean     showVisualizer   = true;

FFT         myAudioFFT;

int         myAudioRange     = 16; // 256 / 128(2) / 64(4) / 32(8) / 16(16)
int         myAudioMax       = 100;

float       myAudioAmp;
float       myAudioIndex;
float       myAudioIndexAmp;
float       myAudioIndexStep;

float[]     myAudioData      = new float[myAudioRange]; // KEEP A RECORD OF ALL THE NUMBERS IN AN ARRAY

// ************************************************************************************

// THIS ALL THE WORKING WITH COLOR STUFF

String      whichImg         = pathAssets + "rainbow.png";
PImage      clrs;
int         clrsW;
float       clrCount;
float       clrSpeed         = 0.02; // the speed of the color change
float       clrOffset        = 0.02; // the distance from each of the squares getting colored

// ************************************************************************************

// VARS TO RENDER SOME IMAGES

boolean     letsRender       = false; // RENDER YES OR NO
int         renderModulo     = 120;    // RENDER AN IMAGE ON WHAT TEMPO ?
int         renderNum        = 0;     // FIRST IMAGE
int         renderMax        = 20;    // HOW MANY IMAGES
String      renderPATH       = "../renders_001/";

// ************************************************************************************

import hype.*;
import hype.extended.behavior.HOscillator;

HOscillator oscX, oscS, oscRX, oscRY, oscRZ;

// ************************************************************************************

void settings() {
  size(stageW, stageH, P3D);
}

void setup() {
  H.init(this);
  background(clrBG);
  audioSetup();

  clrs = loadImage(whichImg);
  clrsW = clrs.width-1;

  oscX  = new HOscillator().range(-300, 300).speed(1).freq(2).waveform(H.SINE);

  oscS  = new HOscillator().range(150, 350).speed(1).freq(5).waveform(H.SINE); //size/scale
  
  oscRX = new HOscillator().range(-180, 180).speed(1).freq(1).waveform(H.SINE);
  oscRY = new HOscillator().range(-180, 180).speed(1).freq(1).waveform(H.SINE);
  oscRZ = new HOscillator().range(-180, 180).speed(1).freq(1).waveform(H.SINE);
}

void draw() {
  background( clrBG );

// ************************************************************************************

  float _oscX = map(myAudioData[0], 0, myAudioMax, 0.1, 2.0);
  oscX.speed(_oscX);
  oscX.nextRaw();

  float _oscS = map(myAudioData[1], 0, myAudioMax, -0.5, 2.0);
  oscS.speed(_oscS);
  oscS.nextRaw();

  float _oscRX = map(myAudioData[2], 0, myAudioMax, 0.0, 1.75);
  oscRX.speed(_oscRX); 
  oscRX.nextRaw();

  float _oscRY = map(myAudioData[4], 0, myAudioMax, 0.0, 1.5);
  oscRY.speed(_oscRY); 
  oscRY.nextRaw();

  float _oscRZ = map(myAudioData[6], 0, myAudioMax, 0.0, 1.25);
  oscRZ.speed(_oscRZ); 
  oscRZ.nextRaw();


// ************************************************************************************

  strokeWeight(1);
  stroke(#000000);

  float wave = sin( clrCount );
  float waveMap = map(wave, -1, 1, 0, clrsW);
  fill( clrs.get((int)waveMap,0), 255 );

  lights();

  push();
    translate(stageW/2, stageH/2, 0);
    push();
      translate(oscX.curr(), 0, 0);
      rotateX(radians(oscRX.curr()));
      rotateY(radians(oscRY.curr()));
      rotateZ(radians(oscRZ.curr()));
      box(oscS.curr(), oscS.curr(), oscS.curr());
    pop();
  pop();

  

// ************************************************************************************

  noLights();
  audioUpdate();
  clrCount += clrSpeed;

  if(frameCount%(renderModulo)==0 && letsRender) {
    save(renderPATH + renderNum + ".png");
    renderNum++;
    if(renderNum>=renderMax) exit();
  }
}

// ************************************************************************************

void keyPressed() {
  switch (key) {
    case '1': if(!myAudioToggle){myAudioInput.close();} myAudioToggle = true;  minim.stop(); audioSetup(); break; // audioPlayer
    case '2': if(myAudioToggle){myAudioPlayer.close();} myAudioToggle = false; minim.stop(); audioSetup(); break; // audioInputcase 's': myAudioPlayer.pause();  break;
    case 'p': myAudioPlayer.play();   break;
    case 'm': myAudioPlayer.mute();   break;
    case 'u': myAudioPlayer.unmute(); break;

    case 'v': showVisualizer = !showVisualizer; break;
  }
}

// ************************************************************************************

void buildCube(PImage _t1, PImage _t2, PImage _t3, PImage _t4, PImage _t5, PImage _t6) {
  strokeWeight(0);
  noStroke();

  // back
  beginShape(QUADS);
    texture(_t3);
    vertex( (0.5), -(0.5), -(0.5),   0, 0);
    vertex(-(0.5), -(0.5), -(0.5),   1, 0);
    vertex(-(0.5),  (0.5), -(0.5),   1, 1);
    vertex( (0.5),  (0.5), -(0.5),   0, 1);
  endShape(CLOSE);

  // left
  beginShape(QUADS);
    texture(_t4);
    vertex(-(0.5), -(0.5), -(0.5),   0, 0);
    vertex(-(0.5), -(0.5),  (0.5),   1, 0);
    vertex(-(0.5),  (0.5),  (0.5),   1, 1);
    vertex(-(0.5),  (0.5), -(0.5),   0, 1);
  endShape(CLOSE);

  // right
  beginShape(QUADS);
    texture(_t2);
    vertex( (0.5), -(0.5),  (0.5),   0, 0);
    vertex( (0.5), -(0.5), -(0.5),   1, 0);
    vertex( (0.5),  (0.5), -(0.5),   1, 1);
    vertex( (0.5),  (0.5),  (0.5),   0, 1);
  endShape(CLOSE);

  // top
  beginShape(QUADS);
    texture(_t5);
    vertex(-(0.5), -(0.5), -(0.5),   0, 0);
    vertex( (0.5), -(0.5), -(0.5),   1, 0);
    vertex( (0.5), -(0.5),  (0.5),   1, 1);
    vertex(-(0.5), -(0.5),  (0.5),   0, 1);
  endShape(CLOSE);

  // bottom
  beginShape(QUADS);
    texture(_t6);
    vertex(-(0.5),  (0.5),  (0.5),   0, 0);
    vertex( (0.5),  (0.5),  (0.5),   1, 0);
    vertex( (0.5),  (0.5), -(0.5),   1, 1);
    vertex(-(0.5),  (0.5), -(0.5),   0, 1);
  endShape(CLOSE);

  // front
  beginShape(QUADS);
    texture(_t1);
    vertex(-(0.5), -(0.5),  (0.5),   0, 0); // x, y, z, u, v
    vertex( (0.5), -(0.5),  (0.5),   1, 0); // x, y, z, u, v
    vertex( (0.5),  (0.5),  (0.5),   1, 1); // x, y, z, u, v
    vertex(-(0.5),  (0.5),  (0.5),   0, 1); // x, y, z, u, v
  endShape(CLOSE);
}