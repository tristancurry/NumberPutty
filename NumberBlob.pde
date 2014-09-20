//Adapted from

// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A ball with a number in

class NumberBlob {

  // We need to keep track of a Body and a width and height
  Body body;
  
  float posX;
  float posY;
  float diam;
  int value;
  color col;
  
  float angle;
  
  boolean dead;
  Vec2 pos;


  // Constructor
  NumberBlob(float posX_, float posY_, float diam_, int value_, color col_ ) {
    posX = posX_;
    posY = posY_;
    //posX = constrain(posX, 20, width - 20);
    //posY = constrain(posY, 20, height - 20);
    diam = diam_;
    col = col_;
    value = value_;
    dead = false;
    


  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  //this function is used to test if some coords are within the shape
  boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }





}
