//Scoop
//Tristan Miller, September 2014

//An L-bracket with which the user can pick up multiple balls, using Box2D physics.

class Scoop {

  //need to keep track of a body, and the dimensions of the scoop.
  Body body;

  float posX; //coordinates (Processing) of the corner.
  float posY;

  float scoopWidth;
  float scoopHeight;
  int thickness;  // how thick the walls of the scoop are (pixels)

  color col;

  //Constructor (runs once at object instantiation)

  Scoop(float posX_, float posY_, float scoopWidth_, float scoopHeight_, color col_) {

    posX = posX_;
    posY = posY_;
    scoopWidth = scoopWidth_;
    scoopHeight = scoopHeight_;
    thickness = 10;
    col = col_;

    //add the scoop to the box2d world

    makeBody(new Vec2(posX, posY));
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center) {

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    Vec2 offsetBottom = new Vec2(scoopWidth/2, -thickness/2);
    Vec2 offsetSide = new Vec2(thickness/2, -scoopHeight/2);


    PolygonShape bottom = new PolygonShape();
    float box2dWidth = box2d.scalarPixelsToWorld(scoopWidth/2);
    float box2dHeight = box2d.scalarPixelsToWorld(thickness/2);
    bottom.setAsBox(box2dWidth, box2dHeight, offsetBottom, 0);
  

    PolygonShape side = new PolygonShape();
    box2dWidth = box2d.scalarPixelsToWorld(thickness/2);
    box2dHeight = box2d.scalarPixelsToWorld(scoopHeight/2);
    side.setAsBox(box2dWidth, box2dHeight, offsetSide, 0);



    body.createFixture(bottom, 1.0);
    body.createFixture(side, 1.0);

  }
}


