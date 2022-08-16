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

int         myAudioRange     = 32; // 256 / 128(2) / 64(4) / 32(8) / 16(16)
int         myAudioMax       = 100;

float       myAudioAmp;
float       myAudioIndex;
float       myAudioIndexAmp;
float       myAudioIndexStep;

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

int numAssets = 125;
PVector[] pos = new PVector[numAssets];
int[] myPickedAudio = new int[numAssets];

// *********************************************************************************************
void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	background(clrBG);
	audioSetup();

	clrs = loadImage(whichImg);
	clrsW = clrs.width-1;

	for (int i = 0; i < numAssets; ++i) {
		pos[i]	= new PVector();
		pos[i].x = (int)random(stageW);
		pos[i].y = (int)random(stageH);

		myPickedAudio[i] = (int)random(12);
		
	}

}

void draw() {
	background( clrBG );
	audioUpdate();



// ************************************************************************************
	strokeWeight(0);
	noStroke();
	for (int i = 0; i < numAssets; ++i) {
		push();
		translate(pos[i].x,pos[i].y,pos[i].z);
		float wave = sin( clrCount + (i*clrOffset) );
		float waveMap = map(wave, -1, 1, 0, clrsW);
		fill(clrs.get( (int)waveMap,0),127);

		int sMap = (int)map(myAudioData[myPickedAudio[i]],0,myAudioMax,50,200);
		rect(-(sMap/2),-(sMap/2),sMap,sMap);


		pop();
		
	}





// ************************************************************************************


	surface.setTitle( myAudioAmp + " - " + myAudioIndex + " - " + myAudioIndexStep );

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
