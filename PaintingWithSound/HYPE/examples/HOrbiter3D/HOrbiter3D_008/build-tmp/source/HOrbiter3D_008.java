/* autogenerated by Processing revision 1283 on 2022-07-26 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import hype.*;
import hype.extended.behavior.HOrbiter3D;
import hype.extended.colorist.HPixelColorist;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class HOrbiter3D_008 extends PApplet {





HOrbiter3D     orb1, orb2;
HCanvas        canvas;

HImage         clrSRC;
HPixelColorist clrHPC;
int            clrMin = 0;
int            clrMax = 200;
int[]        clr;

HRect          clrMarker, d;

 public void setup() {
	/* size commented out by preprocessor */;
	H.init(this).background(0xFF242424).use3D(true);

	H.add( clrSRC = new HImage("color.png") ).loc(10, 10);
	clrHPC = new HPixelColorist(clrSRC);

	clrMarker = new HRect(2,10);
	clrMarker.noStroke().fill(0xFFCCCCCC).loc( 10,25);
	H.add(clrMarker);

	clr = new int[ clrMax ];

	for (int i = 0; i < clrMax; i++) {
		float tempPos = (clrSRC.width() / clrMax) * i;
		clr[i] = clrHPC.getColor(tempPos,0);
	}

	canvas = new HCanvas(P3D).autoClear(false).fade(1);
	H.add(canvas);

	d = new HRect(50).rounding(4);
	d.noStroke().fill(0xFF242424).anchorAt(H.CENTER).rotation(45);
	canvas.add(d);

	orb1 = new HOrbiter3D(width/2, height/2, 0)
		.zSpeed(-1.5f)
		.ySpeed(-0.2f)
		.radius(200)
	;

	orb2 = new HOrbiter3D(width/2, height/2, 0)
		.target(d)
		.zSpeed(5)
		.ySpeed(2)
		.radius(75)
		.parent(orb1)
	;
}

 public void draw() {
	H.drawStage();
	d.fill( clr[clrMin] );

	// update color position

	clrMin++;
	if (clrMin == clrMax) clrMin = 0;
	float tempPos = ((clrSRC.width() / clrMax) * clrMin)+10;
	clrMarker.loc(tempPos,25);
}


  public void settings() { size(640, 640, P3D); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "HOrbiter3D_008" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
