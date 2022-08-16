int    stageW     = 1200;
int    stageH     = 900;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

String whichImg = pathAssets + "rainbow.png";
PImage clrs;
int whichClr = 100;


void settings() {
	size(stageW,stageH,P3D);
}

void setup(){
	background(clrBG);
	//surface.setLocation(100,100);//position where the window goes 
	clrs = loadImage(whichImg);
}

void draw() {
	background(clrBG);
	image(clrs, 0 ,0);

	strokeWeight(0);
	noStroke();
	fill(clrs.get(whichClr,0));
	rect(50,150,300,300);

}
/*git compare*/