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
AudioInput myAudioInput;//use the mic or line in.
boolean myAudioToggle = true; //true = myAudioPlayer / false = myAudioInput

FFT  myAudioFFT;

int myAudioRange = 256;
int myAudioMax = 100;
float myAudioAmp = 20.0;
//themidibus

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
	if (myAudioToggle) {
		//****************audio file**************************
		myAudioPlayer = minim.loadFile(pathAssets + "AUDIO.wav");
		myAudioPlayer.loop(); //play on repeat
		//myAudioPlayer.play(); //play once
		myAudioPlayer.mute(); // plays the file without playing the music through the speakers
		myAudioFFT = new FFT(myAudioPlayer.bufferSize(), myAudioPlayer.sampleRate());
		myAudioFFT.linAverages(myAudioRange); //calculate the averages by grouping frequency
	} else {
		//**************************mic**************************
		myAudioInput = minim.getLineIn(Minim.MONO);
		myAudioFFT = new FFT(myAudioInput.bufferSize(), myAudioInput.sampleRate());
		myAudioFFT.linAverages(myAudioRange); //calculate the averages by grouping frequency
	}
}

void draw() {
	background(clrBG);

	if (myAudioToggle) myAudioFFT.forward(myAudioPlayer.mix);
	else	myAudioFFT.forward(myAudioInput.mix);

	for (int i = 0; i < myAudioRange; ++i) {
	strokeWeight(1);
	stroke(#000000);
	fill(#FFFFFF);


	float tempIndexAvg = myAudioFFT.getAvg(i) * myAudioAmp;
	float tempIndexCon = constrain(tempIndexAvg, 0, 100);
	rect(artX + (i*artSpacing),artY,artW,tempIndexCon);	
	}
	strokeWeight(1);
	stroke(#FF3300);
	noFill();
	line(0,artY+100,stageW,artY+100);
}

// ************************************************************************************


void stop(){
	if (myAudioToggle)myAudioPlayer.close();
	else myAudioInput.close();
	minim.stop();
	super.stop();
}


void keyPressed(){
	switch (key){
case 's': myAudioPlayer.pause(); break;
case 'p': myAudioPlayer.play(); break;
case 'm': myAudioPlayer.mute(); break;
case 'u': myAudioPlayer.unmute(); break;
	}
}





