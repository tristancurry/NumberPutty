void explode(NumberBlob thisBlob) {
  int val = thisBlob.value;
  int frag[] = new int[2];
  frag[0] = int(floor(val/2.0));
  frag[1] = val - frag[0];


  exploding = true;

  for (int i= 0; i<2; i ++) {
    float ang = thisBlob.body.getAngle() + random(0,PI) + i*HALF_PI;
    Vec2 v = new Vec2(0, 0);
    Vec2 p;
    float d;

    d = pow(frag[i], 1/3.)*pixelsPerCM;
    p = new Vec2(d*cos(ang), d*sin(ang));
    if (thisBlob.pos.x < arenaWidth - bucketWidth) {
      p.x = constrain(thisBlob.pos.x + p.x, d, arenaWidth - bucketWidth - d);
    } else {
      p.x = constrain(thisBlob.pos.x + p.x, arenaWidth - bucketWidth + d, arenaWidth - d);
    }
    p.y = constrain(thisBlob.pos.y + p.y, d, arenaHeight - d);



    v = v.addLocal(p);
    v = v.mulLocal(4*d/(60*pixelsPerCM));
    NumberBlob newBlob = new NumberBlob(p.x, p.y, d, frag[i], thisBlob.col, thisBlob.shape);

    newBlob.body.setTransform(newBlob.body.getPosition(), thisBlob.body.getAngle());
    newBlob.body.setLinearVelocity(v.addLocal(thisBlob.body.getLinearVelocity()));
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

