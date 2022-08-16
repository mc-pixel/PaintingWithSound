int    stageW     = 900;
int    stageH     = 900;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

void settings() {
	size(stageW,stageH,P3D);
}

void setup(){
	background(clrBG);
	//surface.setLocation(100,100);//position where the window goes 
}

void draw() {
	background(clrBG);

	strokeWeight(0);
	noStroke();
	fill(#0095a8);
	rect(50,50,300,300);

}
/*git compare*/