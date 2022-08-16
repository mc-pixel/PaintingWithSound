/* autogenerated by Processing revision 1283 on 2022-07-12 */
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

int    stageW     = 900;
int    stageH     = 900;
int  clrBG      = 0xFF242424;
String pathAssets = "../../../assets/";

int whichColor = 0; // 0 = red / 1 = blue

 public void settings() {
	size(stageW,stageH,P3D);
}

 public void setup(){
	background(clrBG);
}

 public void draw() {
	background(clrBG);

	if(whichColor == 0) {
		drawRed();
	} else {
		drawBlue();
	}
}

 public void keyPressed() {
	switch (key) {
		case '1': whichColor = 0; break;
		case '2': whichColor = 1; break;
		
	}
}
 public void drawBlue(){
	strokeWeight(0);
	//fill(#FFFFFF)
	noStroke();
	fill(0xFF0000FF);
	rect(0,0,500,500);
}
 public void drawRed(){
	strokeWeight(0);
	//fill(#FFFFFF)
	noStroke();
	fill(0xFFFF0000);
	rect(0,0,500,500);
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