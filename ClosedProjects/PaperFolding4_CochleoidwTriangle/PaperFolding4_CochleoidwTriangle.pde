/**
 * @title PaperFolding1
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Feb 17, 2016
 * @author Tiger Mou
 * Description: "folds" the paper across the midpoint to create fancy shapes (Circle, Ellipse, and Hyperbole)
 * Features: Zooming (scrolling), Panning (click and drag), click detection (console and bigger "brush")
 */
 int hsbColor = 0;
float triangleRad = 0;
float triangleRot = 0;
color mouseColor = color(100, 100, 100);
private Point panXY = new Point();

PFont cornerFont;    //global font variable for the fps and other counters
final boolean enableMatrixMovement = true;
final static boolean enableDebugShapes = false;

float prevX = 0;
float prevY = 0;

Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines
int unit = 40;
void setup() {
  //size(600, 600);  //windowsize
  fullScreen();  //fullscreen!
  noCursor();    //hides mouse cursor
  smooth();      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect
}

void draw() {
  //BACKGROUND
 //background(0);
  if (frameCount % 1 == 0) {              //redraw the "background" every two frames
   noStroke();
   fill(0, 30);                        // a white translucent rectangle is the background
   rect(0, 0, width, height);
  }

  /*******************************************
   *           BEGIN DRAW CONTENTS           *
   *******************************************/
  pushMatrix();
  if (enableMatrixMovement) {
    translate(width/2.0, height/2.0);  //INITIALLY CENTER SCREEN AT "0,0"
    translateZoomScroll();
    rotate(radians(0));  //ROTATE ALL CONTENT
  }
  /*******************************************
   *              BEGIN CONTENT              *
   *******************************************/

  //Centered Circle: Size
  float circleSize = height/1.25;
  //Attributes
  colorMode(HSB);
  stroke(hsbColor, 255, 255);
  if(hsbColor > 255) hsbColor = 0;
  hsbColor++;
  
  
  strokeWeight(1);
  noFill();
  //Draw at 0,0
 // ellipse(0, 0, circleSize, circleSize);

  //The "fold" point is the mouse location
  //Point innerRadius = new Point((mouseX - width/2.0 - zoomTransX - panXY.x)/(zoom/100), (mouseY - height/2.0 - zoomTransY - panXY.y)/(zoom/100));

 // Point innerRadius = new Point((mouseX - width/2.0 - zoomTransX - panXY.x)/(zoom/100), (mouseY - height/2.0 - zoomTransY - panXY.y)/(zoom/100));

  //recalculate screen edges for scrolling zooming purposes.
  //float newScreenLeft = (-width/2.0 - zoomTransX - panXY.x)/(zoom/100);
  //float newScreenRight = (width/2.0 - zoomTransX - panXY.x)/(zoom/100);
  
  float a = circleSize/2.0;
  float b = 100;
  
//float a = 100;
//float b = a*4;
  //float b = frameCount/2.0;
  Point lastPoint = new Point();
  //Draw this from 0 radians to 360 radians and makes a cool spotlight effect
  //for (float rad = 0; rad<(b*PI); rad+=0.05) {
  //  float alpha = (a/b - 1) * rad;

  //  float x = (a - b) * cos(rad) + b * cos(alpha);
  //  float y = (a - b) * sin(rad) - b * sin(alpha);


  //  //float x = cos(rad) * -b * cos(rad) + (4 * a * cos(rad) * sin(rad) * sin(rad));
  //  //float y = sin(rad) * -b * cos(rad) + (4 * a * cos(rad) * sin(rad) * sin(rad));
    
  //  if (rad !=0) {
  //    line(lastPoint.x, lastPoint.y, x, y);
  //  }
  //  lastPoint.x = x;
  //  lastPoint.y = y;
  //}
  pushMatrix();
  float alpha = (a/b - 1) * triangleRad;
  translate((a - b) * cos(triangleRad) + b * cos(alpha), (a - b) * sin(triangleRad) - b * sin(alpha));
  rotate(triangleRot);
  triangleRot+=0.05;
  triangleRad+=0.05;
  if(triangleRad>(b*PI)) triangleRad = 0;
  float side = 30;
  triangle(0, -side/sqrt(3), -side / 2, side * sqrt(3)/6, side /2, side * sqrt(3)/6); 
  
  popMatrix();



  /*******************************************
   *               END CONTENT               *
   *******************************************/
  popMatrix();

  /*******************************************
   *            END DRAW CONTENTS            *
   *******************************************/

  drawFPSCounter(); //CORNER TEXTS
  drawZoomCounter();

  /*******************************************
   *          MOUSE/WINDOW MANAGEMENT        *
   *******************************************/
  color tempOldMouseColor = color(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));
  if (frameCount % 2 == 0) {              //lower mouse color sampling rate
    color newMouseColor = get(mouseX, mouseY);    //get the color under the mouse cursor
    //"Average" the mouse color
    mouseColor = color((red(newMouseColor)*1 + red(mouseColor)) / 2, (green(newMouseColor)*1 + green(mouseColor))/2, (blue(newMouseColor)*1 + blue(mouseColor))/2);
  }

  stroke(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));  //"reverse" the color
  color tempNewMouseColor = color(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));
  if (mousePressed) {
    strokeWeight(38); //BIG Strokes!
    if (mouseButton == LEFT) {    //Pan the scene only if left click drag
      panXY.x += (mouseX - pmouseX);
      panXY.y += (mouseY - pmouseY);
    }
  } else strokeWeight(8);    //small strokes!
  line(mouseX, mouseY, pmouseX, pmouseY, tempOldMouseColor, tempNewMouseColor, 10);
  //line(pmouseX, pmouseY, mouseX, mouseY);  //Draw line 
  noStroke();    //reset mouse stroke
}

void line(int xStart, int yStart, int xEnd, int yEnd, int colorStart, int colorEnd, int steps) {
  float[] xs = new float[steps+1];
  float[] ys = new float[steps+1];
  color[] cs = new color[steps+1];
  for (int i=0; i<=steps; i++) {
    float amount = (float) i / steps;
    xs[i] = lerp(xStart, xEnd, amount);
    ys[i] = lerp(yStart, yEnd, amount);
    cs[i] = lerpColor(colorStart, colorEnd, amount);
  }
  for (int i=0; i<steps; i++) {
    stroke(cs[i]);
    line(xs[i], ys[i], xs[i+1], ys[i+1]);
  }
}

//OBJECTS PASS BY REFERENCE!
//Move from here to here in this many frames
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
  textFont(cornerFont, 22);  //font size 22
  text(int(frameRate), 5, 20);  //display framerate in the top
}
void drawZoomCounter() { 
  noStroke();
  fill(0);            //black rectangle in corner
  int fpsWidth = 37;
  int fpsHeight = 25;
  rect(width-fpsWidth, height-fpsHeight, fpsWidth, fpsHeight);  //rectangle location
  fill(255);        //white text
  textFont(cornerFont, 18);  //font size 18
  text(int(zoom), width-fpsWidth+3, height - 5);  //display framerate in the top
}
void mouseClicked() {
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