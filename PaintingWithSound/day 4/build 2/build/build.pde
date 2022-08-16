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
	float wave = sin( clrCount );
	float waveMap = map(wave, -1, 1, 0, clrsW);
	//*********************************************************
	strokeWeight(0);
	noStroke();
	tint( clrs.get((int)waveMap, 0) );

	push();
		translate(stageW/2,stageH/2,0);
		scale(400);
		rotateX(radians(mouseY));
		rotateY(radians(mouseX));
		buildCube();
	pop();
	//********************************************************************
	clrCount += clrSpeed;

}

void buildCube(){
	// back face
	textureMode(NORMAL);
	hint(DISABLE_DEPTH_TEST);
		beginShape(QUADS);//quads expects 4 points only

			texture(tex);
			vertex(-(0.5), -(0.5), -(0.5),	 0, 0); //// x, y, z, u, v
			vertex((0.5), -(0.5),  -(0.5), 	1, 0); //// x, y, z, u, v
			vertex((0.5), (0.5),   -(0.5), 	1, 1); //// x, y, z, u, v
			vertex(-(0.5), (0.5),  -(0.5),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape

		//front
		beginShape(QUADS);//quads expects 4 points only

			texture(tex);
			vertex(-(0.5), -(0.5), (0.5),	 0, 0); //// x, y, z, u, v
			vertex((0.5), -(0.5),  (0.5), 	1, 0); //// x, y, z, u, v
			vertex((0.5), (0.5),   (0.5), 	1, 1); //// x, y, z, u, v
			vertex(-(0.5), (0.5),  (0.5),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape

		//left
		beginShape(QUADS);//quads expects 4 points only

			texture(tex);
			vertex(-(0.5), -(0.5), (0.5),	 0, 0); //// x, y, z, u, v
			vertex(-(0.5), -(0.5),  -(0.5), 	1, 0); //// x, y, z, u, v
			vertex(-(0.5),  (0.5),   -(0.5), 	1, 1); //// x, y, z, u, v
			vertex(-(0.5),  (0.5),  (0.5),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape
	
	//right
		beginShape(QUADS);//quads expects 4 points only

			texture(tex);
			vertex((0.5), -(0.5), (0.5),	 0, 0); //// x, y, z, u, v
			vertex((0.5), -(0.5),  -(0.5), 	1, 0); //// x, y, z, u, v
			vertex((0.5), (0.5),   -(0.5), 	1, 1); //// x, y, z, u, v
			vertex((0.5), (0.5),  (0.5),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape
	//bottom
		beginShape(QUADS);//quads expects 4 points only

			texture(tex);
			vertex(-(0.5), (0.5), (0.5),	 0, 0); //// x, y, z, u, v
			vertex(-(0.5), (0.5),  -(0.5), 	1, 0); //// x, y, z, u, v
			vertex((0.5), (0.5),   -(0.5), 	1, 1); //// x, y, z, u, v
			vertex((0.5), (0.5),  (0.5),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape

	//top
	beginShape(QUADS);//quads expects 4 points only

		texture(tex);
		vertex(-(0.5), -(0.5), (0.5),	 0, 0); //// x, y, z, u, v
		vertex(-(0.5), -(0.5),  -(0.5), 	1, 0); //// x, y, z, u, v
		vertex((0.5),  -(0.5),   -(0.5), 	1, 1); //// x, y, z, u, v
		vertex((0.5),  -(0.5),  (0.5),	 0, 1); //// x, y, z, u, v
	endShape(CLOSE);//this closes the shape


}


