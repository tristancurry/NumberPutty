//Adapted from:
// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A fixed boundary class (now incorporates angle)

class Boundary {

  // A boundary is a simple rectangle with x,y,width,and height
  float posX;
  float posY;
  float boundaryWidth;
  float boundaryHeight;
  // But we also have to make a body for box2d to know about it
  Body b;

 Boundary(float posX,float posY_, float boundaryWidth_, float boundaryHeight_, float angle_) {
    posX = posX_;
    posY = posY_;
    boundaryWidth = boundaryWidth_;
    boundaryHeight = boundaryHeight_;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dWidth = box2d.scalarPixelsToWorld(boundaryWidth/2);
    float box2dHeight = box2d.scalarPixelsToWorld(boundaryHeight/2);
    // We're just a box
    sd.setAsBox(box2dWidth, box2dHeight);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.angle = angle_;
    bd.position.set(box2d.coordPixelsToWorld(posX,posY));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    noFill();
    stroke(255);
    strokeWeight(1);
    rectMode(CENTER);

    float angle = b.getAngle();

    pushMatrix();
    translate(posX,posY);
    rotate(-angle);
    rect(0,0,boundaryWidth,boundaryHeight);
    popMatrix();
  }

}

