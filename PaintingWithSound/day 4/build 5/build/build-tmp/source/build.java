/* autogenerated by Processing revision 1283 on 2022-07-28 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class build extends PApplet {

int    stageW     = 1200;
int    stageH     = 900;
int  clrBG      = 0xFF242424;
String pathAssets = "../../../assets/";

String whichImg = pathAssets + "colors_002.png";
PImage clrs; // image
int    clrsW; // width of image
float  clrCount;
float  clrSpeed = 0.02f; // the speed of the color change
float  clrOffset = 0.01f; // the distance from each of the squares getting colored
//**************************************************************************************************************************************************************/
PImage tex1,tex2,tex3,tex4,tex5,tex6;

 public void settings() {
	size(stageW, stageH, P3D);
}

 public void setup() {
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

 public void draw() {
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

 public void buildCube(PImage _t1,PImage _t2,PImage _t3,PImage _t4,PImage _t5,PImage _t6){
	// back face
	textureMode(NORMAL);
	hint(DISABLE_DEPTH_TEST);
		beginShape(QUADS);//quads expects 4 points only

			texture(_t1);
			vertex(-(0.5f), -(0.5f), -(0.5f),	 0, 0); //// x, y, z, u, v
			vertex((0.5f), -(0.5f),  -(0.5f), 	1, 0); //// x, y, z, u, v
			vertex((0.5f), (0.5f),   -(0.5f), 	1, 1); //// x, y, z, u, v
			vertex(-(0.5f), (0.5f),  -(0.5f),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape

		//front
		beginShape(QUADS);//quads expects 4 points only

			texture(_t6);
			vertex(-(0.5f), -(0.5f), (0.5f),	 0, 0); //// x, y, z, u, v
			vertex((0.5f), -(0.5f),  (0.5f), 	1, 0); //// x, y, z, u, v
			vertex((0.5f), (0.5f),   (0.5f), 	1, 1); //// x, y, z, u, v
			vertex(-(0.5f), (0.5f),  (0.5f),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape

		//left
		beginShape(QUADS);//quads expects 4 points only

			texture(_t2);
			vertex(-(0.5f), -(0.5f), (0.5f),	 0, 0); //// x, y, z, u, v
			vertex(-(0.5f), -(0.5f),  -(0.5f), 	1, 0); //// x, y, z, u, v
			vertex(-(0.5f),  (0.5f),   -(0.5f), 	1, 1); //// x, y, z, u, v
			vertex(-(0.5f),  (0.5f),  (0.5f),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape
	
	//right
		beginShape(QUADS);//quads expects 4 points only

			texture(_t3);
			vertex((0.5f), -(0.5f), (0.5f),	 0, 0); //// x, y, z, u, v
			vertex((0.5f), -(0.5f),  -(0.5f), 	1, 0); //// x, y, z, u, v
			vertex((0.5f), (0.5f),   -(0.5f), 	1, 1); //// x, y, z, u, v
			vertex((0.5f), (0.5f),  (0.5f),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape
	//bottom
		beginShape(QUADS);//quads expects 4 points only

			texture(_t5);
			vertex(-(0.5f), (0.5f), (0.5f),	 0, 0); //// x, y, z, u, v
			vertex(-(0.5f), (0.5f),  -(0.5f), 	1, 0); //// x, y, z, u, v
			vertex((0.5f), (0.5f),   -(0.5f), 	1, 1); //// x, y, z, u, v
			vertex((0.5f), (0.5f),  (0.5f),	 0, 1); //// x, y, z, u, v
		endShape(CLOSE);//this closes the shape

	//top
	beginShape(QUADS);//quads expects 4 points only

		texture(_t4);
		vertex(-(0.5f), -(0.5f), (0.5f),	 0, 0); //// x, y, z, u, v
		vertex(-(0.5f), -(0.5f),  -(0.5f), 	1, 0); //// x, y, z, u, v
		vertex((0.5f),  -(0.5f),   -(0.5f), 	1, 1); //// x, y, z, u, v
		vertex((0.5f),  -(0.5f),  (0.5f),	 0, 1); //// x, y, z, u, v
	endShape(CLOSE);//this closes the shape

	/*triangles */


}


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "build" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
