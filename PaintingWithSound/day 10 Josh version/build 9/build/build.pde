import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.layout.HGridLayout;

int         stageW           = 1920;
int         stageH           = 1080;
color       clrBG            = #000000;
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
boolean     showVisualizer   = false;

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

// String      whichImg         = pathAssets + "rainbow.png";
String      whichImg1        = pathAssets + "rainbow.png";
String      whichImg2        = pathAssets + "rainbow.png";
PImage      clrs1, clrs2;
int         clrsW;
float       clrCount1,clrCount2;
float       clrSpeed1        = 0.05; // the speed of the color change
float       clrOffset1       = 0.0025; // the distance from each of the squares getting colored

float       clrSpeed2        = 0.005; // the speed of the color change
float       clrOffset2       = 0.0005; // the distance from each of the squares getting colored

// ************************************************************************************

// VARS TO RENDER SOME IMAGES

boolean     letsRender       = false; // RENDER YES OR NO
int         renderModulo     = 120;    // RENDER AN IMAGE ON WHAT TEMPO ?
int         renderNum        = 0;     // FIRST IMAGE
int         renderMax        = 20;    // HOW MANY IMAGES
String      renderPATH       = "../renders_001/";

// ************************************************************************************

// LOAD IN A TEXTURES TO MAP TO A SPRITE

// back / left / right / top / bottom / front

String[]    texNames         = { "particle_00.png", "art_006.png" };
int         texNamesLen      = texNames.length;
PImage[]    tex              = new PImage[texNamesLen];

// *********************************************************************************************

int         gridCols         = 10; // how many columns
int         gridRows         = 10; // how many rows
int         gridDepth        = 10; // how many in z space
int         gridTotal        = gridCols * gridRows * gridDepth;
int         gridSpaceX       = 3000; // spacing between cells on x
int         gridSpaceY       = 3000; // spacing between cells on y
int         gridSpaceZ       = 3000; // spacing between cells on z
int         gridStartX       = -((gridCols-1)*(gridSpaceX/2)); // where to start grid on x axis
int         gridStartY       = -((gridRows-1)*(gridSpaceY/2)); // where to start grid on y axis
int         gridStartZ       = -((gridDepth-1)*(gridSpaceZ/2)); // where to start grid on y axis

HGridLayout layout;

PVector[]   pos = new PVector[gridTotal];

// *********************************************************************************************

HOscillator masterRX, masterRY, masterRZ, masterP;

HOscillator[] oscX  = new HOscillator[gridTotal];
HOscillator[] oscY  = new HOscillator[gridTotal];
HOscillator[] oscZ  = new HOscillator[gridTotal];
HOscillator[] oscRX = new HOscillator[gridTotal];
HOscillator[] oscRY = new HOscillator[gridTotal];
HOscillator[] oscRZ = new HOscillator[gridTotal];
HOscillator[] oscS  = new HOscillator[gridTotal];

// *********************************************************************************************

int[]       myPickedAudio = new int[gridTotal];

// *********************************************************************************************


void settings() {
	size(stageW, stageH, P3D);
	fullScreen();
}

void setup() {
	H.init(this);
	background(clrBG);
	audioSetup();

	clrs1 = loadImage(whichImg1);
	clrs2 = loadImage(whichImg2);
	clrsW = clrs1.width-1;

	// LOAD THE TEXTURES
	for (int i = 0; i < texNamesLen; ++i) {
		tex[i] = loadImage(pathAssets + texNames[i]);
	}
	textureMode(NORMAL);

	// BUILD THE GRID and OSC
	layout = new HGridLayout().startLoc(gridStartX, gridStartY, gridStartZ).spacing(gridSpaceX, gridSpaceY, gridSpaceZ).cols(gridCols).rows(gridRows);
	for (int i = 0; i < gridTotal; ++i) {
		pos[i] = layout.getNextPoint();

		oscX[i]  = new HOscillator().range(-900, 900).speed(1).freq(5).currentStep(i*1).waveform(H.SINE);
		oscY[i]  = new HOscillator().range(-900, 900).speed(1).freq(10).currentStep(i*2).waveform(H.SINE);
		oscZ[i]  = new HOscillator().range(-300, 300).speed(1).freq(5).currentStep(i*5).waveform(H.EASE);
		oscRX[i] = new HOscillator().range(-180, 180).speed(1).freq(1).currentStep(i*3).waveform(H.SINE);
		oscRY[i] = new HOscillator().range(-180, 180).speed(1).freq(1).currentStep(i*3).waveform(H.SINE);
		oscRZ[i] = new HOscillator().range(-180, 180).speed(1).freq(1).currentStep(i*3).waveform(H.SINE);
		oscS[i]  = new HOscillator().range(200, 2000).speed(1).freq(5).currentStep(i*5).waveform(H.SINE);

		myPickedAudio[i] = (int)random(12);
	}

	masterRX = new HOscillator().range(-180, 180).speed(0.1).freq(0.9).waveform(H.SINE);
	masterRY = new HOscillator().range(-180, 180).speed(0.1).freq(0.8).waveform(H.SINE);
	masterRZ = new HOscillator().range(-180, 180).speed(0.1).freq(0.7).waveform(H.SINE);

	masterP = new HOscillator().range(1.25, 4.0).speed(0.2).freq(5).waveform(H.SINE);
}

