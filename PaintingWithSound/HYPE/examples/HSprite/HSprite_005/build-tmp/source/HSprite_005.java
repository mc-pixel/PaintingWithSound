/* autogenerated by Processing revision 1283 on 2022-07-26 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import hype.*;
import hype.extended.behavior.HOrbiter3D;
import hype.extended.behavior.HOscillator;
import hype.extended.colorist.HColorPool;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class HSprite_005 extends PApplet {






HDrawablePool pool;
HImage        img1, img2, img3;

 public void setup() {
	/* size commented out by preprocessor */;
	H.init(this).background(0xFF242424).use3D(true);

	img1 = new HImage("tex1.png");
	img2 = new HImage("tex2.png");
	img3 = new HImage("tex3.png");

	pool = new HDrawablePool(400);
	pool.autoAddToStage()
		.add(new HSprite(50).texture(img1))
		.add(new HSprite(50).texture(img2))
		.add(new HSprite(50).texture(img3))

		// HSprite is the fastest possible drawable, perfect for drawing thousands of objects on screen and not killing FPS
		// PNG's also create interesting "overlapping" textures through the transparency
		// and if the PNG's use white... they can be "perfectly" tinted on the fill()
		// if the PNG is grayscale/color fill() coloring is applied ON TOP of base color, only white creates 1 to 1 tinting

		.colorist( new HColorPool(0xFFFFFFFF, 0xFFF7F7F7, 0xFFECECEC, 0xFFCCCCCC, 0xFF999999, 0xFF666666, 0xFF4D4D4D, 0xFF333333, 0xFFFF3300, 0xFFFF6600).fillOnly() )
		.onCreate(
			new HCallback() {
				public void run(Object obj) {
					int i = pool.currentIndex();

					HDrawable d = (HDrawable) obj;
					d.anchorAt(H.CENTER).rotation(45);

					HOrbiter3D orb = new HOrbiter3D(width/2, height/2, 0)
						.target(d)
						.radius(225)
						.ySpeed(1)
						.zSpeed(1)
						.yAngle( (i+1)*2 )
						.zAngle( (i+1)*3 )
					;

					new HOscillator()
						.target(d)
						.property(H.SCALE)
						.range(0.1f, 1.0f)
						.speed(0.1f)
						.freq(10)
					;

					new HOscillator()
						.target(d)
						.property(H.ROTATION)
						.range(-180, 180)
						.speed(0.1f)
						.freq(10)
						.currentStep(i)
					;
				}
			}
		)
		.requestAll()
	;
}

 public void draw() {
	H.drawStage();
	surface.setTitle(PApplet.parseInt(frameRate) + " fps");
}


  public void settings() { size(640, 640, P3D); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "HSprite_005" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
