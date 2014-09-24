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

int totalElements;
int totalValue;

float controlDiameterCM = 1;
float controlPaddingPC = 0.02;

int budget = 72;

ArrayList boundaries;
ArrayList blobList;
Button[] buttons;
int[] species;
Scoop myScoop;

Spring spring;

PFont font12;
PFont font20;
PFont font42;

void setup() {

  size(round(0.8*displayWidth), round(0.8*displayHeight));  // size always goes first!


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



  for (int i = 0; i < 6; i++) {
    NumberBlob newBlob = new NumberBlob ((arenaWidth - bucketWidth)/2, height/2, floor(pow(i+1, (1/3.))*pixelsPerCM), i+1, color(150), "ball");
    blobList.add(newBlob);
  }

  makeButtons();

  species = new int[2*budget + 1];

  myScoop = new Scoop(11, arenaHeight - 11, 5*pixelsPerCM, 5*pixelsPerCM, color(80));


  background(0);
  //blendMode(SCREEN);
  smooth();
  

}




void draw() {
  background(0);

  fill(255);
  textAlign(CENTER);
  textFont(font12);
  textSize(12);

  text("Drag and release the blobs to throw them around.", (arenaWidth - bucketWidth)/2, 0.2*arenaHeight);
  text("Double-click the blobs to smash them into smaller bits!", (arenaWidth - bucketWidth)/2, 0.25*arenaHeight);

  text("All controls are available here...", (arenaWidth - bucketWidth)/2, 0.35*arenaHeight);
  text("...but will only be slowly introduced in the final rev.", (arenaWidth - bucketWidth)/2, 0.40*arenaHeight);

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
    if (!thisBlob.newborn) {
      constrainBlobToArena(thisBlob);

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

  toggleButtonActivation();




  handleBlobs();

  myScoop.display();
  spring.display();
  displayLabels();
  renderButtons(buttons);

  box2d.step();
}
