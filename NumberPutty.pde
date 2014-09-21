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


float controlDiameterCM = 1;
float controlPaddingPC = 0.02;

int budget = 72;

ArrayList boundaries;
ArrayList blobList;


Spring spring;

PFont font12;
PFont font20;

void setup() {

  size(1024, 640);  // size always goes first!
  if (frame != null) {
    frame.setResizable(true);
    frame.setBackground(new java.awt.Color(255, 255, 255));
  }


  //work out dot pitch of screen
  pixelsPerInch = java.awt.Toolkit.getDefaultToolkit().getScreenResolution();
  pixelsPerCM = int(round(pixelsPerInch/2.55));

  arenaWidth = 0.8*(width - 2*controlPaddingPC*width - controlDiameterCM*pixelsPerCM);
  arenaHeight = 0.95*height;


  int budgetBasedOnArena = int(floor(0.5*arenaHeight*(arenaWidth)/(sq(pixelsPerCM))));
  println(budgetBasedOnArena);
  if (budgetBasedOnArena < budget) {
    budget = budgetBasedOnArena;
  }

  bucketWidth = pow(budget, (1/3.))*pixelsPerCM;
  if (bucketWidth > arenaHeight/2) {
    bucketWidth = arenaHeight/2;
    budget = int(floor(pow(bucketWidth/pixelsPerCM, 3)));
  }
  if (bucketWidth > arenaWidth/2) {
    bucketWidth = arenaWidth/2;
    budget = int(floor(pow(bucketWidth/pixelsPerCM, 3)));
  }

  //Initialise box2d physics, create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -60);

  // Add a bunch of fixed boundaries
  boundaries = new ArrayList();
  boundaries.add(new Boundary(arenaWidth/2, arenaHeight - 5, arenaWidth, 10, 0));
  boundaries.add(new Boundary(arenaWidth/2, 5, arenaWidth, 10, 0));
  boundaries.add(new Boundary(arenaWidth-5, arenaHeight/2, 10, arenaHeight, 0));
  boundaries.add(new Boundary(5, arenaHeight/2, 10, arenaHeight, 0));
  boundaries.add(new Boundary(arenaWidth - bucketWidth - 20, (arenaHeight + bucketWidth + 15)/2, 10, arenaHeight - bucketWidth - 15, 0));

  spring = new Spring();


  blobList = new ArrayList();
  for (int i = 0; i < 10; i++) {
    NumberBlob newBlob = new NumberBlob (width/2, height/2, 1*pixelsPerCM, 1, color(150), "box");
    blobList.add(newBlob);
  }

  for (int i = 0; i < 3; i++) {
    NumberBlob newBlob = new NumberBlob (width/2, height/2, floor(pow(5, (1/3.))*pixelsPerCM),5, color(150), "box");
    blobList.add(newBlob);
  }

  for (int i = 0; i < 1; i++) {
    NumberBlob newBlob = new NumberBlob (width/2, height/2, floor(pow(budget, (1/3.))*pixelsPerCM), budget, color(150), "box");
    blobList.add(newBlob);
  }

  font12 = loadFont("ChicagoFLF-12.vlw");
  font20 = loadFont("ChicagoFLF-20.vlw");
  background(0);
  
  smooth();
  
  
  
  
}




void draw() {
  println(mouseX);
  background(0);
  
  //temporary labels
  fill(255);
  textFont(font12);
  textSize(12);
  text("Left-drag to sling the blobs around.", arenaWidth/2,0.05*arenaHeight);
  text("Right-click to switch between balls and boxes :D (temporary assignment).", arenaWidth/2,0.1*arenaHeight);
  text("This will be toggled by a button, as will the blob-explosion cursor.", arenaWidth/2,0.15*arenaHeight);
  pushMatrix();
  translate(arenaWidth - 0.5*bucketWidth, arenaHeight/2);
  rotate(HALF_PI);

  text("This is where you put blobs to be combined.", 0,0);
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

  spring.display();
}


void mousePressed() {
  // Check to see if the mouse was clicked on the box
  for (int i = 0; i < blobList.size (); i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);

    if (thisBlob.contains(mouseX, mouseY)) {
      // And if so, bind the mouse location to the box with a spring
      if (mouseButton == LEFT) {
        spring.bind(mouseX, mouseY, thisBlob);
      }
      //} else if (mouseButton == RIGHT && thisBox.value > 1 && !exploding) {
      // explode(thisBox);
      //thisBox.dead = true;
      //}
    }
  }
}


void mouseReleased() {
  spring.destroy();
  if (mouseButton == RIGHT) {
    swapShape();
  }
}

/*
swapShape() has to 
1/instantiate new blobs of the opposite type into a local ArrayList
2/pass the corresponding, existing blobs' parameters to the new blobs
3/remove the original blobs (of the old shape) from the Box2D world and clear the input ArrayList
4/instantiate blobs of the desired shape into the input ArrayList from the local ArrayList
5/pass the corresponding parameters to these blobs
6/remove the local ArrayList's blobs from the world and from memory
*/
void swapShape() {
  ArrayList tempList = new ArrayList();
  int blobPop = blobList.size();
  for (int i = 0; i < blobPop; i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);

    String nextShape = "";
    if (thisBlob.shape == "ball") {
      nextShape = "box";
    } else {
      nextShape = "ball";
    }

    NumberBlob tempBlob = new NumberBlob(thisBlob.pos.x, thisBlob.pos.y, thisBlob.diam, thisBlob.value, thisBlob.col, nextShape);
    tempBlob.body.setTransform(tempBlob.body.getPosition(), thisBlob.body.getAngle());
    tempBlob.body.setLinearVelocity(thisBlob.body.getLinearVelocity());
    tempBlob.body.setAngularVelocity(thisBlob.body.getAngularVelocity());
    tempList.add(tempBlob);
    thisBlob.killBody();
  }

  blobList = new ArrayList();


  for (int i = 0; i < tempList.size (); i++) {
    NumberBlob tempBlob = (NumberBlob) tempList.get(i);
    NumberBlob replaceBlob = new NumberBlob(tempBlob.posX, tempBlob.posY, tempBlob.diam, tempBlob.value, tempBlob.col, tempBlob.shape);
    replaceBlob.body.setTransform(replaceBlob.body.getPosition(), tempBlob.body.getAngle());
    replaceBlob.body.setLinearVelocity(tempBlob.body.getLinearVelocity());
    replaceBlob.body.setAngularVelocity(tempBlob.body.getAngularVelocity());
    blobList.add(replaceBlob);
    tempBlob.killBody();
  }
}

