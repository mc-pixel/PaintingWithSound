/* autogenerated by Processing revision 1283 on 2022-07-26 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.behavior.HParticles;
import hype.extended.colorist.HColorPool;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class HParticles_002 extends PApplet {






HDrawablePool pool;
HParticles    hp;
HColorPool    colors;
HOscillator   xRot, yRot, zRot, zPos;

 public void setup() {
	/* size commented out by preprocessor */; 
	H.init(this).background(0xFF242424).use3D(true).autoClear(true);

	hp = new HParticles()
		.location(0, 0)
		.minimumLife(10)
		.maximumLife(150)
		.speed(3.0f)
		.decay(1.0f)
		.fade(false)
	;

	colors = new HColorPool(0xFFFFFFFF, 0xFFF7F7F7, 0xFFECECEC, 0xFF333333, 0xFF0095A8, 0xFF00616F, 0xFFFF3300, 0xFFFF6600);

	xRot = new HOscillator().range(-180, 180).speed(0.6f).freq(1);
	yRot = new HOscillator().range(-180, 180).speed(0.4f).freq(1);
	zRot = new HOscillator().range(-180, 180).speed(0.2f).freq(1);
	zPos = new HOscillator().range(-360, 360).speed(0.5f).freq(3);

	pool = new HDrawablePool(400);
	pool.autoAddToStage()
		.add(new HBox())
		.onCreate(
			new HCallback() {
				public void run(Object obj) {
					HDrawable d = (HDrawable) obj;
					d.noStroke().fill(colors.getColor()).size(5).anchorAt(H.CENTER).rotation(45);
					hp.addParticle(d);
				}
			}
		)
		.requestAll()
	;
}


 public void draw() {
	xRot.nextRaw();
	yRot.nextRaw();
	zRot.nextRaw();
	zPos.nextRaw();

	lights();

	pushMatrix();
		translate(width/2, height/2, zPos.curr());
		rotateX(radians(xRot.curr()));
		rotateY(radians(yRot.curr()));
		rotateZ(radians(zRot.curr()));
		H.drawStage();
	popMatrix();
}


  public void settings() { size(640, 640, P3D); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "HParticles_002" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
