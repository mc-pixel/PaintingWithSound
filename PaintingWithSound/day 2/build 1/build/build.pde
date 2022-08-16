int    stageW     = 900;
int    stageH     = 900;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

PImage myImg;
void settings() {
	size(stageW,stageH,P3D);
}

void setup(){
	background(clrBG);
	//surface.setLocation(100,100);//position where the window goes 
	myImg = loadImage(pathAssets + "akira.png");
}

void draw() {
	background(clrBG);
	image(myImg, 0, 0);
	surface.setTitle("FPS = " + (int)frameRate);
}
/*git compare*/