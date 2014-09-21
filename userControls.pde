void mousePressed() {
  // Check to see if the mouse was clicked on the box
  for (int i = 0; i < blobList.size (); i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);

    if (thisBlob.contains(mouseX, mouseY)) {
      // And if not in smash mode, bind the mouse location to the box with a spring
      if (!smashMode) {
        spring.bind(mouseX, mouseY, thisBlob);
      } else if (thisBlob.value > 1 &&!exploding && !thisBlob.newborn) {
        explode(thisBlob);
        thisBlob.dead = true;
        thisBlob.killBody();
      }
    }
  }
}


void mouseReleased() {
  spring.destroy();

  if (buttons[0].mouseIn() && buttons[0].state == "down") {
    smashMode = !smashMode;
    if (smashMode) {

      buttons[0].buttonText = "!";
    } else {

      buttons[0].buttonText = "@";
    }
  }

  if (buttons[5].mouseIn() && buttons[5].state == "down") {
    swapShapes();
  }
}



void makeButtons(){
  ArrayList buttonGroup1 = new ArrayList();
  for (int i = 0; i < 4; i++) {
    Button newButton = new Button ((i+1) * (arenaWidth - bucketWidth)/5, 50, 1*pixelsPerCM, "", "box", "available");
    newButton.symbolSize = 42;
    newButton.symbolFont = font42;
    buttonGroup1.add(newButton);
  }



  ArrayList buttonGroup2 = new ArrayList();
  for (int i = 0; i < 3; i++) {
    Button newButton = new Button ((1-controlPaddingPC)*width - 0.5*pixelsPerCM, (i+1)*height/4, pixelsPerCM, "", "box", "available");
    buttonGroup2.add(newButton);
  }

  Button smashButton = (Button) buttonGroup1.get(0);
  smashButton.symbolSize = 20;
  smashButton.symbolFont = font20;
  smashButton.buttonText = "@";
  Button posButton = (Button) buttonGroup1.get(1);
  posButton.buttonText = "+";
  Button zeroButton = (Button) buttonGroup1.get(2);
  zeroButton.symbolSize = 20;
  zeroButton.symbolFont = font20;
  zeroButton.buttonText = "o";
  Button negButton = (Button) buttonGroup1.get(3);
  negButton.buttonText = "-";


  Button colButton = (Button) buttonGroup2.get(0);
  Button shapeButton = (Button) buttonGroup2.get(1);
  Button pauseButton = (Button) buttonGroup2.get(2);
  shapeButton.buttonText = "?";
  shapeButton.shape = "ball";

  Boundary mergeWall = (Boundary) boundaries.get(4);
  Button mergeButton = new Button (mergeWall.posX, arenaHeight - mergeWall.boundaryHeight/2, 1*pixelsPerCM, "=", "box", "available");
  mergeButton.symbolSize = 42;
  mergeButton.symbolFont = font42;
  buttons = new Button[8];
  buttons[0] = smashButton;
  buttons[1] = posButton;
  buttons[2] = zeroButton;
  buttons[3] = negButton;
  buttons[4] = colButton;
  buttons[5] = shapeButton;
  buttons[6] = pauseButton;
  buttons[7] = mergeButton;
}

void renderButtons(Button[] b) {

  for (int i = 0; i < b.length; i++) {
    if (i == b.length - 1) {
      noStroke();
      fill(0);
      if (b[i].shape == "ball") {
        ellipse(b[i].posX, b[i].posY, b[i].diam, b[i].diam);
      } else {
        rect(b[i].posX, b[i].posY, b[i].diam, b[i].diam);
      }
    }
    b[i].update();
    b[i].display();
  }
}

