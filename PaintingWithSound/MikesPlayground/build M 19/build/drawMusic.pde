void drawMusic(){
	showVisualizer = true;
	for (int i = 0; i < stageH/4; ++i) {
		audioUpdate();
		translate(0,(0.5+i));
		audioUpdate();
	}
}