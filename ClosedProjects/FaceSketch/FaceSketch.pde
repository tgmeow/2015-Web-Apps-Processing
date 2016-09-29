/**
 * @title FaceSketch
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Feb 6, 2016
 * @author Tiger Mou
 * Description: Animated sketch of "my" face
 */
color mouseColor = color(100, 100, 100);
int frameCount = 0;  //counts the number of frames since the last time miniSpawns were spawned
PFont font;    //global font variable for the fps and miniSpawns counters

Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines
int mouthAnimationSpeed = 250; //SPEED IN MILLISECONDS

//face dimensions
int faceWidth = 270;
int faceHeight = 270;
int faceRadius = 270/2;

//Points used for the mouth bezier curve
Point initLeftCorner, initRightCorner, 
  loweredLeftCorner, loweredRightCorner, 
  currCornerLeft, currCornerRight, 
  initLeft, initRight, 
  targetLeft, targetRight, 
  currPosLeft, currPosRight;
  
boolean doAnimation = false; //do an animation this cycle?
boolean isHovered = false;  //if face is hovered
boolean stillHovered = false;  //if face is still hovered this draw cycle
Face faceState = Face.HAPPY;    //INITIAL FACE STATE 
enum Face {    //KEEPS TRACK OF FACE STATE
  HAPPY, SAD, FLAT;
}
int animationBeginTime = 0;  //INITIALIZE TO 0

void setup() {
  size(600, 600);  //windowsize
  //fullScreen();  //fullscreen!
  noCursor();    //hides mouse cursor
  smooth(4);      //ensure 4x antialiasing
  frameRate(60);  //sets framerate to 60
  font = createFont("Arial", 48);  //make a new font for the fps and spawn count
  background(255);      //set inital background color to black for that fade-in effect
  
  ///POINTS FOR THE BEZIER CURVE
  //Mouth corners
  initLeftCorner = new Point(width/4.0 + faceWidth/5.0, height/2.0  + faceHeight*3.0/20.0);
  initRightCorner = new Point(width/1.71 + faceWidth/6.0, height/2.03 + faceHeight*3.0/20.0);
  //Mouth corners for "SAD"
  loweredLeftCorner = new Point(width/4.0 + faceWidth/2.0, height/2.0  + faceHeight*3.0/10.0);
  loweredRightCorner = new Point(width/2.0 + faceWidth/12.0, height/2.03 + faceHeight*3.0/10.0);
  //current mouth position
  currCornerLeft = new Point(initLeftCorner);
  currCornerRight = new Point(initRightCorner);
  //point 2 and 3 for bezier
  initLeft = new Point(width/3.0 + faceWidth/6.0 + faceHeight*3.0/20.0, height/1.8 + faceHeight*3.0/20.0);
  initRight = new Point(width/2.0 + faceWidth/6.0, height/1.8 + faceHeight*3.0/20.0);
  //target locations for bezier curve (middle of face)
  targetLeft = new Point(width/2.0, height/2.03 + faceHeight*3.0/20.0);
  targetRight = new Point(width/2.0, height/2.0 + faceHeight*3.0/20.0);
  //current positions of points 2 and 3
  currPosLeft = new Point(initLeft);
  currPosRight = new Point(initRight);
  ///END BEZIER POINTS
}

