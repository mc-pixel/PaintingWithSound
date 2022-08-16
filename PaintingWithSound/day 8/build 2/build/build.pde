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

float       myAudioAmp       = 40.0;
float       myAudioIndex     = 0.2;
float       myAudioIndexAmp  = myAudioIndex;
float       myAudioIndexStep = 0.30;

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

// THIS IS THE TEXTURE SPRITE STUFF

PImage tex1, tex2, tex3, tex4, tex5, tex6;

// *********************************************************************************************

void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	background(clrBG);
	audioSetup();

	tex1 = loadImage(pathAssets + "tex1.png");
	tex2 = loadImage(pathAssets + "tex2.png");
	tex3 = loadImage(pathAssets + "tex3.png");
	tex4 = loadImage(pathAssets + "tex4.png");
	tex5 = loadImage(pathAssets + "tex5.png");
	tex6 = loadImage(pathAssets + "tex6.png");
}

void draw() {
	background(clrBG);
	audioUpdate();

	lights();

	strokeWeight(0);
	noStroke();
	tint(#0095A8);

	push();
		translate(stageW/2, stageH/2, 0);
		scale(350);

		rotateX( map(rotateNumX, 0, 180, -(TWO_PI / 20), TWO_PI / 20) );
		rotateY( map(rotateNumY, 0, 180, -(TWO_PI / 20), TWO_PI / 20) );
		rotateZ( map(rotateNumZ, 0, 180, -(TWO_PI / 20), TWO_PI / 20) );

		int fftRotateX = (int)map(myAudioData[0], 0, myAudioMax, -2,  20); // controlled by [0] base
		int fftRotateY = (int)map(myAudioData[3], 0, myAudioMax, -2,  20); // controlled by [3] snare
		int fftRotateZ = (int)map(myAudioData[5], 0, myAudioMax,  2, -20); // controlled by [5] just arbitrary

		rotateNumX += fftRotateX;
		rotateNumY += fftRotateY;
		rotateNumZ += fftRotateZ;

		buildCube(tex1, tex2, tex3, tex4, tex5, tex6); // build a cube / tell me WHICH TEXTURE b,l,r,t,b,f
	pop();
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
	textureMode(NORMAL);
	hint(DISABLE_DEPTH_TEST);

	// back
	beginShape(QUADS);
		texture(_t1);
		vertex(-(0.5), -(0.5), -(0.5),      0, 0); // x, y, z, u, v
		vertex( (0.5), -(0.5), -(0.5),      1, 0); // x, y, z, u, v
		vertex( (0.5),  (0.5), -(0.5),      1, 1); // x, y, z, u, v
		vertex(-(0.5),  (0.5), -(0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);

	// left
	beginShape(QUADS);
		texture(_t2);
		vertex(-(0.5), -(0.5),  (0.5),      0, 0); // x, y, z, u, v
		vertex(-(0.5), -(0.5), -(0.5),      1, 0); // x, y, z, u, v
		vertex(-(0.5),  (0.5), -(0.5),      1, 1); // x, y, z, u, v
		vertex(-(0.5),  (0.5),  (0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);

	// right
	beginShape(QUADS);
		texture(_t3);
		vertex( (0.5), -(0.5),  (0.5),      0, 0); // x, y, z, u, v
		vertex( (0.5), -(0.5), -(0.5),      1, 0); // x, y, z, u, v
		vertex( (0.5),  (0.5), -(0.5),      1, 1); // x, y, z, u, v
		vertex( (0.5),  (0.5),  (0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);

	// top
	beginShape(QUADS);
		texture(_t4);
		vertex(-(0.5), -(0.5),  (0.5),      0, 0); // x, y, z, u, v
		vertex(-(0.5), -(0.5), -(0.5),      1, 0); // x, y, z, u, v
		vertex( (0.5), -(0.5), -(0.5),      1, 1); // x, y, z, u, v
		vertex( (0.5), -(0.5),  (0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);

	// bottom
	beginShape(QUADS);
		texture(_t5);
		vertex(-(0.5),  (0.5),  (0.5),      0, 0); // x, y, z, u, v
		vertex(-(0.5),  (0.5), -(0.5),      1, 0); // x, y, z, u, v
		vertex( (0.5),  (0.5), -(0.5),      1, 1); // x, y, z, u, v
		vertex( (0.5),  (0.5),  (0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);

	// front
	beginShape(QUADS);
		texture(_t6);
		vertex(-(0.5), -(0.5), (0.5),      0, 0); // x, y, z, u, v
		vertex( (0.5), -(0.5), (0.5),      1, 0); // x, y, z, u, v
		vertex( (0.5),  (0.5), (0.5),      1, 1); // x, y, z, u, v
		vertex(-(0.5),  (0.5), (0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);
}
