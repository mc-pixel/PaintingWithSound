int    stageW     = 1200;
int    stageH     = 900;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";
PImage tex;


void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	background(clrBG);
	tex = loadImage(pathAssets + "tex1.png");
}

void draw() {
	background(clrBG);
	textureMode(NORMAL);

	strokeWeight(0);
	noStroke();
	//fill(#FF3300);
	tint(#FF3300);


	push();
		translate(100,100,0);
		scale(50);
		beginShape(QUADS);//quads expects 4 points only

			texture(tex);
			vertex(-(0.5), -(0.5), 0,	 0, 0); //// x, y, z, u, v
			vertex((0.5), -(0.5), 0, 	1, 0); //// x, y, z, u, v
			vertex((0.5), (0.5), 0, 	1, 1); //// x, y, z, u, v
			vertex(-(0.5), (0.5), 0,	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape
	pop();
}