void draw() {
  //BACKGROUND
  if (frameCount % 2 == 0) {              //redraw the "background" every two frames
    fill(255, 140);                        // a white translucent rectangle is the background
    rect(0, 0, width, height);
  }
  drawFPSCounter(); //CORNER TEXT

  strokeWeight(2);  //stroke for face lines
  stroke(0);
  ellipse(width/2.0, height/2.1, faceWidth, faceHeight);  //draw face
  float distScale = 0.8;  //scales distance to face
  double distanceToFace = Math.sqrt(Math.pow((mouseX - width/2.0), 2.0) + Math.pow((mouseY - height/2.0), 2.0));  //pythag theorem
  if (distanceToFace > faceRadius){  //if outside of face
    fill((float)(255-Math.pow(distanceToFace/distScale, 0.8)), (float)(distanceToFace/distScale), 0);  //fill with variable color
    if(stillHovered && !doAnimation){    //if is hovered and not doing animation, 
      //ANIMATE TO SAD FACE
      doAnimation = true;
      animationBeginTime = millis() + int(mouthAnimationSpeed * 2) ;
      faceState = Face.HAPPY;
    }       
    //outside face so not hovered
    isHovered = false;
    stillHovered = false;
  }
  else {  //if ON THE FACE
    fill(255,0,0);
    if(isHovered)
    stillHovered = true;
    isHovered = true;
    if(!stillHovered){  //IF NO LONGER HOVERED, STILL ANIMATE TO FLAT...?
    doAnimation = true;
    animationBeginTime = millis();
    faceState = Face.FLAT;
    }
  }
  float eyesScale = 6.0; //SCALE THE EYESSS
  ellipse(width/2.0 - faceWidth/6.0, height/2.0 - faceHeight*3.0/25.0, faceWidth/eyesScale, faceHeight/eyesScale);  //Left eye
  ellipse(width/2.0 + faceWidth/6.0, height/2.0 - faceHeight*3.0/25.0, faceWidth/eyesScale, faceHeight/eyesScale); //Right eye
  
  fill(255);
  //Crazy mouth
  bezier(currCornerLeft.x, currCornerLeft.y, currPosLeft.x, currPosLeft.y, currPosRight.x, currPosRight.y, currCornerRight.x, currCornerRight.y );
  
  //BIG EYEBROWS
  strokeWeight(6);
  line(width/2.0 - faceWidth/4.5, height/2.0 - faceHeight*3.0/8.0, width/2.0, height/2.0 - faceHeight*3.0/13.0);
  line(width/2.0 + faceWidth/4.5, height/2.0 - faceHeight*3.0/8.0, width/2.0, height/2.0 - faceHeight*3.0/13.0);

  //my dumb hair
  stroke(0);
  strokeWeight(25);
  line(266, 152, 206, 191);
  line(282, 147, 189, 189);
  line(297, 155, 180, 215);
  line(311, 139, 141, 243);
  line(252, 165, 141, 268);
  line(270, 184, 189, 255);
  line(276, 189, 210, 253);
  line(225, 185, 160, 265);
  line(258, 143, 161, 221);
  line(279, 139, 185, 216);
  line(317, 150, 234, 142);
  line(332, 149, 214, 171);
  line(389, 181, 430, 221);
  line(389, 207, 410, 244);
  line(344, 165, 409, 190);
  line(339, 155, 386, 155);
  line(333, 177, 404, 209);
  line(305, 146, 363, 139);
  line(294, 154, 366, 173);
  line(285, 167, 325, 184);
  line(290, 187, 355, 204);

  if (frameCount % 7 == 0) {              //lower color sampling rate
    int newMouseColor = get(mouseX, mouseY);    //get the color under the mouse cursor
    //Average the mouse color
    mouseColor = color((red(newMouseColor)*0.9 + red(mouseColor)) / 1.9, (green(newMouseColor)*0.9 + green(mouseColor))/1.9, (blue(newMouseColor)*0.9 + blue(mouseColor))/1.9);
  }
  stroke(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));  //"reverse" the color
  if (mousePressed) {
    strokeWeight(38); //BIG Strokes!
  }else{  //if mouse is not pressed
      strokeWeight(8);    //small strokes!
  }
  line(pmouseX, pmouseY, mouseX, mouseY);  //Draw line 
    noStroke();    //reset mouse stroke
  
  //ANIMATION HERE
  if (doAnimation) {
    int animTimeRemaining = mouthAnimationSpeed - (millis() - animationBeginTime);
    //print("\nAnimTimeremain " + animTimeRemaining);
    if (animTimeRemaining >=0) {
      int totalFrames = int(animTimeRemaining * frameRate/1000.0);
      if (faceState == Face.HAPPY && totalFrames !=0) {  //Animate from happy to flat
        animatePoint(currPosLeft, targetLeft, totalFrames);
        animatePoint(currPosRight, targetRight, totalFrames);
        animatePoint(currCornerLeft, initLeftCorner, totalFrames);
        animatePoint(currCornerRight, initRightCorner, totalFrames);
      } else if (faceState == Face.FLAT && totalFrames !=0) {  //Animate from flat to sad
        animatePoint(currCornerLeft, loweredLeftCorner, totalFrames);
        animatePoint(currCornerRight, loweredRightCorner, totalFrames);
        animatePoint(currPosLeft, targetLeft, totalFrames);
        animatePoint(currPosRight, targetRight, totalFrames);
      } else if (faceState == Face.SAD && totalFrames !=0) {  //animate from sad to happy
        animatePoint(currPosLeft, initLeft, totalFrames);
        animatePoint(currPosRight, initRight, totalFrames);
        animatePoint(currCornerLeft, initLeftCorner, totalFrames);
        animatePoint(currCornerRight, initRightCorner, totalFrames);
      }
    } else {
      if (faceState == Face.HAPPY)
        faceState = Face.FLAT;
      else if (faceState == Face.FLAT)
        faceState = Face.SAD;
      else if (faceState == Face.SAD)
        faceState = Face.HAPPY;
      doAnimation = false;
    }
  }
  frameCount++;  //iterate framecount each draw
  if (frameCount >= 1001) frameCount = 0;
}

//OBJECTS PASS BY REFERENCE!
void animatePoint(Point originPoint, Point targetPoint, int framesLeft) {
  float deltaXLeftPerFrame = (targetPoint.x - originPoint.x)/framesLeft;
  float deltaYLeftPerFrame = (targetPoint.y - originPoint.y)/framesLeft;
  originPoint.x += deltaXLeftPerFrame;
  originPoint.y += deltaYLeftPerFrame;
}

void drawFPSCounter() { 
  noStroke();
  fill(0);            //black rectangle in corner
  rect(0, 0, 35, 30);  //rectangle location
  fill(255);        //white text
  textFont(font, 22);  //font size 22
  text(int(frameRate), 5, 20);  //display framerate in the top
}
void mouseClicked() {
  if (!doAnimation && !stillHovered) {
    doAnimation = true;
    animationBeginTime = millis();
  }
  print("\nClicked: " + mouseX + ", " + mouseY);
}
void mousePressed() {
  mouseLocationPress = new Point(mouseX, mouseY);
  print("\nPressed: " + mouseX + ", " + mouseY);
}
void mouseReleased() {
  mouseLocationRelease = new Point(mouseX, mouseY);
  print("\nReleased: " + mouseX + ", " + mouseY);
  //stroke(0);
  //strokeWeight(8);
  //line(mouseLocationPress.x, mouseLocationPress.y, mouseLocationRelease.x, mouseLocationRelease.y);
  //noStroke();
}