/* autogenerated by Processing revision 1283 on 2022-07-21 */
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

PImage myImg;
 public void settings() {
	size(stageW,stageH,P3D);
}

 public void setup(){
	background(clrBG);
	//surface.setLocation(100,100);//position where the window goes 
	myImg = loadImage(pathAssets + "akira.png");
}

 public void draw() {
	background(clrBG);
	image(myImg, 0, 0);
	surface.setTitle("FPS = " + (int)frameRate);
}
/*git compare*/


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "build" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
