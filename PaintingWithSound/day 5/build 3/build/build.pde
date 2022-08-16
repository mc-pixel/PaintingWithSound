import hype.*;
import hype.extended.layout.HGridLayout;

int    stageW     = 1000;
int    stageH     = 1000;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

int artW = 25; // the size of our artwork

int gridCols   = 5;
int gridRows = 5;
int gridDepth = 5;
int gridTotal = gridCols * gridRows * gridDepth;
int gridSpaceX = 200;
int gridSpaceY = 200;//spacing between cells Y
int gridSpaceZ = 200;
int gridStartX = -((gridCols-1)*(gridSpaceX/2));
int gridStartY = -((gridRows-1)*(gridSpaceY/2));// where to start grid
int gridStartZ = -((gridDepth-1)*(gridSpaceZ/2));// where to start grid

HGridLayout layout;

PVector[] pos = new PVector[gridTotal];

float clrCount;
float clrSpeed = 0.05;
float clrOffset = 1.0;


void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	H.init(this);
	background(clrBG);

	layout = new HGridLayout().startX(gridStartX).startY(gridStartY).startZ(gridStartZ).spacing(gridSpaceX,gridSpaceY,gridSpaceZ).cols(gridCols).rows(gridRows);
	for (int i = 0; i < gridTotal; ++i) {
		pos[i] = new PVector();
		pos[i] = layout.getNextPoint();
	}
}

//to make it breath we will have to recall the layout


void draw() {
	background(clrBG);

	strokeWeight(0);
	noStroke();
	fill(#FF3300);
	lights();	

	for (int i = 0; i < gridTotal; ++i) {
		PVector _p = pos[i];

		float wave =  sin(clrCount+(i*clrOffset));
		float waveMap = map(wave, -1, 1, 5, artW);
		float rX = map(wave,-1,1,-180,180);
		float rY = map(wave,-1,1,-180,180);
		float rZ = map(wave,-1,1,-180,180);		
		push();
		translate(stageW/2, stageH/2,0);
		rotateX(radians(mouseY));
		rotateY(radians(mouseX));
			push();
				translate(_p.x,_p.y,_p.z);
				rotateX(radians(rX*0.2));
				rotateY(radians(rY*0.2));
				rotateZ(radians(rZ*0.2));
				box(waveMap,waveMap,waveMap);
				//rect(-(artW/2),-(artW/2),artW,artW);
			pop();
		pop();
	}
	clrCount += clrSpeed;
}


