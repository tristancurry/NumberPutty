//about time I wrote a button class
//Tristan Miller 2014

class Button {

  float posX;
  float posY;
  float diam;
  PFont symbolFont = font20;
  int symbolSize = 20;
  String buttonText;

  String shape;   //"box, ball"
  String state;   //"available, inactive, hover, down"

  color stateCol;
  color inactiveCol = color(20, 40);
  color availableCol = color(190);
  color hoverCol = color(255);
  color downCol  = color (130);
  boolean hidden = false;



  //Constructor//

  Button(float posX_, float posY_, float diam_, String buttonText_, String shape_, String state_) {

    posX = posX_;
    posY = posY_;
    diam = diam_;
    buttonText = buttonText_;
    shape = shape_;
    state = state_;

    setButtonCol();
  }


  void setButtonCol() {
    if (state == "available") {
      stateCol = availableCol;
    } else if (state == "hover") {
      stateCol = hoverCol;
    } else if (state == "down") {
      stateCol = downCol;
    } else {
      state = "inactive";
      stateCol = inactiveCol;
    }
  }

  //detect mouseover
  boolean mouseIn() {
    if (shape == "ball") {
      if (sq(mouseX - posX) + sq(mouseY - posY) < sq(diam/2)) {
        return true;
      } else {
        return false;
      }
    } else {
      if (sq(mouseX - posX) < sq(diam/2) && sq(mouseY - posY) < sq(diam/2) ) {
        return true;
      } else {
        return false;
      }
    }
  }

  void update() {
    setButtonCol();
    //this is to control the appearance & state of the buttons
    if (state != "inactive") {
      if (state == "down") {
        if (mousePressed) {
          if (!mouseIn()) {
            stateCol = hoverCol;
          } else {
            stateCol = downCol;
          }
        } else {
          state = "available";
          setButtonCol();
        }
      } else {
        if (state == "hover") {
          if (mousePressed) {
            state = "down";
            setButtonCol();
          } else if (!mouseIn()) {
            state = "available";
            setButtonCol();
          }
        } else {
          if (mouseIn()&&!mousePressed) {
            state = "hover";
            setButtonCol();
          }
        }
      }
    }
  }


  void display() {
    if (!hidden) {
      noFill();
      strokeWeight(3);
      stroke(stateCol);
      pushMatrix();
      translate(posX, posY);

      if (shape == "ball") {
        ellipseMode(CENTER);
        ellipse(0, 0, diam, diam);
      } else {
        rectMode(CENTER);
        rect(0, 0, diam, diam);
      }
      textFont(symbolFont);
      textSize(symbolSize);
      fill(stateCol);
      textAlign(CENTER, CENTER);
      text(buttonText, 0, 0);

      popMatrix();
    }
  }



  void swapButtonShape() {
    if (shape == "ball") {
      shape = "box";
    } else {
      shape = "ball";
    }
  }
}

