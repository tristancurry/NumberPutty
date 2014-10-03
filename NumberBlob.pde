//NumberBlob - Tristan Miller September 2014

//Adapted from
// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A ball or box with a number in

class NumberBlob {

  // We need to keep track of a Body and a width and height
  Body body;

  float posX;
  float posY;
  float diam;
  int value;
  color col;
  String shape;

  int lastClicked; //stores frameCount of when last clicked.

  float angle;
  boolean newborn; //used to prevent certain actions between instantiation and the first following Box2D step
  boolean dead; //used to queue for deletion
  boolean held;
  Vec2 pos;


  // Constructor
  NumberBlob(float posX_, float posY_, float diam_, int value_, color col_, String shape_ ) {
    posX = posX_;
    posY = posY_;

    diam = diam_;

    value = value_;
    col = col_;

    shape = shape_;

    lastClicked = 0;
    newborn = true;
    dead = false;
    held = false;


    makeBody(new Vec2(posX, posY), diam);
    body.setUserData(this);
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

  void display() {

    // We look at each body and get its screen position
    pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    angle = -1*body.getAngle();


    textAlign(PConstants.CENTER, PConstants.CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);

    if (lastClicked > 0 && frameCount - lastClicked < 3 || held) {
      fill(255);
    } else {
      fill(col);
    }
    noStroke();

    if (shape == "ball") {
      ellipseMode(PConstants.CENTER);
      ellipse(0, 0, 0.99*diam, 0.99*diam);
    } else {
      rectMode(PConstants.CENTER);
      rect(0, 0, 0.99*diam, 0.99*diam);
    } 


    //draw the text
    if (lastClicked > 0 && frameCount - lastClicked < 3 || held) {
      fill(40);
      stroke(40);
      blobText();
    } else {
      translate(1, 1);
      fill(40);
      stroke(40);
      blobText();
      translate(-1, -1);
      fill(255*round((255 - red(col))/255), 255*round((255 - green(col))/255), 255*round((255 - blue(col))/255));
      stroke(255*round((255 - red(col))/255), 255*round((255 - green(col))/255), 255*round((255 - blue(col))/255));
      blobText();
    }

    popMatrix();
  }

  // This function adds the blob to the box2d world
  void makeBody(Vec2 center, float diam_) {
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);


    if (shape == "ball") {
      // Make the body's shape a circle
      CircleShape cs = new CircleShape();
      cs.m_radius = box2d.scalarPixelsToWorld(diam/2);


      // Define a fixture
      FixtureDef fd = new FixtureDef();
      fd.shape = cs;
      // Parameters that affect physics
      fd.density = 1;
      fd.friction = 0.6;
      fd.restitution = 0.4;

      body.createFixture(fd);
    } else {

      // Define a polygon (this is what we use for a rectangle)
      PolygonShape sd = new PolygonShape();
      float box2dWidth = box2d.scalarPixelsToWorld(diam/2);
      float box2dHeight = box2d.scalarPixelsToWorld(diam/2);
      sd.setAsBox(box2dWidth, box2dHeight);

      // Define a fixture
      FixtureDef fd = new FixtureDef();
      fd.shape = sd;

      // Parameters that affect physics
      fd.density = 1;
      fd.friction = 0.5;
      fd.restitution = 0.4;

      body.createFixture(fd);
    }


    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(-5, 5)));
    body.setAngularVelocity(random(-5, 5));
  }

  void blobText() {


    textFont(font20);
    textSize(0.5*pixelsPerCM);
    text(value, 0, 0);

    //do a thing to make 9 and 6 distinguishable
    if (value == 6 || value == 9) {
      strokeWeight(2);
      line(-0.3*textWidth(str(value)), 1+ 0.5*20, 0.3*textWidth(str(value)), 1+ 0.5*20);
    }
  }
}
