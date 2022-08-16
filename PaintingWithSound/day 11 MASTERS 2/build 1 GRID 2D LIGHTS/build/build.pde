import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.layout.HGridLayout;

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

String      whichImg       = pathAssets + "colors_002.png";
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

int         gridCols       = 10; // how many columns
int         gridRows       = 6; // how many rows
int         gridTotal      = gridCols * gridRows;
int         gridSpaceX     = 200; // spacing between cells on x
int         gridSpaceY     = 200; // spacing between cells on y
int         gridStartX     = -((gridCols-1)*(gridSpaceX/2)); // where to start grid on x axis
int         gridStartY     = -((gridRows-1)*(gridSpaceY/2)); // where to start grid on y axis

HGridLayout layout;

PVector[]   pos            = new PVector[gridTotal];

// *********************************************************************************************

HOscillator lightX, lightY, lightZ;

HOscillator[] oscS         = new HOscillator[gridTotal];
HOscillator[] oscZ         = new HOscillator[gridTotal];

// *********************************************************************************************

int[]       myPickedAudio  = new int[gridTotal];

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

	// BUILD THE GRID and OSC
	layout = new HGridLayout().startLoc(gridStartX, gridStartY).spacing(gridSpaceX, gridSpaceY).cols(gridCols);

	for (int i = 0; i < gridTotal; ++i) {
		pos[i] = layout.getNextPoint();
		myPickedAudio[i] = (int)random(12);

		oscS[i]  = new HOscillator().range(175, 175).speed(1).freq(5).currentStep(i*5).waveform(H.SINE);
		oscZ[i]  = new HOscillator().range(-1500, 100).speed(1).freq(5).currentStep(i*5).waveform(H.SINE);
	}

	lightX = new HOscillator().range(-1000, 1000).speed(0.1).freq(4).waveform(H.SINE);
	lightY = new HOscillator().range(-1000, 1000).speed(0.1).freq(8).waveform(H.SINE);
	lightZ = new HOscillator().range(-1000, 1000).speed(0.1).freq(10).waveform(H.SINE);
}

void draw() {
	background( clrBG );

	float wave = sin( clrCount );
	float waveMap = map(wave, -1, 1, 0, clrsW);

	color c1 = clrs.get((int)waveMap,0);          // get the color from image 1
	color r1 = (c1 >>> 16) & 255;                 // grab just the RED value from this color
	color g1 = (c1 >>>  8) & 255;                 // grab just the GREEN value from this color
	color b1 = c1 & 255;                          // grab just the BLUE value from this color

	lightX.nextRaw();
	lightY.nextRaw();
	lightZ.nextRaw();

	push();
		translate((stageW/2)+lightX.curr(), (stageH/2)+lightY.curr(), lightZ.curr());
		sphere(20);
	pop();

	pointLight(r1, g1, b1,    (stageW/2)+lightX.curr(), (stageH/2)+lightY.curr(), lightZ.curr() ); // RGB XYZ

// ************************************************************************************

	push();
		translate(stageW/2, stageH/2, 0);
		perspective(PI/3.0, (float)(width*2)/(height*2), 0.1, 1000000);

		for (int i = 0; i < gridTotal; ++i) {

			HOscillator _oscS = oscS[i];
			float _aS = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.0, 2.0);
			_oscS.speed(_aS);
			_oscS.nextRaw(); 

			HOscillator _oscZ = oscZ[i];
			float _aZ = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.0, 2.0);
			_oscZ.speed(_aZ);
			_oscZ.nextRaw(); 

			push();
				translate(pos[i].x, pos[i].y, pos[i].z+_oscZ.curr() );
				scale(_oscS.curr());

				// float wave3 = sin( clrCount+(i*clrOffset) );
				// float waveMap3 = map(wave3, -1, 1, 0, clrsW);
				// tint( clrs.get((int)waveMap3,0), 255 );

				tint( 255, 225 );

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
