/* autogenerated by Processing revision 1283 on 2022-07-26 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import hype.*;
import hype.extended.behavior.HOrbiter3D;
import hype.extended.colorist.HColorPool;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class HOrbiter3D_010 extends PApplet {





HDrawablePool pool;

 public void setup() {
	/* size commented out by preprocessor */;
	H.init(this).background(0xFF242424).use3D(true);

	H.add( new HSphere() ).size(200).strokeWeight(0).noStroke().fill(0xFF666666).anchorAt(H.CENTER).loc(width/2, height/2);

	pool = new HDrawablePool(100);
	pool.autoAddToStage()
		.add(new HSphere())
		.colorist( new HColorPool(0xFF333333,0xFF494949,0xFF5F5F5F,0xFF707070,0xFF7D7D7D,0xFF888888,0xFF949494,0xFFA2A2A2,0xFFB1B1B1,0xFFC3C3C3,0xFFD6D6D6,0xFFEBEBEB,0xFFFFFFFF).fillOnly() )
		.onCreate(
			new HCallback() {
				public void run(Object obj) {
					HSphere d = (HSphere) obj;
					int ranSize = 10 + ( (int)random(3)*7 );

					d.size(ranSize).strokeWeight(0).noStroke().anchorAt(H.CENTER);

					HOrbiter3D orb = new HOrbiter3D(width/2, height/2, 0)
						.target(d)
						.zSpeed(random(-1.5f, 1.5f))
						.ySpeed(random(-0.5f, 0.5f))
						.radius(195)
						.zAngle( (int)random(360) )
						.yAngle( (int)random(360) )
					;

					d.extras( new HBundle().obj("o", orb) );
				}
			}
		)
		.requestAll()
	;
}

 public void draw() {
	pointLight(100, 0, 0,      width/2, height, 200);          // under red light
	pointLight(51, 153, 153,   width/2, -50, 150);             // over teal light
	pointLight(204, 204, 204,  width/2, (height/2) - 50, 500); // mid light gray light

	for(HDrawable d : pool) {
		float r = floor(random(190, 220));

		HBundle obj1 = d.extras();
		HOrbiter3D o = (HOrbiter3D) obj1.obj("o");
		o.radius(r);
	}

	sphereDetail(20);
	H.drawStage();
}


  public void settings() { size(640, 640, P3D); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "HOrbiter3D_010" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
