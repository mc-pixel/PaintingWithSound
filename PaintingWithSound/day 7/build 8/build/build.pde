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
String 		whichAudioFile 	 = "AUDIO.wav";
AudioInput  myAudioInput;
boolean     myAudioToggle    = true; // true = myAudioPlayer / false = myAudioInput
boolean 	showVisualizer 	 = true;

FFT         myAudioFFT;

int         myAudioRange     = 16; //256 /128(2) / 64(4) / 32(8) / 16(16)
int         myAudioMax       = 100;


float       myAudioAmp       =40.0;
float       myAudioIndex     = 0.2;
float       myAudioIndexAmp  = myAudioIndex;
float       myAudioIndexStep = 0.30;
float[]		myAudioData		 = new float[myAudioRange];//keeps a reord of all the numbers in an array

// ************************************************************************************

// THIS IS THE VARS FOR THE RECTS

float       artX             = 1.0;
float       artY             = 1.0;
float       artW             = ((float(stageW)-(artX*2))-(float(myAudioRange)-1)) / float(myAudioRange);
float 		artH 			 = 2.0;
float       artSpacing       = (float(stageW)-(artX*2)) / float(myAudioRange);

// ************************************************************************************

void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	background(clrBG);
	audioSetup();
}

void draw() {
	background(clrBG);
	audioUpdate();

	lights();
	strokeWeight(0);
	noStroke();
	fill(#00FF00);

	push();
		translate(stageW/2 , stageH/2,0);
		rotateX(radians((int)map(myAudioData[3],0,myAudioMax,-180,180)));
		rotateY(radians((int)map(myAudioData[6],0,myAudioMax,-180,180)));
		rotateZ(radians((int)map(myAudioData[9],0,myAudioMax,-180,180)));
		int boxScale = (int)map(myAudioData[0],0,myAudioMax, 50, 500);
		box(boxScale, boxScale, boxScale);
	pop();


}

// ************************************************************************************

void keyPressed() {
	switch (key) {

		case '1': myAudioToggle = true;  if(!myAudioToggle){myAudioInput.close();}  minim.stop(); audioSetup(); break; //audioPlayer
		case '2': myAudioToggle = false; myAudioPlayer.close(); minim.stop(); audioSetup(); break; //audioInput

		case 's': myAudioPlayer.pause();  break;
		case 'p': myAudioPlayer.play();   break;
		case 'm': myAudioPlayer.mute();   break;
		case 'u': myAudioPlayer.unmute(); break;

		case 'v': showVisualizer = !showVisualizer; break;
	}
}
// ************************************************************************************

void audioSetup() {
	minim = new Minim(this);

	if (myAudioToggle) {
		myAudioPlayer = minim.loadFile(pathAssets + whichAudioFile);
		myAudioPlayer.loop();
		myAudioPlayer.mute();
		myAudioFFT = new FFT(myAudioPlayer.bufferSize(), myAudioPlayer.sampleRate());
		myAudioFFT.linAverages(myAudioRange);
	} else {
		myAudioInput = minim.getLineIn(Minim.MONO);
		myAudioFFT = new FFT(myAudioInput.bufferSize(), myAudioInput.sampleRate());
		myAudioFFT.linAverages(myAudioRange);
	}
	myAudioFFT.window(FFT.GAUSS);
}
// ************************************************************************************

void audioUpdate(){

	if (myAudioToggle) myAudioFFT.forward(myAudioPlayer.mix);
	else               myAudioFFT.forward(myAudioInput.mix);

		if(showVisualizer){
			strokeWeight(0);
			noStroke();
			fill(#000000,245);
			rect(artX,artY,stageW,myAudioMax+30);
		}
	for (int i = 0; i < myAudioRange; ++i) {
			strokeWeight(0);
			//stroke(#000000);
			noStroke();
			fill(#FFFFFF);
		float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
		myAudioIndexAmp+=myAudioIndexStep;
		float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
		myAudioData[i]	   = tempIndexCon; //record the numbers from 0 - 100
		if(showVisualizer){
			if(tempIndexCon<=artH) fill(#0095A8);
			else 				   fill(#FFFFFF);
			rect( artX + (i*artSpacing), (artY - (artH / 2) + (myAudioMax / 2)) - (tempIndexCon/2), artW,artH+tempIndexCon);

			strokeWeight(0);
			noStroke();
			fill(#0095A8);
			textSize(14);
			text((int)myAudioData[i],artX + (i*artSpacing), artY+(myAudioMax+20));
		}
	}
	myAudioIndexAmp = myAudioIndex;

	if(showVisualizer){
		strokeWeight(1);
		stroke(#FF3300);
		noFill();
		line(0, artY, stageW, artY);
		line(0, artY+myAudioMax, stageW, artY+myAudioMax);
	}
}

// ************************************************************************************

void stop() {
	if (myAudioToggle) myAudioPlayer.close();
	else               myAudioInput.close();
	minim.stop();  
	super.stop();
}

// ************************************************************************************








