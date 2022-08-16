/* autogenerated by Processing revision 1283 on 2022-07-26 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import hype.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class HIcosahedron_001 extends PApplet {



HIcosahedron icos;

 public void setup() {
	/* size commented out by preprocessor */;
	H.init(this).background(0xFF242424).use3D(true);

	H.add( icos = new HIcosahedron() )
		.stroke(0)
		.fill(255)
		.size(200)
		.loc(width/2, height/2)
	;
}

 public void draw() {
	lights();
	icos.rotationY(mouseX);
	H.drawStage();	
}


  public void settings() { size(640, 640, P3D); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "HIcosahedron_001" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
