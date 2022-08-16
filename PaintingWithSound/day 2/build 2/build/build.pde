int    stageW     = 900;
int    stageH     = 900;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

int whichColor = 0; // 0 = red / 1 = blue

void settings() {
	size(stageW,stageH,P3D);
}

void setup(){
	background(clrBG);
}

void draw() {
	background(clrBG);

	if(whichColor == 0) {
		drawRed();
	} else {
		drawBlue();
	}
}

void keyPressed() {
	switch (key) {
		case '1': whichColor = 0; break;
		case '2': whichColor = 1; break;
		
	}
}