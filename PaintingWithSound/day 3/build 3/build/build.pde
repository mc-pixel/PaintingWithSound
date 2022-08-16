int    stageW     = 900;
int    stageH     = 900;
color  clrBG      = #242424;
String pathAssets = "../../../assets/";

color[] clrs =  { #ECECEC, #FF3300 , #FF9900, #00616f, #0095a8 };


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

	for (int i = 0; i < clrs.length; ++i) {
		fill(clrs[i]);
		rect(50 + (i*100),50 + (i * 75),100,100);
	}



}
/*git compare*/