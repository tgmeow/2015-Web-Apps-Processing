/**
 * @title PaperFolding5
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Feb 29, 2016
 * @author Tiger Mou
 * Description: "folds" the paper across the midpoint to create fancy shapes (Circle, Ellipse, and Hyperbole)
 * Features: Zooming (scrolling), Panning (click and drag), click detection (console and bigger "brush")
 */

public final float ACCY = 1E-9f;
ControllersMenu menu;
float hsbColor = 0;
float triangleRad = 0;
float triangleRot = 0;

color mouseColor = color(100, 100, 100);
boolean usePointMouse = false;
private Point panXY = new Point();

PFont cornerFont;    //global font variable for the fps and other counters
final boolean enableMatrixMovement = false;
final static boolean enableDebugShapes = false;

boolean drawTrivCircle = false;

float prevX = 0;
float prevY = 0;

Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines
int unit = 40;
void setup() {
  //size(600, 600);  //windowsize
  fullScreen();  //fullscreen!
  if (usePointMouse) noCursor();    //hides mouse cursor
  smooth();      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect
  menu = new ControllersMenu(Position.TOP_RIGHT, 300);
  //SLIDER MENU
  menu.addFloatSlider("TriSize", 0, 300, 50, 2);
  menu.addFloatSlider("TriSpeed", 0, 10, 0.05, 5);
  menu.addFloatSlider("TriRotSpeed", 0, 2, 0.05, 3);
  menu.addFloatSlider("MaxTriSpeed", 0.1, 10, 1, 5); 
  menu.addIntSlider("TrailsTransparency", 0, 255, 100);
  menu.addIntSlider("FrameRate", 5, 60, 60);
  menu.addFloatSlider("ColorSpeed", 0, 50, 1, 3);
  menu.addIntSlider("ColorTransparency", 0, 255, 100);
  menu.addFloatSlider("ShapeCircleSize", 0, 2000, height/1.25, 2);
  //  menu.addFloatSlider("ShapeCircleA", 0, 1000, 200, 1);
  menu.addFloatSlider("ShapeCircleB", 0, 1000, 100, 1);
  menu.addButtonController("RESET CONTROLS", "RESET");
  menu.addButtonController("ToggleCircleTriangle", "TOGGLE");
}
float prevMaxSpeed = 0;
void draw() {
  float time = millis();
  java.util.TreeMap <String, Controller> tempControllers = new java.util.TreeMap <String, Controller> (menu.getControllers());
  float newMaxSpeed = (float)tempControllers.get("MaxTriSpeed").getValue();
  ((FloatSlider)tempControllers.get("TriSpeed")).setMax(newMaxSpeed);

  if ((boolean)tempControllers.get("RESET CONTROLS").getValue()) {
    menu.resetMenu();
  } 
  if ((boolean)tempControllers.get("ToggleCircleTriangle").getValue()) {
    drawTrivCircle = !drawTrivCircle;
  } 

  frameRate((int)tempControllers.get("FrameRate").getValue());
  //BACKGROUND
  //background(0);
  if (frameCount % 1 == 0) {              //redraw the "background" every two frames
    noStroke();
    fill(0, (int)tempControllers.get("TrailsTransparency").getValue());                        // a white translucent rectangle is the background
    rect(0, 0, width, height);
  }

  /*******************************************
   *           BEGIN DRAW CONTENTS           *
   *******************************************/
  pushMatrix();
  translate(width/2.0, height/2.0);  //INITIALLY CENTER SCREEN AT "0,0"
  if (enableMatrixMovement) {
    
    translateZoomScroll();
    rotate(radians(0));  //ROTATE ALL CONTENT
  }
  /*******************************************
   *              BEGIN CONTENT              *
   *******************************************/

  //Attributes
  strokeWeight(1);
  noFill();
  colorMode(HSB);

  stroke(hsbColor, 255, 255, (int)tempControllers.get("ColorTransparency").getValue());
  if (hsbColor > 255) hsbColor = 0;
  hsbColor+=(float)tempControllers.get("ColorSpeed").getValue();
  //stroke(0,0,255);

  //recalculate screen edges for scrolling zooming purposes.
  //float newScreenLeft = (-width/2.0 - zoomTransX - panXY.x)/(zoom/100);
  //float newScreenRight = (width/2.0 - zoomTransX - panXY.x)/(zoom/100);
  println("1: " + (millis()-time));
  float circleSize = (float)menu.getControllers().get("ShapeCircleSize").getValue();
  //float a = (float)tempControllers.get("ShapeCircleA").getValue();
  float a = circleSize*.5;
  float b = (float)tempControllers.get("ShapeCircleB").getValue();

  point(0, 0);

  pushMatrix();
  float alpha = (a/b - 1) * triangleRad;
  translate((a - b) * cos(triangleRad) + b * cos(alpha), (a - b) * sin(triangleRad) - b * sin(alpha));
  rotate(triangleRot);
  float triRotSpeed = (float)tempControllers.get("TriRotSpeed").getValue();
  triangleRot+=triRotSpeed;
  float triSpeed = (float)tempControllers.get("TriSpeed").getValue();
  triangleRad-=triSpeed;
  if (triangleRad<(-10000*b*PI)) triangleRad = 0;
  float side = (float)tempControllers.get("TriSize").getValue();
  if (drawTrivCircle)  triangle(0, -side/sqrt(3), -side / 2, side * sqrt(3)/6, side /2, side * sqrt(3)/6);
  else ellipse(0, 0, side, side);

  popMatrix();


  /*******************************************
   *               END CONTENT               *
   *******************************************/
  popMatrix();

  menu.drawMenu();

  /*******************************************
   *            END DRAW CONTENTS            *
   *******************************************/

  drawFPSCounter(); //CORNER TEXTS
  if (enableMatrixMovement) drawZoomCounter();

  /*******************************************
   *          MOUSE/WINDOW MANAGEMENT        *
   *******************************************/
  if (usePointMouse) {
    colorMode(RGB);
    color tempOldMouseColor = color(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));
    if (frameCount % 2 == 0) {              //lower mouse color sampling rate
      color newMouseColor = get(mouseX, mouseY);    //get the color under the mouse cursor
      //"Average" the mouse color
      mouseColor = color((red(newMouseColor)*1 + red(mouseColor)) / 2, (green(newMouseColor)*1 + green(mouseColor))/2, (blue(newMouseColor)*1 + blue(mouseColor))/2);
    }
    stroke(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));  //"reverse" the color
    color tempNewMouseColor = color(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));
    if (mousePressed) {
      strokeWeight(14); //BIG Strokes!
      if (mouseButton == LEFT && !menu.clickOnMenu(mouseX, mouseY) && menu.isMenuReleased()) {    //Pan the scene only if left click drag
        panXY.x += (mouseX - pmouseX);
        panXY.y += (mouseY - pmouseY);
      }
    } else strokeWeight(8);    //small strokes!
    line(mouseX, mouseY, pmouseX, pmouseY, tempOldMouseColor, tempNewMouseColor, 10);
    //line(pmouseX, pmouseY, mouseX, mouseY);  //Draw line 
    noStroke();    //reset mouse stroke
  }
  println("END: " + (millis()-time));
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
  menu.clickManager(mouseX, mouseY);
}
void mousePressed() {
  mouseLocationPress = new Point(mouseX, mouseY);
  print("\nPressed: " + mouseX + ", " + mouseY);
  menu.pressManager(mouseX, mouseY);
}
void mouseReleased() {
  mouseLocationRelease = new Point(mouseX, mouseY);
  print("\nReleased: " + mouseX + ", " + mouseY);
  menu.releaseManager(mouseX, mouseY);
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