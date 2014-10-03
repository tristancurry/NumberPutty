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
    IntList blobColor = new IntList();
    float tally = 0;
    for (int i = 0; i < blobList.size (); i++) {
      NumberBlob thisBlob = (NumberBlob) blobList.get(i);
      if (thisBlob.pos.x < arenaWidth && thisBlob.pos.x > arenaWidth - bucketWidth) {
        tally = tally + thisBlob.value;
        thisBlob.dead = true;
        thisBlob.killBody();
        thisBlob.value = 0;
        blobColor.append(thisBlob.col);
      }
    }
    //if the tally is zero, and zeroBlobs aren't allowed, then don't worry about making a new blob...
    if (tally == 0 && !zeroAllowed) {
    } else {
      float newDiam = pow(abs(tally), 1/3.)*minDiam;
      //if we did end up with a zeroBlob, please give it a radius bigger than 0.
      if (tally == 0) {
        newDiam = minDiam;
      }
      color mergeCol = posCol;
      float redAvg = 0;
      float greenAvg = 0;
      float blueAvg = 0;
      for (int i = 0; i < blobColor.size (); i++) {
        color thisColor =  blobColor.get(i);
        redAvg = redAvg + red(thisColor);
        greenAvg = greenAvg + green(thisColor);
        blueAvg = blueAvg + blue(thisColor);
        if (i == blobColor.size() - 1) {
          redAvg = 1.0*redAvg/blobColor.size();
          greenAvg = 1.0*greenAvg/blobColor.size();
          blueAvg = 1.0*blueAvg/blobColor.size();
        }

        mergeCol = color(redAvg, greenAvg, blueAvg);
      }

      NumberBlob newBlob = new NumberBlob(buttons[buttons.length - 1].posX, buttons[buttons.length - 1].posY + (buttons[buttons.length - 1].diam + newDiam)/2, newDiam, int(tally), mergeCol, buttons[buttons.length - 1].shape);


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
  thisBlob.value = 0;

  for (int i= 0; i<2; i ++) {
    float ang = thisBlob.body.getAngle() + random(0, PI);
    ang = -1*ang;
    Vec2 v = new Vec2(0, 0);
    Vec2 p;
    float d;

    d = pow(abs(frag[i]), 1/3.)*minDiam;
    d = max(d, minDiam);  
    p = new Vec2(d*cos(ang), d*sin(ang));

    p.x = p.x+thisBlob.pos.x;
    p.y = p.y + thisBlob.pos.y;
    if (thisBlob.pos.x < arenaWidth - bucketWidth) {
      p.x = constrain(p.x, d, arenaWidth - bucketWidth - d);
    } else {
      p.x = constrain(p.x, arenaWidth - bucketWidth + d, arenaWidth - d);
    }
    p.y = constrain(p.y, d, arenaHeight - d);

    NumberBlob newBlob = new NumberBlob(p.x, p.y, d, frag[i], thisBlob.col, thisBlob.shape);

    newBlob.body.setTransform(newBlob.body.getPosition(), -1*thisBlob.body.getAngle());
    v = newBlob.body.getLinearVelocity();
    v = v.mulLocal(0);
    v = v.addLocal(new Vec2(p.x - thisBlob.pos.x, -1*p.y + thisBlob.pos.y));
    v = v.mulLocal(2);
    v = v.addLocal(thisBlob.body.getLinearVelocity());
    newBlob.body.setLinearVelocity(v);
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
  if (yourPicker.shape == "ball") {
    yourPicker.shape = "box";
    yourPicker.pickerImage = boxPicker;
  } else {
    yourPicker.shape = "ball";
    yourPicker.pickerImage = ballPicker;
  }
}

//update blob tallies
void countBlobs() {
  totalElements = 0;
  totalValue = 0;
  for (int i = 0; i< species.length; i++) {
    species[i] = 0;
  }

  for (int i = 0; i < blobList.size (); i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);


    //update various totals
    totalValue = totalValue + thisBlob.value;
    totalElements = totalElements + abs(thisBlob.value);
    if (thisBlob.value == 0 && !thisBlob.dead) {
      totalElements++;
    }
    species[thisBlob.value + budget]++;
  }
}


//deal with display of blobs
void handleBlobs() {


  for (int i = 0; i < blobList.size (); i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);
    //draw the blob to the screen
    thisBlob.display();


    //check if blob is marked for deletion
    //check if blob is marked as a new arrival, if so, unmark it
    //otherwise make sure the blob is not squeezed from arena
    if (thisBlob.dead) {
      blobList.remove(i);
    } else if (thisBlob.newborn) {
      thisBlob.newborn = false;
    } else {
      constrainBlobToArena(thisBlob);
    }
  }
}

void summonBlob(int buttonIndex, int value) {
  NumberBlob newBlob = new NumberBlob(buttons[buttonIndex].posX + 0.707*minDiam, buttons[buttonIndex].posY + 0.707*minDiam, minDiam, value, newCol, buttons[buttonIndex].shape);
  blobList.add(newBlob);
}

void constrainBlobToArena(NumberBlob b) {
  if (b.pos.x < 10 || b.pos.x > arenaWidth -10 || b.pos.y < 10 || b.pos.y > arenaHeight -10) {
    Vec2 p = new Vec2(b.pos.x, b.pos.y);
    p.x = constrain(p.x, b.diam/2 + 10, arenaWidth - 10 - b.diam/2);
    p.y = constrain(p.y, b.diam/2 + 10, arenaHeight - 10 - b.diam/2);
    b.body.setTransform(box2d.coordPixelsToWorld(p), b.body.getAngle());
  }
}
