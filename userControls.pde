void mousePressed() {
  // Check to see if the mouse was clicked on the box
  for (int i = 0; i < blobList.size (); i++) {
    NumberBlob thisBlob = (NumberBlob) blobList.get(i);

    if (thisBlob.contains(mouseX, mouseY)) {
      // If there's been enough time since the last click, bind the mouse location to the box with a spring
      if (frameCount - thisBlob.lastClicked > 6) {
        spring.bind(mouseX, mouseY, thisBlob);
        thisBlob.lastClicked = frameCount;
        
        //otherwise, if smashing the blob isn't going to result in fractions...
      } else { 
        if (abs(thisBlob.value) != 1 &&!exploding && !thisBlob.newborn) {
          if(thisBlob.value == 0 && !zeroSplittingAllowed){
          } else {
          smashBlob(thisBlob);
          thisBlob.dead = true;
          thisBlob.killBody();
          }
        } else if (abs(thisBlob.value) == 1) {
          //alert the user they are trying to smash a fundamental unit!
        }
      }
    }
  }
}



void mouseReleased() {
  spring.destroy();

  if (buttons[0].mouseIn() && buttons[0].state == "down") {
    /*if (smashMode) {
      buttons[0].buttonText = "!";
    } else {

      buttons[0].buttonText = "@";
    }*/
  }


  if (buttons[1].mouseIn() && buttons[1].state == "down") {
    summonBlob(1, 1);
  }
  if (buttons[2].mouseIn() && buttons[2].state == "down") {
    summonBlob(2, 0);
  }
  if (buttons[3].mouseIn() && buttons[3].state == "down") {
    summonBlob(3, -1);
  }

  if (buttons[5].mouseIn() && buttons[5].state == "down") {
    swapShapes();
  }
  if (buttons[buttons.length - 1].mouseIn() && buttons[buttons.length - 1].state == "down") {
    mergeBlobs();
  }
  
}



void makeButtons() {
  ArrayList buttonGroup1 = new ArrayList();
  for (int i = 0; i < 4; i++) {
    Button newButton = new Button ((i+1) * (arenaWidth - bucketWidth)/5, 50, 1*pixelsPerCM, "", "ball", "available");
    newButton.symbolSize = 42;
    newButton.symbolFont = font42;
    buttonGroup1.add(newButton);
  }



  ArrayList buttonGroup2 = new ArrayList();
  for (int i = 0; i < 3; i++) {
    Button newButton = new Button ((1-controlPaddingPC)*width - 0.5*pixelsPerCM, (i+1)*height/4, pixelsPerCM, "", "ball", "available");
    buttonGroup2.add(newButton);
  }

  Button smashButton = (Button) buttonGroup1.get(0);
  smashButton.symbolSize = 20;
  smashButton.symbolFont = font20;
  smashButton.buttonText = "@";
  smashButton.state = "inactive";
  Button posButton = (Button) buttonGroup1.get(1);
  posButton.buttonText = "+";
  //posButton.state = "inactive";
  Button zeroButton = (Button) buttonGroup1.get(2);
  zeroButton.symbolSize = 20;
  zeroButton.symbolFont = font20;
  zeroButton.buttonText = "o";
  //zeroButton.state = "inactive";
  Button negButton = (Button) buttonGroup1.get(3);
  negButton.buttonText = "-";
  //negButton.state = "inactive";


  Button colButton = (Button) buttonGroup2.get(0);
  colButton.state = "inactive";
  Button shapeButton = (Button) buttonGroup2.get(1);
  Button pauseButton = (Button) buttonGroup2.get(2);
  pauseButton.state = "inactive";
  shapeButton.buttonText = "?";
  shapeButton.shape = "box";

  Button mergeButton = new Button (arenaWidth - 0.5*bucketWidth -10, 50, 1*pixelsPerCM, "=", "ball", "available");
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

    b[i].update();
    b[i].display();
  }
}



