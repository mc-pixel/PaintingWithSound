import hype.*;
import hype.extended.layout.HGridLayout;

int    stageW     = 1000;
int    stageH     = 1000;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

int gridCols = 10;
int gridRows = 10;
int gridTotal = gridCols * gridRows;
int gridStartX = 0;
int gridStartY = 0;// where to start grid
int gridSpaceX = 100;
int gridSpaceY = 100;//spacing between cells

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

	for (int i = 0; i < gridTotal; ++i) {
		PVector _p = pos[i];
		push();
			translate(_p.x,_p.y,_p.z);
			rect(0,0,99,99);
		pop();
	}
}


