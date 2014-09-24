void makeArena(float mD, float bT, float cP){
  arenaWidth = 0.8*(width - 2*cP*width - mD);
  arenaHeight = 0.95*height;

  //modify shape of arena and population budget so that user can still do things...
  int budgetBasedOnArena = int(floor(0.5*arenaHeight*(arenaWidth)/(sq(mD))));
  if (budgetBasedOnArena < budget) {
    budget = budgetBasedOnArena;
  }

  bucketWidth = pow(budget, (1/3.))*mD;
  if (bucketWidth > arenaHeight/2) {
    bucketWidth = arenaHeight/2;
    budget = int(floor(pow(bucketWidth/mD, 3)));
  }
  if (bucketWidth > arenaWidth/2) {
    bucketWidth = arenaWidth/2;
    budget = int(floor(pow(bucketWidth/mD, 3)));
  }
  
  // Add a bunch of fixed boundaries
  boundaries = new ArrayList();
  boundaries.add(new Boundary(arenaWidth/2, arenaHeight - bT/2, arenaWidth, bT, 0));
  boundaries.add(new Boundary(arenaWidth/2, bT/2, arenaWidth, bT, 0));
  boundaries.add(new Boundary(arenaWidth-(bT/2), arenaHeight/2, bT, arenaHeight, 0));
  boundaries.add(new Boundary(bT/2, arenaHeight/2, bT, arenaHeight, 0));
  Boundary bucketBound = new Boundary(arenaWidth - bucketWidth, (arenaHeight + bucketWidth)/2, bT, arenaHeight - bucketWidth - bT, 0);
  Vec2 p = new Vec2(0,0);
  p = box2d.coordWorldToPixels(bucketBound.body.getPosition());

  p.x = p.x - 1.5*bT;
  p.y = p.y + bT/2;
  bucketBound.posX = p.x;
  bucketBound.posY = p.y;

  bucketBound.body.setTransform(box2d.coordPixelsToWorld(p), bucketBound.body.getAngle());
  boundaries.add(bucketBound);
  

}

void drawBucket(float bT, color c){
  fill(c);
  rectMode(CENTER);
  noStroke();
  pushMatrix();
  translate((arenaWidth - bT)- 0.5*bucketWidth, arenaHeight/2);
  rect(0, 0, bucketWidth, arenaHeight - 2*bT);
  popMatrix();
}