void draw() {
	//background( clrBG );

// ************************************************************************************

	masterRX.nextRaw();
	masterRY.nextRaw();
	masterRZ.nextRaw();

	float _MS = map(myAudioData[ myPickedAudio[0] ], 0, myAudioMax, 0.05, 0.75);
	masterP.speed(_MS);
	masterP.nextRaw();

	push();
		translate(stageW/2, stageH/2, 0);

		perspective(PI/masterP.curr(), (float)(width*2)/(height*2), 0.1, 1000000);

		rotateX(radians(masterRX.curr()));
		rotateY(radians(masterRY.curr()));
		rotateZ(radians(masterRZ.curr()));

		for (int i = 0; i < gridTotal; ++i) {

			HOscillator _oscX = oscX[i];
			float _aX = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.0, 1.0);
			_oscX.speed(_aX);
			_oscX.nextRaw(); 

			HOscillator _oscY = oscY[i];
			float _aY = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.0, 1.0);
			_oscY.speed(_aY);
			_oscY.nextRaw(); 

			HOscillator _oscZ = oscZ[i];
			float _aZ = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.1, 1.0);
			_oscZ.speed(_aZ);
			_oscZ.nextRaw(); 

			HOscillator _oscRX = oscRX[i];
			float _aRX = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.0, 0.75);
			_oscRX.speed(_aRX);
			_oscRX.nextRaw(); 

			HOscillator _oscRY = oscRY[i];
			float _aRY = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.0, 0.5);
			_oscRY.speed(_aRY);
			_oscRY.nextRaw(); 

			HOscillator _oscRZ = oscRZ[i];
			float _aRZ = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.0, 0.25);
			_oscRZ.speed(_aRZ);
			_oscRZ.nextRaw(); 

			HOscillator _oscS = oscS[i];
			float _aS = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.0, 2.0);
			_oscS.speed(_aS);
			_oscS.nextRaw(); 

			float wave1 = sin( clrCount1+(i*clrOffset1) );
			float waveMap1 = map(wave1, -1, 1, 0, clrsW);

			float wave2 = sin( clrCount2+(i*clrOffset2) );
			float waveMap2 = map(wave2, -1, 1, 0, clrsW);

			push();
				translate(pos[i].x + _oscX.curr(), pos[i].y + _oscY.curr(), pos[i].z + _oscZ.curr() );
				scale(_oscS.curr());

				rotateX(radians(_oscRX.curr()));
				rotateY(radians(_oscRY.curr()));
				rotateZ(radians(_oscRZ.curr()));

				tint( clrs1.get((int)waveMap1,0), 255 );

				buildCube(tex[0], tex[0], tex[0], tex[0], tex[0], tex[0]);
			pop();

			noTint();

			push();
				translate(pos[i].x + _oscX.curr(), pos[i].y + _oscY.curr(), pos[i].z + _oscZ.curr() );
				scale(_oscS.curr()+300);

				rotateX(radians(_oscRX.curr()));
				rotateY(radians(_oscRY.curr()));
				rotateZ(radians(_oscRZ.curr()));

				tint( clrs2.get((int)waveMap2,0), 255 );

				buildCube(tex[1], tex[1], tex[1], tex[1], tex[1], tex[1]);
			pop();
		}
	pop();

// ************************************************************************************

	noLights();
	audioUpdate();
	clrCount1 += clrSpeed1;
	clrCount2 += clrSpeed2;

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
