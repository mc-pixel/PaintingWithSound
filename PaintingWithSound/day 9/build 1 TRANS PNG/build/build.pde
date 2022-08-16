int         stageW           = 1000;
int         stageH           = 1000;
color       clrBG            = #ECECEC;
String      pathAssets       = "../../../assets/";

// ************************************************************************************

// THIS IS THE AUDIO VARS

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
AudioPlayer myAudioPlayer;
String      whichAudioFile   = "AUDIO.wav";

AudioInput  myAudioInput;
boolean     myAudioToggle    = true; // true = myAudioPlayer / false = myAudioInput
boolean     showVisualizer   = false;

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

// LETS USE THE CIRCLE LAYOUT

import hype.*;
import hype.extended.layout.HCircleLayout;

int         numAssets        = myAudioRange;

PVector[]pos                 = new PVector[numAssets];

int         layoutRadius     = 200;
int         layoutStartX     = 0;
int         layoutStartY     = 0;
float       layoutStep       = 360.0/numAssets;

HCircleLayout layout;

float       rectW            = 3.0;

// *********************************************************************************************

// VARS TO RENDER SOME IMAGES

boolean     letsRender       = true; // RENDER YES OR NO
int         renderModulo     = 120;    // RENDER AN IMAGE ON WHAT TEMPO ?
int         renderNum        = 0;     // FIRST IMAGE
int         renderMax        = 20;    // HOW MANY IMAGES
String      renderPATH       = "../renders_001/";

// *********************************************************************************************

PGraphics   layer1;

// *********************************************************************************************

void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	H.init(this);
	background(clrBG);
	audioSetup();

	layer1 = createGraphics(stageW,stageH,P3D);

	clrs = loadImage(whichImg);
	clrsW = clrs.width-1;

	layout = new HCircleLayout()
		.startX(layoutStartX)
		.startY(layoutStartY)
		.radius(layoutRadius)
		.angleStep(layoutStep)
	;

	for (int i = 0; i < numAssets; ++i) {
		pos[i] = layout.getNextPoint();
	}
}

void draw() {
	// background( clrBG );
	audioUpdate();

// ************************************************************************************

	layer1.beginDraw();

		layer1.strokeWeight(0);
		layer1.noStroke();

		layer1.push();
			layer1.translate(stageW/2, stageH/2);
			layer1.rotate(radians(-90));

			layer1.lights();

			for (int i = 0; i < numAssets; ++i) {
				layer1.push();
					layer1.translate(pos[i].x, pos[i].y, pos[i].z);
					layer1.rotate( radians(90)+(layout.angleStepRad()*i) );

					float wave = sin( clrCount+(i*clrOffset) );
					float waveMap = map(wave, -1, 1, 0, clrsW);
					layer1.fill( clrs.get( (int)waveMap,0 ) );

					int hMap = (int)map(myAudioData[i], 0, myAudioMax, rectW,  300);
					layer1.box(5, 5, hMap*5);
				layer1.pop();
			}
		layer1.pop();
	layer1.endDraw();

	// PAINT THE TRANSPARENT IMAGE

	image(layer1, 0, 0);

// ************************************************************************************

	clrCount += clrSpeed;

	noLights();

	if(frameCount%(renderModulo)==0 && letsRender) {
		layer1.save(renderPATH + renderNum + ".png");
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


