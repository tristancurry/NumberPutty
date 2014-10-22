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
float minDiamCM = 1.2;
float minDiam;
float arenaWidth;
float arenaHeight;
float bucketWidth;


boolean exploding = false;
boolean zeroAllowed = false;
boolean zeroSplittingAllowed = false;
boolean unitsAllowed = true;
boolean negativeAllowed = true;
boolean budgetProblem = false;
boolean colSet = false;


int totalElements;
int totalValue;


float controlPaddingPC = 0.02;

int budget = 72;

ArrayList boundaries;
float boundThickness;
ArrayList blobList;
Button[] buttons;
int[] species;
Scoop myScoop;

Spring spring;

PFont font12;
PFont font20;
PFont font42;

color posCol = color(150);
color bucketCol = color(50);
color bgCol = color(0,0,40);
color newCol = color(random(70,200), random(70,200), random(70,200));

PImage boxPicker;
PImage ballPicker;
ColPicker yourPicker;

void setup() {

  size(round(0.6*displayWidth), round(0.6*displayHeight));  // size always goes first!


  font12 = loadFont("ChicagoFLF-12.vlw");
  font20 = loadFont("ChicagoFLF-20.vlw");
  font42 = loadFont("ChicagoFLF-42.vlw");

  boxPicker = loadImage("boxPalette.png");
  ballPicker = loadImage("ballPalette.png");

  yourPicker = new ColPicker(0, 0, 5, ballPicker, "ball");

  //work out dot pitch of screen
  pixelsPerInch = java.awt.Toolkit.getDefaultToolkit().getScreenResolution();
  pixelsPerCM = int(round(pixelsPerInch/2.55));

  minDiam = pixelsPerCM*minDiamCM;
  boundThickness = 15;


  //Initialise box2d physics, create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -60);

  makeArena(minDiam, boundThickness, controlPaddingPC);

  spring = new Spring();


  blobList = new ArrayList();

  int n = int(floor((-1 + sqrt(1 + 8*budget))/2));  //using reverse Gauss trick to provide initial sequence of blob values


    NumberBlob newBlob = new NumberBlob ((arenaWidth - bucketWidth)/2, height/2, floor(pow(10, (1/3.))*minDiam), 10, posCol, "ball");
    blobList.add(newBlob);


  makeButtons();

  species = new int[2*budget + 1];


  float scoopWidth = 3*minDiam;
  scoopWidth = constrain(scoopWidth, 0.2*(arenaWidth - bucketWidth), 0.4*(arenaWidth - bucketWidth));
  if (scoopWidth > 1.5*minDiam) {
    myScoop = new Scoop(boundThickness + 1, arenaHeight - boundThickness - 1, scoopWidth, scoopWidth, color(1.5*red(bucketCol), 1.5*green(bucketCol), 1.5*blue(bucketCol)));
  }

  background(0);
  smooth();
}




void draw() {
  if(totalElements >= budget){
    background(50,0,0);
  } else {
  background(bgCol);
  }
  

  
  
  if(!colSet) newCol = color(random(70,200), random(70,200), random(70,200));
  fill(255);
  textAlign(CENTER);
  textFont(font12);
  textSize(12);




  yourPicker.pWidth = 0.7*(width - arenaWidth);
  yourPicker.pHeight = yourPicker.pWidth;
  yourPicker.posX = 0.5*(width + arenaWidth);
  yourPicker.posY = height - 0.6*yourPicker.pHeight;
yourPicker.selector = true;
  yourPicker.display();


  if (yourPicker.dragging && yourPicker.contains(mouseX, mouseY)) {
    yourPicker.selX = mouseX;
    yourPicker.selY = mouseY;
    loadPixels();
    newCol = pixels[mouseY*width + mouseX];
  }

  spring.update(mouseX, mouseY);

  drawBucket(boundThickness, bucketCol);


  for (int i = 0; i < boundaries.size (); i++) {
    Boundary wall = (Boundary) boundaries.get(i);
    wall.display();
  }

  toggleButtonActivation();

  handleBlobs();
  countBlobs();

  if (myScoop != null) {
    myScoop.display();
  }

  spring.display();

  drawBucket(boundThickness, color(red(bucketCol), green(bucketCol), blue(bucketCol), 100));

  displayLabels();

  renderButtons(buttons);

  box2d.step();
}
