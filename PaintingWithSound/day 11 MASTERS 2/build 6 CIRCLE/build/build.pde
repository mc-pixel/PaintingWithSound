import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.layout.HCircleLayout;

int         stageW         = 1920;
int         stageH         = 1080;
color       clrBG          = #242424;
String      pathAssets     = "../../../assets/";

// ************************************************************************************

// THIS IS THE AUDIO VARS

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
AudioPlayer myAudioPlayer;
String      whichAudioFile = "DM2.mp3";

AudioInput  myAudioInput;
boolean     myAudioToggle  = true; // true = myAudioPlayer / false = myAudioInput
boolean     showVisualizer = false;

FFT         myAudioFFT;

int         myAudioRange   = 16; // 256 / 128(2) / 64(4) / 32(8) / 16(16)
int         myAudioMax     = 100;

float       myAudioAmp;
float       myAudioIndex;
float       myAudioIndexAmp;
float       myAudioIndexStep;

boolean     useTimeCodes     = false;
int[]       timeCode         = {0, 10000, 20000, 30000};
int         timeCodeLength   = timeCode.length;
int         timeCodePosition = 0;
int         timeCodeFuture   = timeCodePosition+1;

float[]     myAudioData    = new float[myAudioRange]; // KEEP A RECORD OF ALL THE NUMBERS IN AN ARRAY

// ************************************************************************************

// THIS ALL THE WORKING WITH COLOR STUFF

String      whichImg       = pathAssets + "rainbow.png";
PImage      clrs;
int         clrsW;
float       clrCount;
float       clrSpeed       = 0.02; // the speed of the color change
float       clrOffset      = 0.0025; // the distance from each of the squares getting colored

// ************************************************************************************

// VARS TO RENDER SOME IMAGES

boolean     letsRender     = false; // RENDER YES OR NO
int         renderModulo   = 120;    // RENDER AN IMAGE ON WHAT TEMPO ?
int         renderNum      = 0;     // FIRST IMAGE
int         renderMax      = 20;    // HOW MANY IMAGES
String      renderPATH     = "../renders_001/";

// ************************************************************************************

// LOAD IN A TEXTURES TO MAP TO A SPRITE

// back / left / right / top / bottom / front

String[]    texNames       = { "square.png", "square.png", "square.png", "square.png", "square.png", "square.png" };
int         texNamesLen    = texNames.length;
PImage[]    tex            = new PImage[texNamesLen];

// *********************************************************************************************

int         numAssets      = 150;

int         layoutRadius   = 350;
int         layoutStartX   = 0;
int         layoutStartY   = 0;
float       layoutStep     = 360.0/numAssets;

HCircleLayout layout;

PVector[]   pos            = new PVector[numAssets];

// *********************************************************************************************

HOscillator masterRX, masterRY, masterRZ, masterP;

HOscillator[] oscZ         = new HOscillator[numAssets];
HOscillator[] oscS         = new HOscillator[numAssets];

// *********************************************************************************************

int[]       myPickedAudio  = new int[numAssets];

// *********************************************************************************************

void settings() {
	size(stageW, stageH, P3D);
	fullScreen();
}

void setup() {
	H.init(this);
	background(clrBG);
	audioSetup();

	clrs = loadImage(whichImg);
	clrsW = clrs.width-1;

	// LOAD THE TEXTURES
	for (int i = 0; i < texNamesLen; ++i) {
		tex[i] = loadImage(pathAssets + texNames[i]);
	}
	textureMode(NORMAL);

	// BUILD THE CIRCLE and OSC
	layout = new HCircleLayout().startLoc(layoutStartX, layoutStartY).radius(layoutRadius).angleStep(layoutStep);

	for (int i = 0; i < numAssets; ++i) {
		pos[i] = layout.getNextPoint();
		myPickedAudio[i] = (int)random(12);

		oscZ[i]  = new HOscillator().range(-1000, 1000).speed(1).freq(2).currentStep(i*10).waveform(H.SINE);
		oscS[i]  = new HOscillator().range(10, 300).speed(1).freq(10).currentStep( (int)random(1000) ).waveform(H.SINE);
	}

	masterRZ = new HOscillator().range(-180, 180).speed(0.1).freq(0.7).waveform(H.SINE);
	masterP = new HOscillator().range(1.2, 3.0).speed(0.1).freq(5).waveform(H.SINE);
}

