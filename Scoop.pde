//Scoop
//Tristan Miller, September 2014

//A wedge with which the user can pick up multiple balls, using Box2D physics.

class Scoop {

  //need to keep track of a body, and the dimensions of the scoop.
  Body body;

  float posX; //coordinates (Processing) of the corner.
  float posY;
  float angle;
  float scoopWidth;
  float scoopHeight;
  int thickness;  // how thick the walls of the scoop are (pixels)

  color col;

  int lastClicked;
  boolean held;

  Vec2 pos;
  //Constructor (runs once at object instantiation)

  Scoop(float posX_, float posY_, float scoopWidth_, float scoopHeight_, color col_) {


    posX = posX_;
    posY = posY_;
    scoopWidth = scoopWidth_;
    scoopHeight = scoopHeight_;
    thickness = 10;
    col = col_;

    lastClicked = 0;
    held = false;

    //add the scoop to the box2d world

    makeBody(new Vec2(posX, posY));
  }

  boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }

  void display() {

    // We look at the box2d body and get its screen position
    pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    angle = -1*body.getAngle();

    Fixture f = body.getFixtureList(); //first get the Fixture attached to the scoop...
    PolygonShape ps = (PolygonShape) f.getShape();  //then get the Shape attached to the Fixture
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    noStroke();
    if (lastClicked > 0 && frameCount - lastClicked < 3 || held) {
      fill(255);

    } else {
      fill(col);
    }

    
    beginShape();
    //We can loop through that array and convert each vertex from Box2D space to pixels.
      for (int i = 0; i < ps.getVertexCount (); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);





    popMatrix();
  }



  // This function adds the triangular scoop to the box2d world
  void makeBody(Vec2 center) {

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);


    Vec2[] vertices = new Vec2[3]; //create array of vectors
    vertices[0] = box2d.vectorPixelsToWorld(new Vec2(0, 0));
    vertices[1] = box2d.vectorPixelsToWorld(new Vec2(scoopWidth, 0));
    vertices[2] = box2d.vectorPixelsToWorld(new Vec2(0, -scoopHeight));

    PolygonShape ps = new PolygonShape();
    ps.set(vertices, vertices.length);



    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.4;
    fd.restitution = 0.1;


    body.createFixture(fd);


  }
}

