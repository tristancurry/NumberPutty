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

float controlDiameterCM = 1;
float controlPaddingPC = 0.02;

int budget = 72;

ArrayList boundaries;
ArrayList blobList;
Button[] buttons;


Spring spring;

PFont font12;
PFont font20;
PFont font42;

void setup() {

  size(1024, 640);  // size always goes first!
  if (frame != null) {
    frame.setResizable(true);
    frame.setBackground(new java.awt.Color(255, 255, 255));
  }

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
  for (int i = 0; i < 10; i++) {
    NumberBlob newBlob = new NumberBlob (width/2, height/2, 1*pixelsPerCM, 1, color(150), "ball");
    blobList.add(newBlob);
  }
  
  
  for (int i = 0; i < 10; i++) {
    NumberBlob newBlob = new NumberBlob (width/2, height/2, 1*pixelsPerCM, -1, color(255-150), "ball");
    blobList.add(newBlob);
  }

  for (int i = 0; i < 3; i++) {
    NumberBlob newBlob = new NumberBlob (width/2, height/2, floor(pow(5, (1/3.))*pixelsPerCM), 5, color(150), "ball");
    blobList.add(newBlob);
  }

  for (int i = 0; i < 1; i++) {
    NumberBlob newBlob = new NumberBlob (width/2, height/2, floor(pow(budget, (1/3.))*pixelsPerCM), budget, color(150), "ball");
    blobList.add(newBlob);
  }

  makeButtons();
  
  

  background(0);

  smooth();
}




void draw() {
  background(0);



  //temporary labels
  fill(255);
  textFont(font12);
  textSize(12);
  text("Left-drag to sling the blobs around.", arenaWidth/2, 0.05*arenaHeight);
  text("Right-click to switch between balls and boxes :D (temporary assignment).", arenaWidth/2, 0.1*arenaHeight);
  text("This will be toggled by a button, as will the blob-explosion cursor.", arenaWidth/2, 0.15*arenaHeight);
  pushMatrix();
  translate(arenaWidth - 0.5*bucketWidth, arenaHeight/2);
  rotate(HALF_PI);

  text("This is where you put blobs to be combined.", 0, 0);
  text("The 'combine' button will be about halfway up the short wall.", 0, 0.15*bucketWidth);
  translate(0, - bucketWidth);
  text("Information about populations will be shown here.", 0, 0);
  popMatrix();
  pushMatrix();
  translate(width/2, height - 10);
  fill(255);
  text("Tristan Miller 2014. Questions & suggestions to tristan.miller@asms.sa.edu.au", 0, 0);
  popMatrix();
  box2d.step();



  spring.update(mouseX, mouseY);


  for (int i = 0; i < boundaries.size (); i++) {
    Boundary wall = (Boundary) boundaries.get(i);
    wall.display();
  }

  for (int i = 0; i < blobList.size (); i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);
    thisBlob.display();
  }



renderButtons(buttons);





  spring.display();
  handleBlobs();
}










