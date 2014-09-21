//NUMBER PUTTY
//Tristan Miller 2014


import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;



Box2DProcessing box2d;

int pixelsPerInch;
int pixelsPerCM;
float arenaWidth;
float arenaHeight;
float bucketWidth;

boolean smashMode = false;
boolean exploding = false;
boolean zeroAllowed = true;
boolean zeroSplittingAllowed = true;
boolean unitsAllowed = true;
boolean negativeAllowed = true;
boolean budgetProblem = false;

int kludgeTally = 0;
int totalElements;
int totalValue;

float controlDiameterCM = 1;
float controlPaddingPC = 0.02;

int budget = 72;

ArrayList boundaries;
ArrayList blobList;
Button[] buttons;
int[] species;


Spring spring;

PFont font12;
PFont font20;
PFont font42;

void setup() {

  size(960, 540);  // size always goes first!
  /*if (frame != null) {
   frame.setResizable(true);
   frame.setBackground(new java.awt.Color(255, 255, 255));
   }*/

  font12 = loadFont("ChicagoFLF-12.vlw");
  font20 = loadFont("ChicagoFLF-20.vlw");
  font42 = loadFont("ChicagoFLF-42.vlw");

  //work out dot pitch of screen
  pixelsPerInch = java.awt.Toolkit.getDefaultToolkit().getScreenResolution();
  pixelsPerCM = int(round(pixelsPerInch/2.55));



  //Initialise box2d physics, create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -60);

  makeArena();

  spring = new Spring();


  blobList = new ArrayList();



  for (int i = 0; i < 11; i++) {
    NumberBlob newBlob = new NumberBlob ((arenaWidth - bucketWidth)/2, height/2, floor(pow(i+1, (1/3.))*pixelsPerCM), i+1, color(150), "ball");
    blobList.add(newBlob);
  }

  makeButtons();

  species = new int[2*budget + 1];

  background(0);

  smooth();
}




void draw() {
  background(0);

  fill(255);
  textAlign(CENTER);
  textFont(font12);
  textSize(12);
  if (!smashMode) {
    text("Drag and release the blobs to throw them around.", (arenaWidth - bucketWidth)/2, 0.2*arenaHeight);
    text("Or press the top-left button to activate the smashing tool!", (arenaWidth - bucketWidth)/2, 0.25*arenaHeight);
  } else {
    text("Click the blobs to smash them into smaller bits!", (arenaWidth - bucketWidth)/2, 0.2*arenaHeight);
    text("Or press the top-left button if you want to throw them again!", (arenaWidth - bucketWidth)/2, 0.25*arenaHeight);
  }
  text("All controls are available but will be introduced gradually in the final rev.", (arenaWidth - bucketWidth)/2, 0.35*arenaHeight);

  totalElements = 0;
  totalValue = 0;
  for (int i = 0; i< species.length; i++) {
    species[i] = 0;
  }
  spring.update(mouseX, mouseY);

  fill(40);
  rectMode(CENTER);
  noStroke();
  pushMatrix();
  translate(arenaWidth - 0.5*bucketWidth - 12.5, arenaHeight/2);
  rect(0, 0, bucketWidth, arenaHeight -25);
  popMatrix();
  for (int i = 0; i < boundaries.size (); i++) {
    Boundary wall = (Boundary) boundaries.get(i);
    wall.display();
  }


  for (int i = 0; i < blobList.size (); i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);
    if (thisBlob.value < 0) {
      thisBlob.col = color(105);
    }
    thisBlob.display();

    //calculate various totals
    totalValue = totalValue + thisBlob.value;
    totalElements = totalElements + abs(thisBlob.value);
    if (thisBlob.value == 0) {
      totalElements++;
    }
    species[thisBlob.value + budget]++;
  }

  if (totalElements >= budget) {
    budgetProblem = true;
    zeroSplittingAllowed = false;
    buttons[2].state="inactive";
    if (totalValue >= budget) {
      buttons[1].state = "inactive";
      buttons[3].state = "available";
    } else if (totalValue <= -1*budget) {
      buttons[3].state = "inactive";
      buttons[1].state = "available";
    } else {
      buttons[3].state = "inactive";
      buttons[1].state = "inactive";
    }
  } else if (budgetProblem) {
    if (unitsAllowed) {
      buttons[1].state = "available";
    }
    if (negativeAllowed) {
      buttons[3].state = "available";
    }
    if (zeroAllowed) {
      buttons[2].state = "available";
      zeroSplittingAllowed = true;
    }
    budgetProblem = false;
  }









  spring.display();
  handleBlobs();


  //temporary labels


    fill(40, 100);
  rectMode(CENTER);
  noStroke();
  pushMatrix();
  translate(arenaWidth - 0.5*bucketWidth - 12.5, arenaHeight/2);
  rect(0, 0, bucketWidth, arenaHeight -25);
  popMatrix();
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
  translate((width+arenaWidth)/2, 180);
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


  renderButtons(buttons);
  drawHint();


  box2d.step();
}

