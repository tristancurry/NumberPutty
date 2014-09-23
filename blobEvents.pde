void mergeBlobs() {

  //first see if there is more than one blob in the bucket
  int numberOfBlobs = 0;
  for (int i = 0; i < blobList.size (); i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);
    if (thisBlob.pos.x < arenaWidth && thisBlob.pos.x > arenaWidth - bucketWidth) {
      numberOfBlobs = numberOfBlobs + 1;
    }
  }
  //if so, then add their values to produce a new blob, then remove them
  if (numberOfBlobs > 1) {
    float tally = 0;
    for (int i = 0; i < blobList.size (); i++) {
      NumberBlob thisBlob = (NumberBlob) blobList.get(i);
      if (thisBlob.pos.x < arenaWidth && thisBlob.pos.x > arenaWidth - bucketWidth) {
        tally = tally + thisBlob.value;
        thisBlob.dead = true;
        thisBlob.killBody();
      }
    }
    //if the tally is zero, and zeroBlobs aren't allowed, then don't worry about making a new blob...
    if (tally == 0 && !zeroAllowed) {
    } else {
      float newDiam = pow(abs(tally), 1/3.)*pixelsPerCM;
      //if we did end up with a zeroBlob, please give it a radius bigger than 0.
      if (tally == 0) {
        newDiam = pixelsPerCM;
      }

      NumberBlob newBlob = new NumberBlob(buttons[buttons.length - 1].posX, buttons[buttons.length - 1].posY + (pixelsPerCM + newDiam)/2, newDiam, int(tally), color(random(70,200),random(70,200),random(70,200)), buttons[buttons.length - 1].shape);


      blobList.add(newBlob);
    }
  }
}




void smashBlob(NumberBlob thisBlob) {
  int val = thisBlob.value;
  int frag[] = new int[2];

  //if the value of the blob is not zero, smash it into nearly equal portions
  if (val != 0) {
    frag[0] = int(floor(val/2.0));
  } else {
    //otherwise, randomly decide whether to spawn a pair of zeros, or a -1 +1 pair!
    float coinFlip = random(0, 1);
    if (coinFlip > 0.5) {
      frag[0] = 1;
    } else {
      frag[0] = 0;
    }
  }

  frag[1] = val - frag[0];


  exploding = true;

  for (int i= 0; i<2; i ++) {
    float ang = thisBlob.body.getAngle() + random(0, PI);
    ang = -1*ang;
    Vec2 v = new Vec2(0, 0);
    Vec2 p;
    float d;

    d = pow(abs(frag[i]), 1/3.)*pixelsPerCM;
    d = constrain(d, pixelsPerCM, 10e6);
    p = new Vec2(d*cos(ang), d*sin(ang));

    p.x = p.x+thisBlob.pos.x;
    p.y = p.y + thisBlob.pos.y;
    if (thisBlob.pos.x < arenaWidth - bucketWidth) {
      p.x = constrain(p.x, d, arenaWidth - bucketWidth - d);
    } else {
      p.x = constrain(p.x, arenaWidth - bucketWidth + d, arenaWidth - d);
    }
    p.y = constrain(p.y, d, arenaHeight - d);




    //v = v.mulLocal(100*d/(60*pixelsPerCM));
    NumberBlob newBlob = new NumberBlob(p.x, p.y, d, frag[i], thisBlob.col, thisBlob.shape);

    newBlob.body.setTransform(newBlob.body.getPosition(), -1*thisBlob.body.getAngle());
    v = newBlob.body.getLinearVelocity();
    v = v.mulLocal(0);
    v = v.addLocal(new Vec2(p.x - thisBlob.pos.x, -1*p.y + thisBlob.pos.y));
    v = v.mulLocal(2);
    v = v.addLocal(thisBlob.body.getLinearVelocity());
    newBlob.body.setLinearVelocity(v);
    println(newBlob.body.getLinearVelocity());
    newBlob.body.setAngularVelocity(thisBlob.body.getAngularVelocity());
    blobList.add(newBlob);
  }
  exploding = false;
}


/*
swapBlobShape() has to 
 1/instantiate new blobs of the opposite type into a local ArrayList
 2/pass the corresponding, existing blobs' parameters to the new blobs
 3/remove the original blobs (of the old shape) from the Box2D world and clear the input ArrayList
 4/instantiate blobs of the desired shape into the input ArrayList from the local ArrayList
 5/pass the corresponding parameters to these blobs
 6/remove the local ArrayList's blobs from the world and from memory
 */
void swapBlobShape() {
  ArrayList tempList = new ArrayList();
  int blobPop = blobList.size();
  for (int i = 0; i < blobPop; i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);

    String nextShape = "";
    if (thisBlob.shape == "ball") {
      nextShape = "box";
    } else {
      nextShape = "ball";
    }

    NumberBlob tempBlob = new NumberBlob(thisBlob.pos.x, thisBlob.pos.y, thisBlob.diam, thisBlob.value, thisBlob.col, nextShape);
    tempBlob.body.setTransform(tempBlob.body.getPosition(), thisBlob.body.getAngle());
    tempBlob.body.setLinearVelocity(thisBlob.body.getLinearVelocity());
    tempBlob.body.setAngularVelocity(thisBlob.body.getAngularVelocity());
    tempList.add(tempBlob);
    thisBlob.killBody();
  }

  blobList = new ArrayList();


  for (int i = 0; i < tempList.size (); i++) {
    NumberBlob tempBlob = (NumberBlob) tempList.get(i);
    NumberBlob replaceBlob = new NumberBlob(tempBlob.posX, tempBlob.posY, tempBlob.diam, tempBlob.value, tempBlob.col, tempBlob.shape);
    replaceBlob.body.setTransform(replaceBlob.body.getPosition(), tempBlob.body.getAngle());
    replaceBlob.body.setLinearVelocity(tempBlob.body.getLinearVelocity());
    replaceBlob.body.setAngularVelocity(tempBlob.body.getAngularVelocity());
    blobList.add(replaceBlob);
    tempBlob.killBody();
  }
}

void swapShapes() {
  swapBlobShape();
  for (int i = 0; i < buttons.length; i++) {
    buttons[i].swapButtonShape();
  }
}

//remove dead blobs from memory, remove newborn status
void handleBlobs() {
  for (int i = 0; i < blobList.size (); i++) {
    NumberBlob corpseBlob = (NumberBlob) blobList.get(i);
    if (corpseBlob.dead) {
      blobList.remove(i);
    }
    if (corpseBlob.newborn) {
      corpseBlob.newborn = false;
    }
  }
}

void summonBlob(int buttonIndex, int value) {
  NumberBlob newBlob = new NumberBlob(buttons[buttonIndex].posX + 0.707*pixelsPerCM, buttons[buttonIndex].posY + 0.707*pixelsPerCM, pixelsPerCM, value, color(random(70, 200), random(70, 200), random(70, 200)), buttons[buttonIndex].shape);
  blobList.add(newBlob);
}

