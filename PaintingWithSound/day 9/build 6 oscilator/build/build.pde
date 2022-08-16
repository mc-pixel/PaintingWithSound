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

int         myAudioRange     = 256; // 256 / 128(2) / 64(4) / 32(8) / 16(16)
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

import hype.*;
import hype.extended.behavior.HOscillator;

HOscillator oscX,oscY,oscZ,oscS,oscRX,oscRY,oscRZ,oscA,oscR,oscP;


// *********************************************************************************************
void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	H.init(this);
	background(clrBG);
	audioSetup();

	clrs = loadImage(whichImg);
	clrsW = clrs.width-1;

	oscR = new HOscillator().range(-180, 180).speed(0.1).freq(10).waveform(H.EASE);
	oscP = new HOscillator().range(1.1, 4.0).speed(1).freq(1).waveform(H.SINE);

	oscX = new HOscillator().range(-300, 300).speed(1).freq(1).waveform(H.SINE);//SQUARE EASE EASE
	oscY = new HOscillator().range(-150, 150).speed(1).freq(1).waveform(H.SINE);
	oscZ = new HOscillator().range(-500, 500).speed(1).freq(5).waveform(H.SINE);
	oscS = new HOscillator().range(-500, 500).speed(1).freq(10).waveform(H.SINE);
	oscA = new HOscillator().range(0, 255).speed(1).freq(10).waveform(H.SINE);


	oscRX = new HOscillator().range(-180, 180).speed(1).freq(1).waveform(H.EASE);//SQUARE EASE EASE
	oscRY = new HOscillator().range(-180, 180).speed(0.5).freq(1).waveform(H.EASE);
	oscRZ = new HOscillator().range(-180, 180).speed(0.25).freq(5).waveform(H.EASE);
}

void draw() {
	//background( clrBG );
	audioUpdate();



// ************************************************************************************
	oscR.nextRaw();
	oscP.nextRaw();

	oscX.nextRaw();
	oscY.nextRaw();
	oscZ.nextRaw();
	oscS.nextRaw();
	oscA.nextRaw();
	oscRX.nextRaw();
	oscRY.nextRaw();
	oscRZ.nextRaw();



	strokeWeight(1);
	stroke(#000000);
	//noStroke();
	float wave = sin( clrCount );
	float waveMap = map(wave, -1, 1, 0, clrsW);
	fill(clrs.get((int)waveMap,0),oscA.curr());
	lights();

	perspective(PI/oscP.curr(), (float)(width*2)/(height/2),0.1,1000000);

	push();

		translate(stageW/oscP.curr(),stageH/2,0);
		rotate(radians(oscR.curr()));
		push();
		translate(oscX.curr(),oscY.curr(),oscZ.curr());
		rotateX(radians(oscRX.curr()));
		rotateY(radians(oscRY.curr()));
		rotateZ(radians(oscRZ.curr()));
		box(10,10,oscS.curr());
		pop();
	pop();

	noLights();




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
