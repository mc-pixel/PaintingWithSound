import hype.*;
import hype.extended.layout.HCircleLayout;

int    stageW     = 1000;
int    stageH     = 1000;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

int numAssets = 50;

PVector[]pos = new PVector[numAssets];

int layoutRadius = 200;
int layoutStartX = stageW/2;
int layoutStartY = stageH/2;
float layoutStep = 360.0/numAssets;

HCircleLayout layout;

void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	H.init(this);
	background(clrBG);
	layout = new HCircleLayout().startX(layoutStartX).startY(layoutStartY).radius(layoutRadius).angleStep(layoutStep)/*.useNoise(true)*/;

	for (int i = 0; i < numAssets; ++i) {
		pos[i] = layout.getNextPoint();
		
	}
}

void draw() {
	background(clrBG);

	for (int i = 0; i < numAssets; ++i) {

		push();
		translate(pos[i].x,pos[i].y,pos[i].z);
		//rotate(radians(90)+(layout.angleStepRad()*i));
		rotate((layout.angleStepRad()*i));
		rect(0,0,5,1000);
		pop();
		
	}

}


