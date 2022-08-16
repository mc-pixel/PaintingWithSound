int    stageW     = 1000;
int    stageH     = 1000;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

// ************************************************************************************

//this is the audio vars
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
}

void draw() {
	background(clrBG);

	for (int i = 0; i < myAudioRange; ++i) {
	strokeWeight(1);
	stroke(#000000);
	fill(#FFFFFF);
	rect(artX + (i*artSpacing),artY,artX,artW);	
	}
}

// ************************************************************************************











