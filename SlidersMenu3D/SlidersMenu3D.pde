import peasy.*;
/**
 * @title PaperFolding5
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Feb 29, 2016
 * @author Tiger Mou
 * Description: "folds" the paper across the midpoint to create fancy shapes (Circle, Ellipse, and Hyperbole)
 * Features: Zooming (scrolling), Panning (click and drag), click detection (console and bigger "brush")
 */

PGraphics p2D;
  public final float ACCY = 1E-9f;
ControllersMenu menu;
float hsbColor = 0;
float triangleRad = 0;
float triangleRot = 0;

color mouseColor = color(100, 100, 100);
boolean usePointMouse = false;
private Point panXY = new Point();

PFont cornerFont;    //global font variable for the fps and other counters
final boolean enableMatrixMovement = true;
final static boolean enableDebugShapes = false;

boolean drawTrivCircle = false;

PeasyCam cam;
PImage photosphere;
boolean imageLoaded = false;
int ptsW, ptsH;
int numPointsW;
int numPointsH_2pi; 
int numPointsH;

float[] coorX;
float[] coorY;
float[] coorZ;
float[] multXZ;


float prevX = 0;
float prevY = 0;

Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines
int unit = 40;
void setup() {
  //size(600, 600, P3D);  //windowsize
  fullScreen(P3D);  //fullscreen!
  p2D = createGraphics(1280, 720);
  if (usePointMouse) noCursor();    //hides mouse cursor
  smooth();      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect
  menu = new ControllersMenu(Position.TOP_RIGHT, 300);
  //SLIDER MENU
  menu.addFloatSlider("TriSize", 0, 300, 50, 2);
  menu.addFloatSlider("TriSpeed", 0, 10, 0.05, 5);
  menu.addFloatSlider("TriRotSpeed", 0, 1, 0.05, 3);
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

  ptsW=30;
  ptsH=30;
  initializeSphere(ptsW, ptsH);
  cam = new PeasyCam(this, 0);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(1500);
}
float prevMaxSpeed = 0;
void draw() {
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
  background(0);
  p2D.beginDraw();
  if (frameCount % 1 == 0) {              //redraw the "background" every two frames
    //p2D.noStroke();
    p2D.fill(0, (int)tempControllers.get("TrailsTransparency").getValue());                        // a white translucent rectangle is the background
    p2D.rect(0, 0, p2D.width, p2D.height);
  }

  /*******************************************
   *           BEGIN DRAW CONTENTS           *
   *******************************************/
  p2D.pushMatrix();
  if (enableMatrixMovement) {
    p2D.translate(p2D.width/2.0, p2D.height/2.0);  //INITIALLY CENTER SCREEN AT "0,0"
    translateZoomScroll();
  }
  /*******************************************
   *              BEGIN CONTENT              *
   *******************************************/

  //Attributes
  p2D.strokeWeight(1);
  p2D.noFill();
  p2D.colorMode(HSB);

  p2D.stroke(hsbColor, 255, 255, (int)tempControllers.get("ColorTransparency").getValue());
  if (hsbColor > 255) hsbColor = 0;
  hsbColor+=(float)tempControllers.get("ColorSpeed").getValue();
  //stroke(0,0,255);

  //recalculate screen edges for scrolling zooming purposes.
  //float newScreenLeft = (-width/2.0 - zoomTransX - panXY.x)/(zoom/100);
  //float newScreenRight = (width/2.0 - zoomTransX - panXY.x)/(zoom/100);

  float circleSize = (float)menu.getControllers().get("ShapeCircleSize").getValue();
  //float a = (float)tempControllers.get("ShapeCircleA").getValue();
  float a = circleSize/2.0;
  float b = (float)tempControllers.get("ShapeCircleB").getValue();

  p2D.point(0, 0);

  p2D.pushMatrix();
  float alpha = (a/b - 1) * triangleRad;
  p2D.translate((a - b) * cos(triangleRad) + b * cos(alpha), (a - b) * sin(triangleRad) - b * sin(alpha));
  p2D.rotate(triangleRot);
  float triRotSpeed = (float)tempControllers.get("TriRotSpeed").getValue();
  triangleRot+=triRotSpeed;
  float triSpeed = (float)tempControllers.get("TriSpeed").getValue();
  triangleRad-=triSpeed;
  if (triangleRad<(-10000*b*PI)) triangleRad = 0;
  float side = (float)tempControllers.get("TriSize").getValue();
  if (drawTrivCircle)  p2D.triangle(0, -side/sqrt(3), -side / 2, side * sqrt(3)/6, side /2, side * sqrt(3)/6);
  else p2D.ellipse(0, 0, side, side);

  p2D.popMatrix();

  translate(0, -40);
  if(frameCount%2 == 0) photosphere = p2D.get();
  if(photosphere != null) textureSphere(500, 500, 500, photosphere);


  /*******************************************
   *               END CONTENT               *
   *******************************************/
  p2D.popMatrix();
  p2D.endDraw();
  cam.beginHUD();
  menu.drawMenu();

  /*******************************************
   *            END DRAW CONTENTS            *
   *******************************************/

  drawFPSCounter(); //CORNER TEXTS
  drawZoomCounter();
  cam.endHUD();
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
}
void initializeSphere(int numPtsW, int numPtsH_2pi) {

  // The number of points around the width and height
  numPointsW=numPtsW+1;
  numPointsH_2pi=numPtsH_2pi;  // How many actual pts around the sphere (not just from top to bottom)
  numPointsH=ceil((float)numPointsH_2pi/2)+1;  // How many pts from top to bottom (abs(....) b/c of the possibility of an odd numPointsH_2pi)

  coorX=new float[numPointsW];   // All the x-coor in a horizontal circle radius 1
  coorY=new float[numPointsH];   // All the y-coor in a vertical circle radius 1
  coorZ=new float[numPointsW];   // All the z-coor in a horizontal circle radius 1
  multXZ=new float[numPointsH];  // The radius of each horizontal circle (that you will multiply with coorX and coorZ)

  for (int i=0; i<numPointsW; i++) {  // For all the points around the width
    float thetaW=i*2*PI/(numPointsW-1);
    coorX[i]=sin(thetaW);
    coorZ[i]=cos(thetaW);
  }
  for (int i=0; i<numPointsH; i++) {  // For all points from top to bottom
    if (int(numPointsH_2pi/2) != (float)numPointsH_2pi/2 && i==numPointsH-1) {  // If the numPointsH_2pi is odd and it is at the last pt
      float thetaH=(i-1)*2*PI/(numPointsH_2pi);
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=0;
    } else {
      //The numPointsH_2pi and 2 below allows there to be a flat bottom if the numPointsH is odd
      float thetaH=i*2*PI/(numPointsH_2pi);

      //PI+ below makes the top always the point instead of the bottom.
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=sin(thetaH);
    }
  }
}
void textureSphere(float rx, float ry, float rz, PImage t) { 
  // These are so we can map certain parts of the image on to the shape 
  float changeU=t.width/(float)(numPointsW-1); 
  float changeV=t.height/(float)(numPointsH-1); 
  float u=0;  // Width variable for the texture
  float v=0;  // Height variable for the texture

  beginShape(TRIANGLE_STRIP);
  texture(t);
  for (int i=0; i<(numPointsH-1); i++) {  // For all the rings but top and bottom
    // Goes into the array here instead of loop to save time
    float coory=coorY[i];
    float cooryPlus=coorY[i+1];

    float multxz=multXZ[i];
    float multxzPlus=multXZ[i+1];

    for (int j=0; j<numPointsW; j++) { // For all the pts in the ring
      normal(-coorX[j]*multxz, -coory, -coorZ[j]*multxz);
      vertex(coorX[j]*multxz*rx, coory*ry, coorZ[j]*multxz*rz, u, v);
      normal(-coorX[j]*multxzPlus, -cooryPlus, -coorZ[j]*multxzPlus);
      vertex(coorX[j]*multxzPlus*rx, cooryPlus*ry, coorZ[j]*multxzPlus*rz, u, v+changeV);
      u+=changeU;
    }
    v+=changeV;
    u=0;
  }
  endShape();
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