import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;


//NUMBER PUTTY
//Tristan Miller 2014
Box2DProcessing box2d;

int pixelsPerInch;
int pixelsPerCM;

ArrayList boundaries;
ArrayList ballList;
ArrayList boxList;

Spring spring;

PFont t;

void setup() {

  size(960, 540);  // size always goes first!
  if (frame != null) {
    frame.setResizable(true);
    frame.setBackground(new java.awt.Color(0,0,0));
  }
  
  background(0);
  //work out dot pitch of screen
  pixelsPerInch = java.awt.Toolkit.getDefaultToolkit().getScreenResolution();
  pixelsPerCM = int(round(pixelsPerInch/2.55));
  
  //Initialise box2d physics, create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  // Add a bunch of fixed boundaries
  boundaries = new ArrayList();
  boundaries.add(new Boundary(width/2, height-5, width, 10, 0));
  boundaries.add(new Boundary(width/2, 5, width, 10, 0));
  boundaries.add(new Boundary(width-5, height/2, 10, height, 0));
  boundaries.add(new Boundary(5, height/2, 10, height, 0));
  
  spring = new Spring();
  
  
  boxList = new ArrayList();
  for (int i = 0; i < 10; i++) {
    NumberBox newBox = new NumberBox (width/2, height/2, 96, 1, color(150));
    boxList.add(newBox);

  }
}




void draw() {
  background(0);
  
  box2d.step();
  
  spring.update(mouseX, mouseY);
  


    for (int i = 0; i < boundaries.size (); i++) {
    Boundary wall = (Boundary) boundaries.get(i);
    wall.display();
  }
  
    for (int i = 0; i < boxList.size (); i++) {
    NumberBox thisBox = (NumberBox) boxList.get(i);
    thisBox.display();
  }
}

