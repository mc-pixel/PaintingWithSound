void drawPolarWindow(){
	showVisualizer=false;
	masterRZ.nextRaw();

	push();
		translate(stageW/2, stageH/2, 0);
		perspective(PI/3.0, (float)(width*2)/(height*2), 0.1, 1000000);
		rotateZ(radians(masterRZ.curr()));

		for (int i = 0; i < numAssets; ++i) {

			HOscillator _oscZ = oscZ[i];
			float _aZ = map(myAudioData[ 0 ], 0, myAudioMax, 0.2, 1.0);
			_oscZ.speed(_aZ);
			_oscZ.nextRaw(); 

			HOscillator _oscS = oscS[i];
			float _aS = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, 0.05, 2.0);
			_oscS.speed(_aS);
			_oscS.nextRaw(); 

			push();
				translate(pos[i].x, pos[i].y, pos[i].z + _oscZ.curr() );
				float d = dist(layout.offsetX(), layout.offsetY(), pos[i].x, pos[i].y);
				scale(d * _oscS.curr() );

				float wave = sin( clrCount+(i*clrOffset) );
				float waveMap = map(wave, -1, 1, 0, clrsW);
				tint( clrs.get((int)waveMap,0), 255 );

				buildCube(tex[0], tex[1], tex[2], tex[3], tex[4], tex[5]);
			pop();
		}
	pop();

	push();
		translate((stageW/2)-(roseWindow.width/2), (stageH/2)-(roseWindow.height/2), 0);
		//perspective(PI/3.0, (float)(width*2)/(height*2), 0.1, 1000000);
		hint(DISABLE_DEPTH_TEST);
		strokeWeight(0);
		noStroke();
		fill(#FF3300, 245);
		// ellipse(0, 0, 300, 300);
		image(roseWindow, startRosPosX,startRosPosY);
		for (int i = 0; i < 10000; ++i)  {
			rotate(radians(i));
		}
		hint(ENABLE_DEPTH_TEST);
	pop();
} 
