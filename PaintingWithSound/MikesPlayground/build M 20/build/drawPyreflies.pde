// *********************************************************************************************

int         numAssets2      = 25;

HOrbiter3D[] orb = new HOrbiter3D[numAssets2];

int          orbStartX = 0;
int          orbStartY = 0;
int          orbStartZ = 0;

float        orbZ_SpeedMin = 0.5;
float        orbZ_SpeedMax = 1.5;

float        orbY_SpeedMin = 0.1;
float        orbY_SpeedMax = 0.5;

int          orbRadius  = 700;

// *********************************************************************************************

HOscillator[] oscS2         = new HOscillator[numAssets2];

// *********************************************************************************************

int[]       myPickedAudio2  = new int[numAssets2];

// *********************************************************************************************


void drawPyreflies() {
	//background( clrBG );

// ************************************************************************************
	//lights();

	hint(DISABLE_DEPTH_TEST);


	push();
		translate(stageW/2, stageH/2, 0);
		perspective(PI/3.0, (float)(width*2)/(height*2), 0.1, 1000000);

		for (int i = 0; i < numAssets2; ++i) {

			HOscillator _oscS2 = oscS2[i];
			float _aS2 = map(myAudioData[ myPickedAudio2[i] ], 0, myAudioMax, 0.0, 2.0);
			_oscS2.speed(_aS2);
			_oscS2.nextRaw(); 

			HOrbiter3D _orb = orb[i];

			float _orbZ = map(myAudioData[ myPickedAudio2[i] ], 0, myAudioMax, orbZ_SpeedMin, orbZ_SpeedMax);
			// float _orbY = map(myAudioData[ myPickedAudio[i] ], 0, myAudioMax, orbY_SpeedMin, orbY_SpeedMax);
			// _orb.zSpeed( _orbZ ).ySpeed( _orbY );

			_orb._run();
			PVector pt = _orb.getNextPoint();


			push();
				translate(pt.x, pt.y, pt.z );
				scale(_oscS2.curr());

				float wave2 = sin( clrCount2+(i*clrOffset2) );
				float waveMap2 = map(wave2, -1, 1, 0, clrsW2);
				tint( clrs2.get((int)waveMap2,0), 255 );

				buildCube2(tex2[0], tex2[0], tex2[0], tex2[0], tex2[0], tex2[0]);
			pop();
		}
	pop();

// ************************************************************************************

	noLights();
	audioUpdate();
	strokeWeight(0);
	noStroke();
	fill(#000000, 10);
	rect(0,0,stageW,stageH);
}

void buildCube2(PImage _t1, PImage _t2, PImage _t3, PImage _t4, PImage _t5, PImage _t6) {
	strokeWeight(0);
	noStroke();

	// back
	beginShape(QUADS);
		texture(_t1);
		vertex( (0.5), -(0.5), -(0.5),   0, 0);
		vertex(-(0.5), -(0.5), -(0.5),   1, 0);
		vertex(-(0.5),  (0.5), -(0.5),   1, 1);
		vertex( (0.5),  (0.5), -(0.5),   0, 1);
	endShape(CLOSE);

	/*// left
	beginShape(QUADS);
		texture(_t2);
		vertex(-(0.5), -(0.5), -(0.5),   0, 0);
		vertex(-(0.5), -(0.5),  (0.5),   1, 0);
		vertex(-(0.5),  (0.5),  (0.5),   1, 1);
		vertex(-(0.5),  (0.5), -(0.5),   0, 1);
	endShape(CLOSE);

	// right
	beginShape(QUADS);
		texture(_t3);
		vertex( (0.5), -(0.5),  (0.5),   0, 0);
		vertex( (0.5), -(0.5), -(0.5),   1, 0);
		vertex( (0.5),  (0.5), -(0.5),   1, 1);
		vertex( (0.5),  (0.5),  (0.5),   0, 1);
	endShape(CLOSE);

	// top
	beginShape(QUADS);
		texture(_t4);
		vertex(-(0.5), -(0.5), -(0.5),   0, 0);
		vertex( (0.5), -(0.5), -(0.5),   1, 0);
		vertex( (0.5), -(0.5),  (0.5),   1, 1);
		vertex(-(0.5), -(0.5),  (0.5),   0, 1);
	endShape(CLOSE);

	// bottom
	beginShape(QUADS);
		texture(_t5);
		vertex(-(0.5),  (0.5),  (0.5),   0, 0);
		vertex( (0.5),  (0.5),  (0.5),   1, 0);
		vertex( (0.5),  (0.5), -(0.5),   1, 1);
		vertex(-(0.5),  (0.5), -(0.5),   0, 1);
	endShape(CLOSE);

	// front
	beginShape(QUADS);
		texture(_t6);
		vertex(-(0.5), -(0.5),  (0.5),   0, 0); // x, y, z, u, v
		vertex( (0.5), -(0.5),  (0.5),   1, 0); // x, y, z, u, v
		vertex( (0.5),  (0.5),  (0.5),   1, 1); // x, y, z, u, v
		vertex(-(0.5),  (0.5),  (0.5),   0, 1); // x, y, z, u, v
	endShape(CLOSE);*/
}
