int         stageW           = 1000;
int         stageH           = 1000;
color       clrBG            = #111111;
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

PImage      tex1, tex2, tex3, tex4, tex5, tex6;

// *********************************************************************************************

// THIS ALL THE WORKING WITH COLOR STUFF

String      whichImg         = pathAssets + "colors_005.png";
PImage      clrs; // image
int         clrsW; // width of image
float       clrCount;
float       clrSpeed         = 0.02; // the speed of the color change
float       clrOffset        = 0.049; // the distance from each of the squares getting colored

// *********************************************************************************************

void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	background(clrBG);
	audioSetup();

	clrs = loadImage(whichImg);
	clrsW = clrs.width-1;

	tex1 = loadImage(pathAssets + "t1.png");
	tex2 = loadImage(pathAssets + "t2.png");
	tex3 = loadImage(pathAssets + "t3.png");
	tex4 = loadImage(pathAssets + "t4.png");
	tex5 = loadImage(pathAssets + "t5.png");
	tex6 = loadImage(pathAssets + "t6.png");
}

void draw() {
	background(clrBG);
	audioUpdate();

	// lights();

	strokeWeight(0);
	noStroke();

	push();
		translate(stageW/2, stageH/2, 0);
		scale(350);

		rotateX( map(rotateNumX, 0, 270, -(TWO_PI / 20), TWO_PI / 20) );
		rotateY( map(rotateNumY, 0, 270, -(TWO_PI / 20), TWO_PI / 20) );
		rotateZ( map(rotateNumZ, 0, 270, -(TWO_PI / 20), TWO_PI / 20) );

		int fftRotate2X = (int)map(myAudioData[0], 0, myAudioMax, -2,  20); // controlled by [0] base
		int fftRotate2Y = (int)map(myAudioData[3], 0, myAudioMax, -2,  20); // controlled by [3] snare
		int fftRotate2Z = (int)map(myAudioData[5], 0, myAudioMax,  2, -20); // controlled by [5] just arbitrary

		rotateNumX += fftRotate2X;
		rotateNumY += fftRotate2Y;
		rotateNumZ += fftRotate2Z;

		buildCube(tex1, tex2, tex3, tex4, tex5, tex6); // build a cube / tell me WHICH TEXTURE b,l,r,t,b,f
	pop();

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

void buildCube(PImage _t1, PImage _t2, PImage _t3, PImage _t4, PImage _t5, PImage _t6) {
	textureMode(NORMAL);
	hint(DISABLE_DEPTH_TEST);
	hint(ENABLE_DEPTH_SORT);

	float wave = sin( clrCount );
	float waveMap = map(wave, -1, 1, 0, clrsW);

	tint( clrs.get( ((int)waveMap+0)%clrsW, 0) );

	// back
	beginShape(QUADS);
		texture(_t1);
		vertex(-(0.5), -(0.5), -(0.5),      0, 0); // x, y, z, u, v
		vertex( (0.5), -(0.5), -(0.5),      1, 0); // x, y, z, u, v
		vertex( (0.5),  (0.5), -(0.5),      1, 1); // x, y, z, u, v
		vertex(-(0.5),  (0.5), -(0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);

	tint( clrs.get( ((int)waveMap+100)%clrsW, 0) );

	// left
	beginShape(QUADS);
		texture(_t2);
		vertex(-(0.5), -(0.5),  (0.5),      0, 0); // x, y, z, u, v
		vertex(-(0.5), -(0.5), -(0.5),      1, 0); // x, y, z, u, v
		vertex(-(0.5),  (0.5), -(0.5),      1, 1); // x, y, z, u, v
		vertex(-(0.5),  (0.5),  (0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);

	tint( clrs.get( ((int)waveMap+200)%clrsW, 0) );

	// right
	beginShape(QUADS);
		texture(_t3);
		vertex( (0.5), -(0.5),  (0.5),      0, 0); // x, y, z, u, v
		vertex( (0.5), -(0.5), -(0.5),      1, 0); // x, y, z, u, v
		vertex( (0.5),  (0.5), -(0.5),      1, 1); // x, y, z, u, v
		vertex( (0.5),  (0.5),  (0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);

	tint( clrs.get( ((int)waveMap+300)%clrsW, 0) );

	// top
	beginShape(QUADS);
		texture(_t4);
		vertex(-(0.5), -(0.5),  (0.5),      0, 0); // x, y, z, u, v
		vertex(-(0.5), -(0.5), -(0.5),      1, 0); // x, y, z, u, v
		vertex( (0.5), -(0.5), -(0.5),      1, 1); // x, y, z, u, v
		vertex( (0.5), -(0.5),  (0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);

	tint( clrs.get( ((int)waveMap+400)%clrsW, 0) );

	// bottom
	beginShape(QUADS);
		texture(_t5);
		vertex(-(0.5),  (0.5),  (0.5),      0, 0); // x, y, z, u, v
		vertex(-(0.5),  (0.5), -(0.5),      1, 0); // x, y, z, u, v
		vertex( (0.5),  (0.5), -(0.5),      1, 1); // x, y, z, u, v
		vertex( (0.5),  (0.5),  (0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);

	tint( clrs.get( ((int)waveMap+500)%clrsW, 0) );

	// front
	beginShape(QUADS);
		texture(_t6);
		vertex(-(0.5), -(0.5), (0.5),      0, 0); // x, y, z, u, v
		vertex( (0.5), -(0.5), (0.5),      1, 0); // x, y, z, u, v
		vertex( (0.5),  (0.5), (0.5),      1, 1); // x, y, z, u, v
		vertex(-(0.5),  (0.5), (0.5),      0, 1); // x, y, z, u, v
	endShape(CLOSE);

	noTint();
	hint(ENABLE_DEPTH_TEST);
	hint(DISABLE_DEPTH_SORT);
}
