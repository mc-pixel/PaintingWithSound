int    stageW     = 1200;
int    stageH     = 900;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

String whichImg = pathAssets + "colors_002.png";
PImage clrs; // image
int    clrsW; // width of image
float  clrCount;
float  clrSpeed = 0.02; // the speed of the color change
float  clrOffset = 0.01; // the distance from each of the squares getting colored
//**************************************************************************************************************************************************************/
PImage tex;

void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	background(clrBG);
	clrs = loadImage(whichImg);
	clrsW = clrs.width-1;
	tex = loadImage(pathAssets + "tex1.png");
}

void draw() {
	background(clrBG);
	textureMode(NORMAL);
	strokeWeight(0);
	noStroke();

	float wave = sin( clrCount );
	float waveMap = map(wave, -1, 1, 0, clrsW);
	tint( clrs.get((int)waveMap, 0) );
	push();
		translate(stageW/2,stageH/2,0);
		scale(800);
		beginShape(QUADS);//quads expects 4 points only

			texture(tex);
			vertex(-(0.5), -(0.5), 0,	 0, 0); //// x, y, z, u, v
			vertex((0.5), -(0.5), 0, 	1, 0); //// x, y, z, u, v
			vertex((0.5), (0.5), 0, 	1, 1); //// x, y, z, u, v
			vertex(-(0.5), (0.5), 0,	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape
	pop();
	//rect(0, 0, 100, 100);

	clrCount += clrSpeed;

}


