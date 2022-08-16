int    stageW     = 1000;
int    stageH     = 1000;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

// ************************************************************************************

//this is the audio vars
import ddf.minim.*;
import ddf.minim.analysis.*;
Minim minim;
AudioPlayer myAudioPlayer;
AudioInput myAudioInput;//use the mic or line in

FFT  myAudioFFT;

int myAudioRange = 256;

//***************************************************************************************
//this is the vars for the rects

int artW	= 2;
float artX = 100.0;
float artY = 100.0;
int artSpacing	= artW+1;
//***************************************************************************************

void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	background(clrBG);
	minim = new Minim(this);

	myAudioInput = minim.getLineIn(Minim.MONO);
	

	myAudioFFT = new FFT(myAudioInput.bufferSize(), myAudioInput.sampleRate());
	myAudioFFT.linAverages(myAudioRange); //calculate the averages by grouping frequency
}

void draw() {
	background(clrBG);

	myAudioFFT.forward(myAudioInput.mix);

	for (int i = 0; i < myAudioRange; ++i) {
	strokeWeight(1);
	stroke(#000000);
	fill(#FFFFFF);


	float tempIndexAvg = myAudioFFT.getAvg(i);
	rect(artX + (i*artSpacing),artY,artW,tempIndexAvg);	
	}
	strokeWeight(1);
	stroke(#FF3300);
	noFill();
	line(0,artY+100,stageW,artY+100);
}

// ************************************************************************************


void stop(){
	myAudioPlayer.close();
	minim.stop();
	super.stop();
}








