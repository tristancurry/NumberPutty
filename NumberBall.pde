//Adapted from

// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A ball with a number in

class NumberBall extends NumberBlob{



  // Constructor
  NumberBall(float posX_, float posY_, float diam_, int value_, color col_ ) {
    super(posX_, posY_, diam_, value_, col_);

    makeBody(new Vec2(posX, posY), diam);
  }



  // Drawing the ball
  void display() {
    // We look at each body and get its screen position
    pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    angle = body.getAngle();

    ellipseMode(PConstants.CENTER);
    textAlign(PConstants.CENTER, PConstants.CENTER);
    textSize(20);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    fill(col);
    noStroke();
    ellipse(0, 0, diam, diam);
    fill(255);
    text(value, 0, 0);

    popMatrix();
  }


  // This function adds the ball to the box2d world
  void makeBody(Vec2 center, float diam_) {
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld((diam + 5)/2);


    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
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

