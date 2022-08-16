import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.layout.HPolarLayout;
import hype.extended.behavior.HOrbiter3D;

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
String      whichAudioFile = "bring_me_the_horizon_oh_no.mp3"; //2pt
/*String      whichAudioFile = "asking_alexandria_the_death_of_me.mp3"; 2pts
/*String      whichAudioFile = "french_79_hometown.mp3";*/		//+2-1pt

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

String      whichImg       = pathAssets + "colorsM_02.png";
PImage      clrs;
int         clrsW;
float       clrCount;
float       clrSpeed       = 0.02; // the speed of the color change
float       clrOffset      = 0.0025; // the distance from each of the squares getting colored

// ************************************************************************************
// THIS ALL THE WORKING WITH COLOR STUFF for pyreflies

String      whichImgP       = pathAssets + "colorsM_01.png";
PImage      clrs2;
int         clrsW2;
float       clrCount2;
float       clrSpeed2       = 0.02; // the speed of the color change
float       clrOffset2     = 0.0025; // the distance from each of the squares getting colored

// ************************************************************************************

// VARS TO RENDER SOME IMAGES

boolean     letsRender     = false; // RENDER YES OR NO
int         renderModulo   = 120;    // RENDER AN IMAGE ON WHAT TEMPO ?
int         renderNum      = 0;     // FIRST IMAGE
int         renderMax      = 20;    // HOW MANY IMAGES
String      renderPATH     = "../renders_002/";

// ************************************************************************************

// LOAD IN A TEXTURES TO MAP TO A SPRITE

// back / left / right / top / bottom / front

String[]    texNames       = { "gcg.png", "gcg.png", "gcg.png", "gcg.png", "gcg.png", "gcg.png" };
int         texNamesLen    = texNames.length;
PImage[]    tex            = new PImage[texNamesLen];

// LOAD IN A TEXTURES TO MAP THE SPRITS

String[]    texNames2       = { "particle_00.png" };
int         texNamesLen2    = texNames2.length;
PImage[]    tex2            = new PImage[texNamesLen2];


// *********************************************************************************************

int         numAssets      = 1100;

int         layoutOffsetX   = 0;
int         layoutOffsetY   = 0;

HPolarLayout layout;

PVector[]   pos            = new PVector[numAssets];

// *********************************************************************************************

HOscillator masterRZ;
HOscillator masterRX;

HOscillator[] oscZ         = new HOscillator[numAssets];
HOscillator[] oscS         = new HOscillator[numAssets];

// *********************************************************************************************

int[]       myPickedAudio  = new int[numAssets];

// *********************************************************************************************
//Static rose window for the Polar window effect
PImage roseWindow;
float startRosPosX = 0.0;
float startRosPosY = 0.0;

// *********************************************************************************************
	// cooldown counter for the effect switching;
	int cooldowncnt = 0; 

// *********************************************************************************************

boolean delayTimer = false;
int delayBase = 300;
int delayCount = delayBase;


// *********************************************************************************************

//array of functions
	interface magic{
		void spell();
	}


	magic[] magics = new magic[]{
		new magic() {public void spell(){drawMusic();}   },
		new magic() {public void spell(){drawPolarWindow();}},
		new magic() {public void spell(){drawPyreflies();}}
	};
	int magicNumber = 2;
// *********************************************************************************************

void settings() {
	size(stageW, stageH, P3D);
	// fullScreen();
}

void setup() {
	H.init(this);
	background(clrBG);
	audioSetup();

	roseWindow = loadImage(pathAssets + "csg.png");

	clrs = loadImage(whichImg);
	clrsW = clrs.width-1;

	// LOAD THE TEXTURES
	for (int i = 0; i < texNamesLen; ++i) {
		tex[i] = loadImage(pathAssets + texNames[i]);
	}
	textureMode(NORMAL);

	// BUILD THE POLAR and OSC
	layout = new HPolarLayout(1, 0.2).offsetX(layoutOffsetX).offsetY(layoutOffsetY);

	for (int i = 0; i < numAssets; ++i) {
		pos[i] = layout.getNextPoint();
		myPickedAudio[i] = (int)random(12);
		// myPickedAudio[i] = i%12;

		oscZ[i]  = new HOscillator().range(-2000, 100).speed(1).freq(5).currentStep(i*0.5).waveform(H.SINE);
		oscS[i]  = new HOscillator().range(0.02, 0.2).speed(1).freq(10).currentStep(i).waveform(H.SINE);
	}
	masterRZ = new HOscillator().range(-180, 180).speed(0.1).freq(0.7).waveform(H.SINE);
	/*pyreflies*/
	clrs2 = loadImage(whichImgP);
	clrsW2 = clrs2.width-1;

	// LOAD THE TEXTURES
	for (int i = 0; i < texNamesLen2; ++i) {
		tex2[i] = loadImage(pathAssets + texNames2[i]);
	}
	textureMode(NORMAL);

	// BUILD THE 3D ORBITER and OSC

	for (int i = 0; i < numAssets2; ++i) {
		orb[i] = new HOrbiter3D()
			.startX(orbStartX)
			.startY(orbStartY)
			.startZ(orbStartZ)
			.zSpeed( random(orbZ_SpeedMin, orbZ_SpeedMax) )
			.ySpeed( random(orbY_SpeedMin, orbY_SpeedMax) )
			.radius(orbRadius)
			.zAngle( (int)random(360) )
			.yAngle( (int)random(360) )
			// .zAngle( (i*5)%360 )
			// .yAngle( (i*5)%360 )
			// .zAngle( 0 )
			// .yAngle( 0 )
		;

		myPickedAudio[i] = (int)random(12);

		oscS2[i]  = new HOscillator().range(50, 200).speed(1).freq(5).currentStep(i*5).waveform(H.SINE);
	}
	/*pyreflies end*/
}
	
void draw() {
	//background( clrBG );
	

// ************************************************************************************
//HERE I DRAW THE FUCNTIONS\\
		magics[magicNumber].spell();
	if( myAudioData[5]>=90 && !delayTimer) {
		delayTimer = true;
		magicNumber = (int)random(magics.length);
		println("fucker");
	}
	if(delayTimer) delayCount--;
	if(delayCount<=0) {
		delayCount = delayBase;
		delayTimer = false;
	}

	// if(myAudioData[5]>=90 && cooldowncnt == 0){
	// 	int cnt = 1;
	// 	cooldowncnt=25;
	// 	if (cnt == 1) {
	// 		magics[1].spell();
	// 		cnt--;
		
	// 	} else{
	// 		magics[0].spell();
	// 		cnt++;	
	// 	}
	// }
	// cooldowncnt--;

	// if (cooldowncnt < 0 ) {
	// 	cooldowncnt = 0;
	// }

	//magics[1].spell();
	//drawPolarWindow();
	//drawMusic();
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
// ************************************************************************************


