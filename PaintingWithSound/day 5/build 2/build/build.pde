import hype.*;
import hype.extended.layout.HGridLayout;

int    stageW     = 1000;
int    stageH     = 1000;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

int artW = 100; // the size of our artwork

int gridCols = 5;
int gridRows = 5;
int gridTotal = gridCols * gridRows;
int gridSpaceX = 110;
int gridSpaceY = 110;//spacing between cells Y
int gridStartX = -((gridCols-1)*(gridSpaceX/2));
int gridStartY = -((gridRows-1)*(gridSpaceY/2));// where to start grid

HGridLayout layout;

PVector[] pos = new PVector[gridTotal];

void settings() {
	size(stageW, stageH, P3D);
}

void setup() {
	H.init(this);
	background(clrBG);

	layout = new HGridLayout().startX(gridStartX).startY(gridStartY).spacing(gridSpaceX,gridSpaceY).cols(gridCols);
	for (int i = 0; i < gridTotal; ++i) {
		pos[i] = new PVector();
		pos[i] = layout.getNextPoint();
	}
}

void draw() {
	background(clrBG);

	strokeWeight(0);
	noStroke();
	fill(#FF3300);

	for (int i = 0; i < gridTotal; ++i) {
		PVector _p = pos[i];
		push();
		translate(stageW/2, stageH/2,0);
		rotateX(radians(mouseY));
		rotateY(radians(mouseX));
			push();
				translate(_p.x,_p.y,_p.z);
				/*rotateX(radians(mouseY));
				rotateY(radians(mouseX));*/
				rect(-(artW/2),-(artW/2),artW,artW);
			pop();
		pop();
	}
}


