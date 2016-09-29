/**
 * @title PaperFolding5
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Feb 29, 2016
 * @author Tiger Mou
 * Description: "folds" the paper across the midpoint to create fancy shapes (Circle, Ellipse, and Hyperbole)
 * Features: Zooming (scrolling), Panning (click and drag), click detection (console and bigger "brush")
 */

public final float ACCY = 1E-9f;

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
    fill(0, 170);                        // a white translucent rectangle is the background
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
  //Attributes
  stroke(255, 0, 0);
  strokeWeight(1);
  noFill();
  //recalculate screen edges for scrolling zooming purposes.
  float newScreenLeft = (-width/2.0 - zoomTransX - panXY.x)/(zoom/100);
  float newScreenRight = (width/2.0 - zoomTransX - panXY.x)/(zoom/100);

  float slope1 = -3;
  float yInterc1 = 5;
  float slope2 = 0.5;
  float yInterc2 = -7;
  float screenMaxMin = 100000;
  Point line1Left = new Point(-screenMaxMin, slope1 * -screenMaxMin + yInterc1);
  Point line1Right = new Point(screenMaxMin, slope1 * screenMaxMin + yInterc1);
  line(line1Left, line1Right);
  Point line2Left = new Point(-screenMaxMin, slope2 * -screenMaxMin + yInterc2);
  Point line2Right = new Point(screenMaxMin, slope2 * screenMaxMin + yInterc2);
  line(line2Left, line2Right);

  Point foldPoint1 = new Point((mouseX - width/2.0 - zoomTransX - panXY.x)/(zoom/100), (mouseY - height/2.0 - zoomTransY - panXY.y)/(zoom/100));
  //Point foldPoint1 = new Point(250,1);
  Point foldPoint2 = new Point(324, -172);

  point(foldPoint1);
  stroke(0, 255, 0);
  strokeWeight(2);
  point(foldPoint2);
  ellipse(foldPoint2.x, foldPoint2.y, 10,10);
strokeWeight(1);
  float pointsD = sqrt(pow(foldPoint1.x - foldPoint2.x, 2) + pow(foldPoint1.y - foldPoint2.y, 2));

  //float amountIncrem = (newScreenRight-newScreenLeft)/100;
  stroke(255);
  colorMode(HSB);

  //Point1 moves along line1
  for (float x = -screenMaxMin; x < screenMaxMin; x+=5) {
   float[] intersections = line_circle_p(line2Left.x, line2Left.y, line2Right.x, line2Right.y, x, (slope1 * x) + yInterc1, pointsD);
stroke((255.0*(abs(x)/(width))/1.0)%255, 255, 255);
   if (intersections.length == 2) {
     Point inters = new Point(intersections[0], intersections[1]);
     line(inters.x, inters.y, 500, 500);
     Point midPoint1 = new Point((x + foldPoint1.x)/2.0, (slope1 * x + yInterc1 + foldPoint1.y)/2.0);
     Point midPoint2 = new Point((inters.x + foldPoint2.x)/2.0, (inters.y + foldPoint2.y)/2.0);
     float slope = (midPoint1.y - midPoint2.y)/(midPoint1.x - midPoint2.x);
     line(newScreenLeft, slope*(newScreenLeft - midPoint1.x) + midPoint1.y, newScreenRight, slope*(newScreenRight - midPoint1.x) + midPoint1.y);
   } else if (intersections.length == 4) {
     Point inters1 = new Point(intersections[0], intersections[1]);
     if(enableDebugShapes) ellipse(inters1.x, inters1.y, 10, 10);
     Point inters2 = new Point(intersections[2], intersections[3]);
   if(enableDebugShapes)  ellipse(inters2.x, inters2.y, 10, 10);

     Point midPoint1 = new Point((x + foldPoint1.x)/2.0, (slope1 * x + yInterc1 + foldPoint1.y)/2.0);
     Point midPoint2 = new Point((inters1.x + foldPoint2.x)/2.0, (inters1.y + foldPoint2.y)/2.0);
     float slope = (midPoint1.y - midPoint2.y)/(midPoint1.x - midPoint2.x);
     line(newScreenLeft, slope*(newScreenLeft - midPoint1.x) + midPoint1.y, newScreenRight, slope*(newScreenRight - midPoint1.x) + midPoint1.y);
     Point midPoint3 = new Point((inters2.x + foldPoint2.x)/2.0, (inters2.y + foldPoint2.y)/2.0);
     slope = (midPoint1.y - midPoint3.y)/(midPoint1.x - midPoint3.x);
     line(newScreenLeft, slope*(newScreenLeft - midPoint1.x) + midPoint1.y, newScreenRight, slope*(newScreenRight - midPoint1.x) + midPoint1.y);
   }
   if(enableDebugShapes) ellipse(x, slope1 * x + yInterc1, pointsD * 2, pointsD * 2);
  }
  
  //Point2 moves along line2
  for (float x = -screenMaxMin; x < screenMaxMin; x+=5) {
  float[] intersections = line_circle_p(line1Left.x, line1Left.y, line1Right.x, line1Right.y, x, (slope2 * x) + yInterc2, pointsD);
stroke((255.0*(abs(x)/(width))/1.0)%255, 255, 255);
  if (intersections.length == 2) {
    Point inters = new Point(intersections[0], intersections[1]);
    line(inters.x, inters.y, 500, 500);
    Point midPoint1 = new Point((x + foldPoint2.x)/2.0, (slope2 * x + yInterc2 + foldPoint2.y)/2.0);
    Point midPoint2 = new Point((inters.x + foldPoint1.x)/2.0, (inters.y + foldPoint1.y)/2.0);
    float slope = (midPoint1.y - midPoint2.y)/(midPoint1.x - midPoint2.x);
    line(newScreenLeft, slope*(newScreenLeft - midPoint1.x) + midPoint1.y, newScreenRight, slope*(newScreenRight - midPoint1.x) + midPoint1.y);
  } else if (intersections.length == 4) {
    Point inters1 = new Point(intersections[0], intersections[1]);
  if(enableDebugShapes)   ellipse(inters1.x, inters1.y, 10, 10);
    Point inters2 = new Point(intersections[2], intersections[3]);
  if(enableDebugShapes)   ellipse(inters2.x, inters2.y, 10, 10);

    Point midPoint1 = new Point((x + foldPoint2.x)/2.0, (slope2 * x + yInterc2 + foldPoint2.y)/2.0);
    Point midPoint2 = new Point((inters1.x + foldPoint1.x)/2.0, (inters1.y + foldPoint1.y)/2.0);
    float slope = (midPoint1.y - midPoint2.y)/(midPoint1.x - midPoint2.x);
    line(newScreenLeft, slope*(newScreenLeft - midPoint1.x) + midPoint1.y, newScreenRight, slope*(newScreenRight - midPoint1.x) + midPoint1.y);
    Point midPoint3 = new Point((inters2.x + foldPoint1.x)/2.0, (inters2.y + foldPoint1.y)/2.0);
    float otherSlope = (midPoint1.y - midPoint3.y)/(midPoint1.x - midPoint3.x);
    line(newScreenLeft, otherSlope*(newScreenLeft - midPoint1.x) + midPoint1.y, newScreenRight, otherSlope*(newScreenRight - midPoint1.x) + midPoint1.y);
  }
  if(enableDebugShapes)  ellipse(x, slope2 * x + yInterc2, pointsD * 2, pointsD * 2);
  }




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


