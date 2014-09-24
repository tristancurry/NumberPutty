void displayLabels() {
  //temporary labels



  pushMatrix();
  translate(arenaWidth - 0.6*bucketWidth, arenaHeight/2);

  rotate(HALF_PI);
  fill(255);
  textSize(12);
  textFont(font12);
  text("This is where you put blobs to be combined.", 0, -0.30*bucketWidth);
  text("Press the button above this section to do it!", 0, -0.15*bucketWidth);
  text("<--------------------------------------------", 0, 0.0*bucketWidth);
  popMatrix();
  pushMatrix();
  translate((width +arenaWidth)/2, 50);
  textFont(font42);
  textSize(42);
  text("Total : " + totalValue, 0, 0);
  translate(0, 80);
  textFont(font42);
  textSize(42);
  text("pp : " + totalElements, 0, 0);
  translate(0, 80);
  text("budget : " + budget, 0, 0);
  textFont(font12);
  textSize(12);

  popMatrix();
  pushMatrix();
  translate(width/2, height - 10);
  fill(255);
  text("Tristan Miller 2014. Questions & suggestions to tristan.miller@asms.sa.edu.au", 0, 0);
  popMatrix();

  //display the totals
  textSize(20);
  textFont(font20);
  pushMatrix();
  translate((width+arenaWidth)/2, 260);
  fill(255);
  translate(0, 0);
  textAlign(RIGHT);
  for (int i = 0; i<species.length; i++) {
    if (species[i] > 0) {

      text(i-budget + " : ", 0, 0);
      translate(3*textWidth("A"), 0);
      text(species[i], 0, 0);
      translate(-3*textWidth("A"), 20);
    }
  }
  popMatrix();
}
