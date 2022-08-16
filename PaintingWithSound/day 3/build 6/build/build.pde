int    stageW     = 1200;
int    stageH     = 900;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

String whichImg = pathAssets + "rainbow.png";
PImage clrs;
int clrsW;
float  clrCount;
float clrSpeed = 0.02; //speed of the colour change 


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

	float wave1 = sin(clrCount) * clrsW;
	float waveMap1 = map(wave1, -clrsW, clrsW,0,clrsW );

	//visualize markers on image
	fill(#000000);
	rect(waveMap1,0,5,25);


	strokeWeight(0);
	noStroke();
	fill(clrs.get((int)waveMap1,0));
	rect(50,150,300,300);

	clrCount += clrSpeed;

}
/*git compare*/