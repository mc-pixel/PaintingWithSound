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
String      whichAudioFile   = "AUDIO.wav";

AudioInput  myAudioInput;
boolean     myAudioToggle    = true; // true = myAudioPlayer / false = myAudioInput
boolean     showVisualizer   = true;

FFT         myAudioFFT;

int         myAudioRange     = 256; // 256 / 128(2) / 64(4) / 32(8) / 16(16)
int         myAudioMax       = 100;

float       myAudioAmp       = 20.0;
float       myAudioIndex     = 0.05;
float       myAudioIndexAmp  = myAudioIndex;
float       myAudioIndexStep = 0.025;

float[]     myAudioData      = new float[myAudioRange]; // KEEP A RECORD OF ALL THE NUMBERS IN AN ARRAY

// ************************************************************************************

// THIS IS THE VARS FOR THE RECTS

float       visX             = 1.0;
float       visY             = 1.0;
float       visW             = ((float(stageW)-(visX*2))-(float(myAudioRange)-1)) / float(myAudioRange);
float       visH             = 2.0;
float       visS             = (float(stageW)-(visX*2)) / float(myAudioRange);

int         rotateNumX       = 0;
int         rotateNumY       = 0;
int         rotateNumZ       = 0;

// *********************************************************************************************

// THIS ALL THE WORKING WITH COLOR STUFF

String      whichImg         = pathAssets + "rainbow.png";
PImage      clrs; // image
int         clrsW; // width of image
float       clrCount;
float       clrSpeed         = 0.02; // the speed of the color change
float       clrOffset        = 0.049; // the distance from each of the squares getting colored

// *********************************************************************************************

//lets use circle layout

import hype.*;
import hype.extended.layout.HCircleLayout;

int numAssets = myAudioRange;
PVector[]pos  =	new PVector[numAssets];


int layoutRadius	=	150;
int layoutStartX	=	stageH/2;
int layoutStartY	=	stageW/2;
float layoutStep	=	360.0/numAssets;

HCircleLayout layout;

float rectW = 3.0;

//**********************************************************************************************

void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	H.init(this);
	background(clrBG);
	audioSetup();

	clrs = loadImage(whichImg);
	clrsW = clrs.width-1;

	layout = new HCircleLayout().startX(layoutStartX).startY(layoutStartY).radius(layoutRadius).angleStep(layoutStep);

	for (int i = 0; i < numAssets; ++i) {
		pos[i] = layout.getNextPoint();
	}



}

void draw() {
	background( clrBG );
	audioUpdate();

	/*float wave = sin( clrCount );
	float waveMap = map(wave, -1, 1, 0, clrsW);*/

// ************************************************************************************

for (int i = 0; i < numAssets; ++i) {
	push();
		translate(pos[i].x,pos[i].y,pos[i].z);
		rotate(radians(90)+(layout.angleStepRad()*i));
		float wave 	  = sin(clrCount + (i*clrOffset));
		float waveMap = map(wave,-1,1,0,clrsW);
		fill(clrs.get((int)waveMap,0));
		int hMap =  (int)map(myAudioData[i],0,myAudioMax,rectW,300);
		rect(-(rectW/2),-(hMap),rectW,hMap);

	pop();
}





// ************************************************************************************

	clrCount += clrSpeed;
}

// ************************************************************************************

void keyPressed() {
	switch (key) {
		case '1': if(!myAudioToggle){myAudioInput.close();} myAudioToggle = true;  minim.stop(); audioSetup(); break; // audioPlayer
		case '2': if(myAudioToggle){myAudioPlayer.close();} myAudioToggle = false; minim.stop(); audioSetup(); break; // audioInput

		case 's': myAudioPlayer.pause();  break;
		case 'p': myAudioPlayer.play();   break;
		case 'm': myAudioPlayer.mute();   break;
		case 'u': myAudioPlayer.unmute(); break;

		case 'v': showVisualizer = !showVisualizer; break;
	}
}

// ************************************************************************************
