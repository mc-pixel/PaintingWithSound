import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.layout.HPolarLayout;

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
//array of functions
	interface magic{
		void spell();
	}


	magic[] magics = new magic[]{
		new magic() {public void spell(){drawMusic();}   },
		new magic() {public void spell(){drawPolarWindow();}}
	};
// *********************************************************************************************

void settings() {
	size(stageW, stageH, P3D);
	fullScreen();
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
	//addedthis
}
	
void draw() {
	//background( clrBG );
	

// ************************************************************************************
//HERE I DRAW THE FUCNTIONS
while
	if(myAudioData[5]>=90 && cooldowncnt == 0){
		int cnt = 1;
		if (cnt == 1) {
			magics[1].spell();
			cnt--;
		} else{
			magics[0].spell();
			cnt++;	
		}
	}
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

void drawPolarWindow(){
	masterRZ.nextRaw();

	push();
		translate(stageW/2, stageH/2, 0);
		perspective(PI/3.0, (float)(width*2)/(height*2), 0.1, 1000000);
		rotateZ(radians(masterRZ.curr()));

		for (int i = 0; i < numAssets; ++i) {

			HOscillator _oscZ = oscZ[i];
			float _aZ = map(myAudioData[ 0 ], 0, myAudioMax, 0.2, 1.0);
			_oscZ.speed(_aZ);
			_oscZ.nextRaw(); 

			HOscillator _oscS = oscS[i];
			float _aS = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.05, 2.0);
			_oscS.speed(_aS);
			_oscS.nextRaw(); 

			push();
				translate(pos[i].x, pos[i].y, pos[i].z + _oscZ.curr() );
				float d = dist(layout.offsetX(), layout.offsetY(), pos[i].x, pos[i].y);
				scale(d * _oscS.curr() );

				float wave = sin( clrCount+(i*clrOffset) );
				float waveMap = map(wave, -1, 1, 0, clrsW);
				tint( clrs.get((int)waveMap,0), 255 );

				buildCube(tex[0], tex[1], tex[2], tex[3], tex[4], tex[5]);
			pop();
		}
	pop();

	push();
		translate((stageW/2)-(roseWindow.width/2), (stageH/2)-(roseWindow.height/2), 0);
		//perspective(PI/3.0, (float)(width*2)/(height*2), 0.1, 1000000);
		hint(DISABLE_DEPTH_TEST);
		strokeWeight(0);
		noStroke();
		fill(#FF3300, 245);
		// ellipse(0, 0, 300, 300);
		image(roseWindow, startRosPosX,startRosPosY);
		for (int i = 0; i < 10000; ++i)  {
			rotate(radians(i));
		}
		hint(ENABLE_DEPTH_TEST);
	pop();
} 

void drawMusic(){
	showVisualizer = true;
	for (int i = 0; i < stageH/4; ++i) {
		audioUpdate();
		translate(0,(0.5+i));
		audioUpdate();
	}
}