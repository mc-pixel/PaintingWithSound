import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.layout.HHexLayout;

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

int         numAssets      = 260;

float       layoutSpacing  = 100;
float       layoutOffsetX  = stageW/2;
float       layoutOffsetY  = stageH/2;

HHexLayout layout;

PVector[]   pos            = new PVector[numAssets];

// *********************************************************************************************

HOscillator[] oscZ         = new HOscillator[numAssets];
HOscillator[] oscS         = new HOscillator[numAssets];
HOscillator[] oscRZ        = new HOscillator[numAssets];

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

	// BUILD THE HEX and OSC
	layout = new HHexLayout().spacing(layoutSpacing).offsetX(layoutOffsetX).offsetY(layoutOffsetY);

	for (int i = 0; i < numAssets; ++i) {
		pos[i] = layout.getNextPoint();
		myPickedAudio[i] = (int)random(12);

		oscZ[i]  = new HOscillator().range(-1500, 100).speed(1).freq(5).currentStep(i*2.0).waveform(H.SINE);
		oscS[i]  = new HOscillator().range(5, 300).speed(1).freq(10).currentStep(i*5).waveform(H.SINE);
		oscRZ[i] = new HOscillator().range(-180, 180).speed(1).freq(1).currentStep(i*3).waveform(H.SINE);
	}
}

void draw() {
	background( clrBG );

// ************************************************************************************

	push();
		translate(stageW/2, stageH/2, 0);
		perspective(PI/3.0, (float)(width*2)/(height*2), 0.1, 1000000);

		for (int i = 0; i < numAssets; ++i) {

			HOscillator _oscZ = oscZ[i];
			float _aZ = map(myAudioData[ 0 ], 0, myAudioMax, 0.2, 1.0);
			_oscZ.speed(_aZ);
			_oscZ.nextRaw(); 

			HOscillator _oscS = oscS[i];
			float _aS = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.05, 0.5);
			_oscS.speed(_aS);
			_oscS.nextRaw(); 

			HOscillator _oscRZ = oscRZ[i];
			float _aRZ = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.1, 0.3);
			_oscRZ.speed(_aRZ);
			_oscRZ.nextRaw(); 

			push();
				translate(pos[i].x, pos[i].y, pos[i].z + _oscZ.curr() );
				scale(_oscS.curr());
				rotateZ(radians(_oscRZ.curr()));

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

