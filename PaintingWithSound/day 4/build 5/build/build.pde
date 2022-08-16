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
PImage tex1,tex2,tex3,tex4,tex5,tex6;

void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	background(clrBG);
	clrs = loadImage(whichImg);
	clrsW = clrs.width-1;
	tex1 = loadImage(pathAssets + "tex1.png");
	tex2 = loadImage(pathAssets + "tex2.png");
	tex3 = loadImage(pathAssets + "tex3.png");
	tex4 = loadImage(pathAssets + "tex4.png");
	tex5 = loadImage(pathAssets + "tex5.png");
	tex6 = loadImage(pathAssets + "tex6.png");
	
}

void draw() {
	background(clrBG);
	float wave = sin( clrCount );
	float waveMap = map(wave, -1, 1, 0, clrsW);
	//*********************************************************
	strokeWeight(0);
	noStroke();
	//lights();

	for (int i = 0; i < 5; ++i) {
		
		tint(clrs.get((int)waveMap + (i*75) % clrsW,0));

	push();
		translate(stageW/2,stageH/2,0);
		scale(50 + (i*150));
		rotateX(radians(mouseY + (i*24)));
		rotateY(radians(mouseX + (i*24)));
		buildCube(tex1,tex2,tex3,tex4,tex5,tex6);
	pop();
}

	//********************************************************************
	clrCount += clrSpeed;

}

void buildCube(PImage _t1,PImage _t2,PImage _t3,PImage _t4,PImage _t5,PImage _t6){
	// back face
	textureMode(NORMAL);
	hint(DISABLE_DEPTH_TEST);
		beginShape(QUADS);//quads expects 4 points only

			texture(_t1);
			vertex(-(0.5), -(0.5), -(0.5),	 0, 0); //// x, y, z, u, v
			vertex((0.5), -(0.5),  -(0.5), 	1, 0); //// x, y, z, u, v
			vertex((0.5), (0.5),   -(0.5), 	1, 1); //// x, y, z, u, v
			vertex(-(0.5), (0.5),  -(0.5),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape

		//front
		beginShape(QUADS);//quads expects 4 points only

			texture(_t6);
			vertex(-(0.5), -(0.5), (0.5),	 0, 0); //// x, y, z, u, v
			vertex((0.5), -(0.5),  (0.5), 	1, 0); //// x, y, z, u, v
			vertex((0.5), (0.5),   (0.5), 	1, 1); //// x, y, z, u, v
			vertex(-(0.5), (0.5),  (0.5),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape

		//left
		beginShape(QUADS);//quads expects 4 points only

			texture(_t2);
			vertex(-(0.5), -(0.5), (0.5),	 0, 0); //// x, y, z, u, v
			vertex(-(0.5), -(0.5),  -(0.5), 	1, 0); //// x, y, z, u, v
			vertex(-(0.5),  (0.5),   -(0.5), 	1, 1); //// x, y, z, u, v
			vertex(-(0.5),  (0.5),  (0.5),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape
	
	//right
		beginShape(QUADS);//quads expects 4 points only

			texture(_t3);
			vertex((0.5), -(0.5), (0.5),	 0, 0); //// x, y, z, u, v
			vertex((0.5), -(0.5),  -(0.5), 	1, 0); //// x, y, z, u, v
			vertex((0.5), (0.5),   -(0.5), 	1, 1); //// x, y, z, u, v
			vertex((0.5), (0.5),  (0.5),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape
	//bottom
		beginShape(QUADS);//quads expects 4 points only

			texture(_t5);
			vertex(-(0.5), (0.5), (0.5),	 0, 0); //// x, y, z, u, v
			vertex(-(0.5), (0.5),  -(0.5), 	1, 0); //// x, y, z, u, v
			vertex((0.5), (0.5),   -(0.5), 	1, 1); //// x, y, z, u, v
			vertex((0.5), (0.5),  (0.5),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape

	//top
	beginShape(QUADS);//quads expects 4 points only

		texture(_t4);
		vertex(-(0.5), -(0.5), (0.5),	 0, 0); //// x, y, z, u, v
		vertex(-(0.5), -(0.5),  -(0.5), 	1, 0); //// x, y, z, u, v
		vertex((0.5),  -(0.5),   -(0.5), 	1, 1); //// x, y, z, u, v
		vertex((0.5),  -(0.5),  (0.5),	 0, 1); //// x, y, z, u, v
	endShape(CLOSE);//this closes the shape

	/*triangles */


}