void draw() {
	background( clrBG );

// ************************************************************************************

	masterRZ.nextRaw();

	float _MS = map(myAudioData[ myPickedAudio[0] ], 0, myAudioMax, 0.05, 0.75);
	masterP.speed(_MS);
	masterP.nextRaw();

	push();
		translate(stageW/2, stageH/2, 0);

		perspective(PI/masterP.curr(), (float)(width*2)/(height*2), 0.1, 1000000);
		rotateZ(radians(masterRZ.curr()));

		for (int i = 0; i < numAssets; ++i) {

			HOscillator _oscZ = oscZ[i];
			float _aZ = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, -0.05, 0.5);
			_oscZ.speed(_aZ);
			_oscZ.nextRaw(); 

			HOscillator _oscS = oscS[i];
			float _aS = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.05, 1.0);
			_oscS.speed(_aS);
			_oscS.nextRaw(); 

			push();
				translate(pos[i].x, pos[i].y, pos[i].z + _oscZ.curr() );
				scale(_oscS.curr());
				rotate( radians(90)+(layout.angleStepRad()*i) );

				float wave = sin( clrCount+(i*clrOffset) );
				float waveMap = map(wave, -1, 1, 0, clrsW);
				tint( clrs.get((int)waveMap,0), 255 );

				buildCube(tex[0], tex[1], tex[2], tex[3], tex[4], tex[5]);
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
		case '2': if(myAudioToggle){myAudioPlayer.close();} myAudioToggle = false; minim.stop(); audioSetup(); break; // audioInput

		case 's': myAudioPlayer.pause();  break;
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
		texture(_t1);
		vertex( (0.5), -(0.5), -(0.5),   0, 0);
		vertex(-(0.5), -(0.5), -(0.5),   1, 0);
		vertex(-(0.5),  (0.5), -(0.5),   1, 1);
		vertex( (0.5),  (0.5), -(0.5),   0, 1);
	endShape(CLOSE);

	// left
	beginShape(QUADS);
		texture(_t2);
		vertex(-(0.5), -(0.5), -(0.5),   0, 0);
		vertex(-(0.5), -(0.5),  (0.5),   1, 0);
		vertex(-(0.5),  (0.5),  (0.5),   1, 1);
		vertex(-(0.5),  (0.5), -(0.5),   0, 1);
	endShape(CLOSE);

	// right
	beginShape(QUADS);
		texture(_t3);
		vertex( (0.5), -(0.5),  (0.5),   0, 0);
		vertex( (0.5), -(0.5), -(0.5),   1, 0);
		vertex( (0.5),  (0.5), -(0.5),   1, 1);
		vertex( (0.5),  (0.5),  (0.5),   0, 1);
	endShape(CLOSE);

	// top
	beginShape(QUADS);
		texture(_t4);
		vertex(-(0.5), -(0.5), -(0.5),   0, 0);
		vertex( (0.5), -(0.5), -(0.5),   1, 0);
		vertex( (0.5), -(0.5),  (0.5),   1, 1);
		vertex(-(0.5), -(0.5),  (0.5),   0, 1);
	endShape(CLOSE);

	// bottom
	beginShape(QUADS);
		texture(_t5);
		vertex(-(0.5),  (0.5),  (0.5),   0, 0);
		vertex( (0.5),  (0.5),  (0.5),   1, 0);
		vertex( (0.5),  (0.5), -(0.5),   1, 1);
		vertex(-(0.5),  (0.5), -(0.5),   0, 1);
	endShape(CLOSE);

	// front
	beginShape(QUADS);
		texture(_t6);
		vertex(-(0.5), -(0.5),  (0.5),   0, 0); // x, y, z, u, v
		vertex( (0.5), -(0.5),  (0.5),   1, 0); // x, y, z, u, v
		vertex( (0.5),  (0.5),  (0.5),   1, 1); // x, y, z, u, v
		vertex(-(0.5),  (0.5),  (0.5),   0, 1); // x, y, z, u, v
	endShape(CLOSE);
}

