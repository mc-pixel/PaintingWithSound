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
	background(clrs[4]);

	strokeWeight(0);
	noStroke();
	fill(clrs[1]);
	rect(50,50,300,300);

}
/*git compare*/