int    stageW     = 900;
int    stageH     = 900;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

PImage tex;
void settings() {
	size(stageW,stageH,P3D);
}

void setup(){
	background(clrBG);
	//surface.setLocation(100,100);//position where the window goes 
	tex = loadImage(pathAssets + "tex1.png");
}

void draw() {
	background(clrBG);
	/*image(myImg, 0, 0);
	surface.setTitle("FPS = " + (int)frameRate);*/
	strokeWeight(1);
	tint(#333333);
	push();
		translate(stageW/2,stageH/2,0);
		scale(400);
		rotateX(radians(mouseY));
		rotateY(radians(mouseX));
		buildCube();
	pop();
}
/*git compare*/
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