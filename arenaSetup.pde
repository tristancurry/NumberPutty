void makeArena(){
   arenaWidth = 0.8*(width - 2*controlPaddingPC*width - controlDiameterCM*pixelsPerCM);
  arenaHeight = 0.95*height;

  //modify shape of arena and population budget so that user can still do things...
  int budgetBasedOnArena = int(floor(0.5*arenaHeight*(arenaWidth)/(sq(pixelsPerCM))));
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
  
  // Add a bunch of fixed boundaries
  boundaries = new ArrayList();
  boundaries.add(new Boundary(arenaWidth/2, arenaHeight - 5, arenaWidth, 10, 0));
  boundaries.add(new Boundary(arenaWidth/2, 5, arenaWidth, 10, 0));
  boundaries.add(new Boundary(arenaWidth-5, arenaHeight/2, 10, arenaHeight, 0));
  boundaries.add(new Boundary(5, arenaHeight/2, 10, arenaHeight, 0));
  boundaries.add(new Boundary(arenaWidth - bucketWidth - 20, (arenaHeight + bucketWidth + 15)/2, 10, arenaHeight - bucketWidth - 15, 0));

}
