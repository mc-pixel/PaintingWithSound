/* autogenerated by Processing revision 1283 on 2022-07-22 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.layout.HGridLayout;
import ddf.minim.*;
import ddf.minim.analysis.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class build extends PApplet {





int         stageW           = 1000;
int         stageH           = 1000;
int       clrBG            = 0xFF242424;
String      pathAssets       = "../../../assets/";

// ************************************************************************************

// THIS IS THE AUDIO VARS




Minim       minim;
AudioPlayer myAudioPlayer;
String      whichAudioFile   = "DM2.mp3";

AudioInput  myAudioInput;
boolean     myAudioToggle    = true; // true = myAudioPlayer / false = myAudioInput
boolean     showVisualizer   = true;

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

String      whichImg         = pathAssets + "rainbow.png";
PImage      clrs;
int         clrsW;
float       clrCount;
float       clrSpeed         = 0.02f; // the speed of the color change
float       clrOffset        = 0.02f; // the distance from each of the squares getting colored

// ************************************************************************************

// VARS TO RENDER SOME IMAGES

boolean     letsRender       = false; // RENDER YES OR NO
int         renderModulo     = 120;    // RENDER AN IMAGE ON WHAT TEMPO ?
int         renderNum        = 0;     // FIRST IMAGE
int         renderMax        = 20;    // HOW MANY IMAGES
String      renderPATH       = "../renders_001/";

// ************************************************************************************

// LOAD IN A TEXTURES TO MAP TO A SPRITE

String[]    texNames         = { "square.png", "square.png", "square.png", "square.png", "square.png", "square.png" };
int         texNamesLen      = texNames.length;
PImage[]    tex              = new PImage[texNamesLen];

// *********************************************************************************************

int         gridCols         = 5; // how many columns
int         gridRows         = 5; // how many rows
int         gridTotal        = gridCols * gridRows;
int         gridSpaceX       = 200; // spacing between cells on x
int         gridSpaceY       = 200; // spacing between cells on y
int         gridStartX       = -((gridCols-1)*(gridSpaceX/2)); // where to start grid on x axis
int         gridStartY       = -((gridRows-1)*(gridSpaceY/2)); // where to start grid on y axis

HGridLayout layout;

PVector[]   pos = new PVector[gridTotal];

// *********************************************************************************************

HOscillator[] oscZ = new HOscillator[gridTotal];

// *********************************************************************************************

 public void settings() {
	size(stageW, stageH, P3D);
}

 public void setup() {
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
	layout = new HGridLayout().startX(gridStartX).startY(gridStartY).spacing(gridSpaceX, gridSpaceY).cols(gridCols);
	for (int i = 0; i < gridTotal; ++i) {
		pos[i] = layout.getNextPoint();

		oscZ[i] = new HOscillator().range(-600, 300).speed(1).freq(1).currentStep(i*5).waveform(H.SINE);
	}

}

 public void draw() {
	background( clrBG );

// ************************************************************************************

	push();
		translate(stageW/2, stageH/2, 0);

		for (int i = 0; i < gridTotal; ++i) {

			HOscillator _oscZ = oscZ[i];
			float _aZ = map(myAudioData[0], 0, myAudioMax, 0.1f, 2.0f);
			_oscZ.speed(_aZ);
			_oscZ.nextRaw(); 

			push();
				translate(pos[i].x, pos[i].y, pos[i].z + _oscZ.curr() );
				scale(150);

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

 public void keyPressed() {
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

 public void buildCube(PImage _t1, PImage _t2, PImage _t3, PImage _t4, PImage _t5, PImage _t6) {
	strokeWeight(0);
	noStroke();

	// back
	beginShape(QUADS);
		texture(_t3);
		vertex( (0.5f), -(0.5f), -(0.5f),   0, 0);
		vertex(-(0.5f), -(0.5f), -(0.5f),   1, 0);
		vertex(-(0.5f),  (0.5f), -(0.5f),   1, 1);
		vertex( (0.5f),  (0.5f), -(0.5f),   0, 1);
	endShape(CLOSE);

	// left
	beginShape(QUADS);
		texture(_t4);
		vertex(-(0.5f), -(0.5f), -(0.5f),   0, 0);
		vertex(-(0.5f), -(0.5f),  (0.5f),   1, 0);
		vertex(-(0.5f),  (0.5f),  (0.5f),   1, 1);
		vertex(-(0.5f),  (0.5f), -(0.5f),   0, 1);
	endShape(CLOSE);

	// right
	beginShape(QUADS);
		texture(_t2);
		vertex( (0.5f), -(0.5f),  (0.5f),   0, 0);
		vertex( (0.5f), -(0.5f), -(0.5f),   1, 0);
		vertex( (0.5f),  (0.5f), -(0.5f),   1, 1);
		vertex( (0.5f),  (0.5f),  (0.5f),   0, 1);
	endShape(CLOSE);

	// top
	beginShape(QUADS);
		texture(_t5);
		vertex(-(0.5f), -(0.5f), -(0.5f),   0, 0);
		vertex( (0.5f), -(0.5f), -(0.5f),   1, 0);
		vertex( (0.5f), -(0.5f),  (0.5f),   1, 1);
		vertex(-(0.5f), -(0.5f),  (0.5f),   0, 1);
	endShape(CLOSE);

	// bottom
	beginShape(QUADS);
		texture(_t6);
		vertex(-(0.5f),  (0.5f),  (0.5f),   0, 0);
		vertex( (0.5f),  (0.5f),  (0.5f),   1, 0);
		vertex( (0.5f),  (0.5f), -(0.5f),   1, 1);
		vertex(-(0.5f),  (0.5f), -(0.5f),   0, 1);
	endShape(CLOSE);

	// front
	beginShape(QUADS);
		texture(_t1);
		vertex(-(0.5f), -(0.5f),  (0.5f),   0, 0); // x, y, z, u, v
		vertex( (0.5f), -(0.5f),  (0.5f),   1, 0); // x, y, z, u, v
		vertex( (0.5f),  (0.5f),  (0.5f),   1, 1); // x, y, z, u, v
		vertex(-(0.5f),  (0.5f),  (0.5f),   0, 1); // x, y, z, u, v
	endShape(CLOSE);
}

// ************************************************************************************

// THIS IS THE VARS FOR THE RECTS IN THE VISUALIZER

float visX = 1.0f;
float visY = 1.0f;
float visW = ((PApplet.parseFloat(stageW)-(visX*2))-(PApplet.parseFloat(myAudioRange)-1)) / PApplet.parseFloat(myAudioRange);
float visH = 2.0f;
float visS = (PApplet.parseFloat(stageW)-(visX*2)) / PApplet.parseFloat(myAudioRange);

// ************************************************************************************

 public void audioSetup() {
	switch (myAudioRange) {
		case 16 :
			myAudioAmp       = 40.0f;
			myAudioIndex     = 0.2f;
			myAudioIndexStep = 0.30f;
			break;
		case 32 :
			myAudioAmp       = 30.0f;
			myAudioIndex     = 0.17f;
			myAudioIndexStep = 0.225f;
			break;
		case 64 :
			myAudioAmp       = 25.0f;
			myAudioIndex     = 0.125f;
			myAudioIndexStep = 0.175f;
			break;
		case 128 :
			myAudioAmp       = 30.0f;
			myAudioIndex     = 0.075f;
			myAudioIndexStep = 0.05f;
			break;
		case 256 : default :
			myAudioAmp       = 20.0f;
			myAudioIndex     = 0.05f;
			myAudioIndexStep = 0.025f;
			break;
	}
	myAudioIndexAmp  = myAudioIndex;

	minim = new Minim(this);

	if (myAudioToggle) {
		myAudioPlayer = minim.loadFile(pathAssets + whichAudioFile);
		myAudioPlayer.loop();
		// myAudioPlayer.mute();
		myAudioFFT = new FFT(myAudioPlayer.bufferSize(), myAudioPlayer.sampleRate());
		myAudioFFT.linAverages(myAudioRange);
		myAudioFFT.window(FFT.GAUSS);
	} else {
		myAudioInput = minim.getLineIn(Minim.MONO);
		myAudioFFT = new FFT(myAudioInput.bufferSize(), myAudioInput.sampleRate());
		myAudioFFT.linAverages(myAudioRange);
		myAudioFFT.window(FFT.NONE);
	}

}

// ************************************************************************************

 public void audioUpdate() {
	hint(DISABLE_DEPTH_TEST);
	noLights();
	perspective(PI/3.0f, (float)(width*2)/(height*2), 0.1f, 1000000);

	if (myAudioToggle) myAudioFFT.forward(myAudioPlayer.mix);
	else               myAudioFFT.forward(myAudioInput.mix);

	if(showVisualizer) {
		strokeWeight(0);
		noStroke();
		fill(0xFF000000, 245);
		rect(visX, visY, stageW, myAudioMax+30);
	}

	for (int i = 0; i < myAudioRange; ++i) {
		strokeWeight(0);
		noStroke();

		float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
		myAudioIndexAmp+=myAudioIndexStep;
		float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
		myAudioData[i]     = tempIndexCon; // RECODE THE NUMBERS FROM - 0 TO 100

		if (showVisualizer) {
			if(tempIndexCon<=visH)                         fill(0xFF333333); // NO AUDIO
			else if(tempIndexCon>visH && tempIndexCon<=10) fill(0xFF2EA893); // visH to 10
			else if(tempIndexCon>10 && tempIndexCon<=20)   fill(0xFF64BE7A); // 11 to 20
			else if(tempIndexCon>20 && tempIndexCon<=30)   fill(0xFF9AD561); // 21 to 30
			else if(tempIndexCon>30 && tempIndexCon<=40)   fill(0xFFCCEA4A); // 31 to 40
			else if(tempIndexCon>40 && tempIndexCon<=50)   fill(0xFFFFFF33); // 41 to 50
			else if(tempIndexCon>50 && tempIndexCon<=60)   fill(0xFFF8EF33); // 51 to 60
			else if(tempIndexCon>60 && tempIndexCon<=70)   fill(0xFFFFC725); // 61 to 70
			else if(tempIndexCon>70 && tempIndexCon<=80)   fill(0xFFFF9519); // 71 to 80
			else if(tempIndexCon>80 && tempIndexCon<=90)   fill(0xFFFF620C); // 81 to 90
			else                                           fill(0xFFFF3300); // 91 to 100

			rect( visX + (i*visS), ((visY-(visH/2))+(myAudioMax/2))-(tempIndexCon/2), visW, visH+tempIndexCon);

			textSize(14);
			text( (int)myAudioData[i], visX + (i*visS), visY+(myAudioMax+20) );

			strokeWeight(1);
			stroke(0xFF666666);
			noFill();
			line(0, visY, stageW, visY);
			line(0, visY+myAudioMax, stageW, visY+myAudioMax);
			line(0, visY+(myAudioMax+30), stageW, visY+(myAudioMax+30));
		}
	}
	myAudioIndexAmp = myAudioIndex;
	hint(ENABLE_DEPTH_TEST);
}

// ************************************************************************************

 public void stop() {
	if (myAudioToggle) myAudioPlayer.close();
	else               myAudioInput.close();
	minim.stop();  
	super.stop();
}

// ************************************************************************************


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "build" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
