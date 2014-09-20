//Adapted from

// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A box with a number inscribed

class NumberBox extends NumberBlob {

  // Constructor
  NumberBox(float posX_, float posY_, float diam_, int value_, color col_ ) {
    super(posX_, posY_, diam_, value_, col_);

    println(posX);

    // Add the box to the box2d world
    makeBody(new Vec2(posX, posY), diam, diam);
    body.setUserData(this);
  }



  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    angle = body.getAngle();

    rectMode(PConstants.CENTER);
    textAlign(PConstants.CENTER, PConstants.CENTER);
    textSize(20);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    fill(col);
    noStroke();
    rect(0, 0, diam, diam);
    fill(255);
    text(value, 0, 0);

    popMatrix();
  }


  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float boxWidth_, float boxHeight_) {
    // Define and create the body
    println(center);
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dWidth = box2d.scalarPixelsToWorld(boxWidth_/2);
    float box2dHeight = box2d.scalarPixelsToWorld(boxHeight_/2);
    sd.setAsBox(box2dWidth, box2dHeight);


    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;

    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.5;
    fd.restitution = 0.4;

    body.createFixture(fd);
    //body.setMassFromShapes();

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(-5, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
}

