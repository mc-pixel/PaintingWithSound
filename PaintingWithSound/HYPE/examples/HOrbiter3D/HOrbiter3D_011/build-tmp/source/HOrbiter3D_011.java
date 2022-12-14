/* autogenerated by Processing revision 1283 on 2022-07-26 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import hype.*;
import hype.extended.behavior.HOrbiter3D;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class HOrbiter3D_011 extends PApplet {




HOrbiter3D orb;

 public void setup() {
	/* size commented out by preprocessor */;
	H.init(this).background(0xFF242424).use3D(true);

	orb = new HOrbiter3D(width/2, height/2, 0)
		.zSpeed(1.5f)
		.ySpeed(0.2f)
		.radius(250)
	;
}

 public void draw() {
	background(0xFF242424);

	orb._run();
	PVector pt = orb.getNextPoint();
	
	//simple sphere mesh to show orbit range
	pushMatrix();
		translate(width/2, height/2, 0);
		stroke(0xFF666666);
		noFill();
		sphereDetail(20);
		sphere(200);
	popMatrix();

	//draw a line from current orbit point to next orbit point
	stroke(0xFFFF3300);
	beginShape(LINES);
		vertex(orb.x(), orb.y(), orb.z());
		vertex(pt.x, pt.y, pt.z);
	endShape();


}


  public void settings() { size(640, 640, P3D); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "HOrbiter3D_011" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
