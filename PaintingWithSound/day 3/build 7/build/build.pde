int    stageW     = 1200;
int    stageH     = 900;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

String whichImg = pathAssets + "rainbow.png";
PImage clrs;
int clrsW;
float  clrCount;
float clrSpeed = 0.02; //speed of the colour change 
float clrOffset = -200.6;

int numSquares = 5;


void settings() {
	size(stageW,stageH,P3D);
}

void setup(){
	background(clrBG);
	//surface.setLocation(100,100);//position where the window goes 
	clrs = loadImage(whichImg);
	clrsW = clrs.width-1;
}

void draw() {
	background(clrBG);
	image(clrs, 0 ,0);

	noStroke();

	for (int i = 0; i < numSquares; ++i) {
		float wave1 = sin(clrCount + (i*clrOffset)) ;
		float waveMap1 = map(wave1,-1,1,0,clrsW );

		//visualize markers on image
		fill(#000000);
		rect(waveMap1,0,5,25);


		strokeWeight(0);
		noStroke();
		fill(clrs.get((int)waveMap1,0));
		rect(50 + (i*150),150,100,300);
	}

	clrCount += clrSpeed;

}
/*git compare*/