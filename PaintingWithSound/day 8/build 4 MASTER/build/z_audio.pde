// ************************************************************************************

void audioSetup() {
	minim = new Minim(this);

	if (myAudioToggle) {
		myAudioPlayer = minim.loadFile(pathAssets + whichAudioFile);
		myAudioPlayer.loop();
		// myAudioPlayer.mute();
		myAudioFFT = new FFT(myAudioPlayer.bufferSize(), myAudioPlayer.sampleRate());
		myAudioFFT.linAverages(myAudioRange);
	} else {
		myAudioInput = minim.getLineIn(Minim.MONO);
		myAudioFFT = new FFT(myAudioInput.bufferSize(), myAudioInput.sampleRate());
		myAudioFFT.linAverages(myAudioRange);
	}

	myAudioFFT.window(FFT.GAUSS);
}

// ************************************************************************************

void audioUpdate() {
	if (myAudioToggle) myAudioFFT.forward(myAudioPlayer.mix);
	else               myAudioFFT.forward(myAudioInput.mix);

	if(showVisualizer) {
		strokeWeight(0);
		noStroke();
		fill(#000000, 245);
		rect(visX, visY, stageW, myAudioMax+30);
	}

	for (int i = 0; i < myAudioRange; ++i) {
		strokeWeight(0);
		noStroke();

		float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
		myAudioIndexAmp+=myAudioIndexStep;
		float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
		myAudioData[i]     = tempIndexCon; // RECODE THE NUMBERS FROM - 0 TO 100

		if (showVisualizer) {
			if(tempIndexCon<=visH)                         fill(#333333); // NO AUDIO
			else if(tempIndexCon>visH && tempIndexCon<=10) fill(#2EA893); // visH to 10
			else if(tempIndexCon>10 && tempIndexCon<=20)   fill(#64BE7A); // 11 to 20
			else if(tempIndexCon>20 && tempIndexCon<=30)   fill(#9AD561); // 21 to 30
			else if(tempIndexCon>30 && tempIndexCon<=40)   fill(#CCEA4A); // 31 to 40
			else if(tempIndexCon>40 && tempIndexCon<=50)   fill(#FFFF33); // 41 to 50
			else if(tempIndexCon>50 && tempIndexCon<=60)   fill(#F8EF33); // 51 to 60
			else if(tempIndexCon>60 && tempIndexCon<=70)   fill(#FFC725); // 61 to 70
			else if(tempIndexCon>70 && tempIndexCon<=80)   fill(#FF9519); // 71 to 80
			else if(tempIndexCon>80 && tempIndexCon<=90)   fill(#FF620C); // 81 to 90
			else                                           fill(#FF3300); // 91 to 100

			rect( visX + (i*visS), ((visY-(visH/2))+(myAudioMax/2))-(tempIndexCon/2), visW, visH+tempIndexCon);

			textSize(14);
			text( (int)myAudioData[i], visX + (i*visS), visY+(myAudioMax+20) );

			strokeWeight(1);
			stroke(#666666);
			noFill();
			line(0, visY, stageW, visY);
			line(0, visY+myAudioMax, stageW, visY+myAudioMax);
			line(0, visY+(myAudioMax+30), stageW, visY+(myAudioMax+30));
		}
	}
	myAudioIndexAmp = myAudioIndex;
}

// ************************************************************************************

void stop() {
	if (myAudioToggle) myAudioPlayer.close();
	else               myAudioInput.close();
	minim.stop();  
	super.stop();
}

// ************************************************************************************