/**
 * http://lagers.org.uk/how-to/ht-geom-01/index.html
 * Calculate the points of intersection between a line and the
 * circumference of a circle.
 * [x0, y0] - [x1, y1] the line end coordinates 
 * [cx, cy] the centre of the circle
 * r the radius of the circle
 *
 * An array is returned that contains the intersection points in x, y order.
 * If the returned array is of length:
 * 0 then there is no intersection.
 * 2 there is just one intersection (the line is a tangent to the circle).
 * 4 there are two intersections.
 */
public float[] line_circle_p(float x0, float y0, float x1, float y1, float cx, float cy, float r) {
  float[] result = null;
  float f = (x1 - x0);
  float g = (y1 - y0);
  float fSQ = f*f;
  float gSQ = g*g;
  float fgSQ = fSQ + gSQ;

  float xc0 = cx - x0;
  float yc0 = cy - y0;

  float fygx = f*yc0 - g*xc0;
  float root = r*r*fgSQ - fygx*fygx;
  if (root > -ACCY) {
    float[] temp = null;
    int np = 0;
    float fxgy = f*xc0 + g*yc0;
    if (root < ACCY) {    // tangent so just one point
      float t = fxgy / fgSQ;
      if (t >= 0 && t <= 1)
        temp = new float[] { x0 + f*t, y0 + g*t};
      np = 2;
    } else {  // possibly two intersections
      temp = new float[4];
      root = sqrt(root);
      float t = (fxgy - root)/fgSQ;
      if (t >= 0 && t <= 1) {
        temp[np++] = x0 + f*t;
        temp[np++] = y0 + g*t;
      }
      t = (fxgy + root)/fgSQ;
      if (t >= 0 && t <= 1) {
        temp[np++] = x0 + f*t;
        temp[np++] = y0 + g*t;
      }
    }
    if (temp != null) {
      result = new float[np];
      System.arraycopy(temp, 0, result, 0, np);
    }
  }
  return (result == null) ? new float[0] : result;
}