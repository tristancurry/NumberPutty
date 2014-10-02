void mousePressed() {
  // check to see if the scoop is clicked on
  if (myScoop != null && myScoop.contains(mouseX, mouseY)) {
    spring.bindScoop(mouseX, mouseY, myScoop);
    myScoop.lastClicked = frameCount;
    myScoop.held = true;
  }



  // Check to see if the mouse was clicked on the box
  for (int i = 0; i < blobList.size (); i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);

    if (thisBlob.contains(mouseX, mouseY)) {
      // If there's been enough time since the last click, bind the mouse location to the box with a spring
      if (frameCount - thisBlob.lastClicked > 12) {
        spring.bind(mouseX, mouseY, thisBlob);
        thisBlob.lastClicked = frameCount;
        thisBlob.held = true;

        //otherwise, if smashing the blob isn't going to result in fractions...
      } else { 
        if (abs(thisBlob.value) != 1 &&!exploding && !thisBlob.newborn) {

          if (thisBlob.value == 0 && !zeroSplittingAllowed) {
          } else {
            smashBlob(thisBlob);
            thisBlob.dead = true;
            thisBlob.killBody();
          }
        }
        break;
      }
    }
  }
}


void mouseReleased() {
  spring.destroy();
  for (int i = 0; i < blobList.size (); i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);
    thisBlob.held = false;
  }

  if (myScoop != null) {
    myScoop.held = false;
    myScoop.body.setFixedRotation(false);
  }




  if (buttons[0].mouseIn() && buttons[0].state == "down") {
    summonBlob(0, 1);
  }
  if (buttons[1].mouseIn() && buttons[1].state == "down") {
    summonBlob(1, 0);
  }
  if (buttons[2].mouseIn() && buttons[2].state == "down") {
    summonBlob(2, -1);
  }

  if (buttons[4].mouseIn() && buttons[4].state == "down") {
    swapShapes();
  }
  if (buttons[buttons.length - 1].mouseIn() && buttons[buttons.length - 1].state == "down") {
    mergeBlobs();
  }
}



void makeButtons() {
  float buttonDiam = minDiam;
  if (buttonDiam < pixelsPerCM) {
    buttonDiam = pixelsPerCM;
  }

  ArrayList buttonGroup1 = new ArrayList();
  for (int i = 0; i < 3; i++) {
    Button newButton = new Button ((i+1) * (arenaWidth - bucketWidth)/4, 0.6*buttonDiam + boundThickness, buttonDiam, "", "ball", "available");
    newButton.symbolSize = 42;
    newButton.symbolFont = font42;
    buttonGroup1.add(newButton);
  }



  ArrayList buttonGroup2 = new ArrayList();
  for (int i = 0; i < 3; i++) {

    Button newButton = new Button ((1-controlPaddingPC)*width - 0.5*buttonDiam, (i+1)*height/4, buttonDiam, "", "ball", "available");
    buttonGroup2.add(newButton);
  }


  Button posButton = (Button) buttonGroup1.get(0);
  posButton.buttonText = "+";
  //posButton.state = "inactive";
  Button zeroButton = (Button) buttonGroup1.get(1);
  zeroButton.symbolSize = 20;
  zeroButton.symbolFont = font20;
  zeroButton.buttonText = "o";
  //zeroButton.state = "inactive";
  Button negButton = (Button) buttonGroup1.get(2);
  negButton.buttonText = "-";
  //negButton.state = "inactive";


  Button colButton = (Button) buttonGroup2.get(0);
  colButton.state = "inactive";
  Button shapeButton = (Button) buttonGroup2.get(1);
  Button pauseButton = (Button) buttonGroup2.get(2);
  pauseButton.state = "inactive";
  shapeButton.buttonText = "?";
  shapeButton.shape = "box";

  Button mergeButton = new Button (arenaWidth - 0.5*bucketWidth -10, 0.6*buttonDiam + boundThickness, buttonDiam, "=", "ball", "available");
  mergeButton.symbolSize = 42;
  mergeButton.symbolFont = font42;
  buttons = new Button[7];

  buttons[0] = posButton;
  buttons[1] = zeroButton;
  buttons[2] = negButton;
  buttons[3] = colButton;
  buttons[4] = shapeButton;
  buttons[5] = pauseButton;
  buttons[6] = mergeButton;
}

void renderButtons(Button[] b) {

  for (int i = 0; i < b.length; i++) {

    b[i].update();
    b[i].display();
  }
}

void toggleButtonActivation() {
  if (totalElements >= budget) {
    budgetProblem = true;
    zeroSplittingAllowed = false;
    buttons[1].state="inactive";
    if (totalValue >= budget) {
      buttons[0].state = "inactive";
      if (totalElements >= budget + 3) {
        buttons[2].state = "inactive";
      }
    } else if (totalValue <= -1*budget) {
      buttons[2].state = "inactive";
      if (totalElements >= budget + 3) {
        buttons[0].state = "inactive";
      }
    } else {
      buttons[2].state = "inactive";
      buttons[0].state = "inactive";
    }
  } else if (budgetProblem) {
    if (unitsAllowed) {
      buttons[0].state = "available";
    }
    if (negativeAllowed) {
      buttons[2].state = "available";
    }
    if (zeroAllowed) {
      buttons[1].state = "available";
      zeroSplittingAllowed = true;
    }
    budgetProblem = false;
  }
}

