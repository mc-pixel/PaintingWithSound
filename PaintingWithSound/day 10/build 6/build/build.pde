import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.layout.HGridLayout;

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

int gridCols = 5;
int gridRows = 5;
int gridTotal = gridCols * gridRows;
int gridSpaceX = 200;
int gridSpaceY = 200;//spacing between cells Y
int gridStartX = -((gridCols-1)*(gridSpaceX/2));
int gridStartY = -((gridRows-1)*(gridSpaceY/2));// where to start grid

HGridLayout layout;
PVector[] pos = new PVector[gridTotal];

// ************************************************************************************

HOscillator[] oscX = new HOscillator[gridTotal];
HOscillator[] oscY = new HOscillator[gridTotal];
HOscillator[] oscZ = new HOscillator[gridTotal];
HOscillator[] oscRX = new HOscillator[gridTotal];
HOscillator[] oscRY = new HOscillator[gridTotal];
HOscillator[] oscRZ = new HOscillator[gridTotal];


// ************************************************************************************
//LOAD IN THE TEXTURES

String[] texNames = {"square.png","square.png","square.png","square.png","square.png","square.png"};
int  texNamesLen  = texNames.length;
PImage[]  tex     = new PImage[texNamesLen];

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


  for (int i = 0; i < texNamesLen; ++i) {
    tex[i] = loadImage(pathAssets + texNames[i]);
    }
    textureMode(NORMAL);

    //BUIL THE GRID AND THE OSCILLATORS
    layout = new HGridLayout().startX(gridStartX).startY(gridStartY).spacing(gridSpaceX,gridSpaceY).cols(gridCols);
    for (int i = 0; i < gridTotal; ++i) {
    pos[i] = new PVector();
    pos[i] = layout.getNextPoint();

     oscX[i]  = new HOscillator().range(-300, 300).speed(1).freq(1).currentStep(i*5).waveform(H.SINE);
     oscY[i]  = new HOscillator().range(-300, 300).speed(1).freq(1).currentStep(i*5).waveform(H.SINE);
     oscZ[i]  = new HOscillator().range(-600, 300).speed(1).freq(1).currentStep(i*5).waveform(H.SINE);
     oscRX[i]  = new HOscillator().range(-180, 180).speed(1).freq(1).currentStep(i*5).waveform(H.SINE);
     oscRY[i]  = new HOscillator().range(-180, 180).speed(1).freq(1).currentStep(i*5).waveform(H.SINE);
     oscRZ[i]  = new HOscillator().range(-180, 180).speed(1).freq(1).currentStep(i*5).waveform(H.SINE);

 }
}

void draw() {
  background( clrBG );

// ************************************************************************************

  //strokeWeight(1);
  //stroke(#000000);


 //lights();

  push();
    translate(stageW/2, stageH/2, 0);
    for (int i = 0; i < gridTotal; ++i) {
      HOscillator _oscX = oscX[i];
      float _aX = map(myAudioData[1],0,myAudioMax,0.0,2.0);
      _oscX.speed(_aX);
      _oscX.nextRaw();

      HOscillator _oscY = oscY[i];
      float _aY = map(myAudioData[3],0,myAudioMax,0.0,2.0);
      _oscY.speed(_aY);
      _oscY.nextRaw();

      HOscillator _oscZ = oscZ[i];
      float _aZ = map(myAudioData[0],0,myAudioMax,0.1,2.0);
      _oscZ.speed(_aZ);
      _oscZ.nextRaw();

      HOscillator _oscRX = oscRX[i];
      float _aRX = map(myAudioData[2],0,myAudioMax,0.0,1.75);
      _oscRX.speed(_aRX);
      _oscRX.nextRaw();

      HOscillator _oscRY = oscRY[i];
      float _aRY = map(myAudioData[4],0,myAudioMax,0.0,1.5);
      _oscRY.speed(_aRY);
      _oscRY.nextRaw();

      HOscillator _oscRZ = oscRZ[i];
      float _aRZ = map(myAudioData[6],0,myAudioMax,0.0,1.25);
      _oscRZ.speed(_aRZ);
      _oscRZ.nextRaw();

      push();
        translate(pos[i].x + _oscX.curr(), pos[i].y + _oscY.curr(), pos[i].z + _oscZ.curr());

        scale(150);

        rotateX(radians(_oscRX.curr()));
        rotateY(radians(_oscRY.curr()));
        rotateZ(radians(_oscRZ.curr()));

          float wave = sin( clrCount+(i*clrOffset) );
          float waveMap = map(wave, -1, 1, 0, clrsW);
          tint( clrs.get((int)waveMap,0), 255 );


        buildCube(tex[0],tex[1],tex[2],tex[3],tex[4],tex[5]);
      pop();
  }
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