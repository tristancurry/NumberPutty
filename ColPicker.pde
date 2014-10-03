//                                                                            //
//                                      //
//     //
//(ColPicker.pde)                                                                           //
//////////////////////////////////////////////////////////////////////////////////////////////
//by Tristan Miller, 2014                                                                   //
//Please send any feedback and suggestions to tristan.miller@asms.sa.edu.au                 //
//Full source repository is at https://github.com/tristanmiller/circleSquare                //
//                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////
//This file is part of NumberPutty.                                                         //
//                                                                                          //
//  NumberPutty is free software: you can redistribute it and/or modify                     //
//  it under the terms of the GNU General Public License as published by                    //
//  the Free Software Foundation, either version 3 of the License, or                       //
//  (at your option) any later version.                                                     //
//                                                                                          //
//  NumberPutty is distributed in the hope that it will be useful,                          //
//  but WITHOUT ANY WARRANTY; without even the implied warranty of                          //
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                           //
//  GNU General Public License for more details.                                            //
//                                                                                          //
// You should have received a copy of the GNU General Public License                        //
//  along with NumberPutty.  If not, see <http://www.gnu.org/licenses/>.                    //
//////////////////////////////////////////////////////////////////////////////////////////////


class ColPicker {

  float posX;
  float posY;

  float pWidth;
  float pHeight;

  PImage pickerImage;

  float selX = -10; //start off-screen
  float selY = -10;

  boolean selector;
  boolean dragging;

  String shape;

  //////Constructor//////
  ColPicker(float posX_, float posY_, float pWidth_, float pHeight_, PImage pickerImage_) {
    posX = posX_;
    posY = posY_;
    pWidth = pWidth_;
    pHeight = pHeight_;

    pickerImage = pickerImage_;
    selector = false;
    dragging = false;
    shape = "box";
  }

  ColPicker(float posX_, float posY_, float pDiam_, PImage pickerImage_, String shape_) {
    posX = posX_;
    posY = posY_;
    pWidth = pDiam_;
    pHeight = pDiam_;

    pickerImage = pickerImage_;
    selector = false;
    dragging = false;
    shape = shape_;
  }

  ////////////////////////

  boolean contains(int x, int y) {
    if (shape == "ball") {
      if (sq(mouseX - this.posX) + sq(mouseY - this.posY) < sq(this.pWidth/2)) {
        return true;
      } else {
        return false;
      }
    } else {

      if (x >= this.posX - this.pWidth/2 &&
        x <= this.posX + this.pWidth/2 &&
        y >= this.posY - this.pHeight/2 &&
        y <= this.posY + this.pHeight/2) {
        return true;
      } else {
        return false;
      }
    }
  }

  ////////////////////////
  void display() {
    imageMode(CENTER);
    image(pickerImage, posX, posY, pWidth, pHeight);
    if (selector) drawSelector();
  }

  ////////////////////////
  void drawSelector() {
    ellipseMode(CENTER);
    rectMode(CENTER);
    strokeWeight(3);
    noFill();
    pushMatrix();
    translate(selX + 1, selY + 1);
    stroke(50);
    if (shape == "box") {
      rect(0, 0, 0.08*pHeight, 0.08*pHeight);
    } else {
      ellipse(0, 0, 0.08*pHeight, 0.08*pHeight);
    }
    translate(-1, -1);
    stroke(255);
    if (shape == "box") {
      rect(0, 0, 0.08*pHeight, 0.08*pHeight);
    } else {
      ellipse(0, 0, 0.08*pHeight, 0.08*pHeight);
    }
    popMatrix();
  }
}
