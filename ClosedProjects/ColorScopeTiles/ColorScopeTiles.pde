/**
 * @title PaperFolding5
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Mar 7, 2016
 * @author Tiger Mou
 * Description: Draws tessalation shapes and rotates them
 * Features: Zooming (scrolling), Panning (click and drag), click detection (console and bigger "brush")
 */

public final float ACCY = 1E-9f;
ControllersMenu menu;

color mouseColor = color(100, 100, 100);
private Point panXY = new Point();

PFont cornerFont;    //global font variable for the fps and other counters
final boolean enableMatrixMovement = true;
final static boolean enableDebugShapes = false;

Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines

Tessalation tessalation1, tessalation2, tessalation3;

float rot1 = 0, rot2 = 0, rot3 = 0;

void setup() {
  //size(600, 600);  //windowsize
  fullScreen();  //fullscreen!
  noCursor();    //hides mouse cursor
  smooth();      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect

  tessalation1 = new Tessalation(0, 0, 150, 150, 3, 3, 150);
  tessalation2 = new Tessalation(0, 0, 100, 100, 2, 2, 100);
  tessalation3 = new Tessalation(0, 0, 300, 300, 2, 2, 300);

  menu = new ControllersMenu(Position.TOP_RIGHT, 300);
  //SLIDER MENU
  menu.addIntSlider("TrailsTransparency", 0, 255, 255);  //IN USE
  menu.addIntSlider("FrameRate", 5, 60, 60);              //IN USE
  menu.addIntSlider("Color1", 0, 255, 100);        //IN USE
  menu.addIntSlider("Color2", 0, 255, 150);        //IN USE
  menu.addIntSlider("Color3", 0, 255, 200);        //IN USE
  menu.addIntSlider("ColorTransparency1", 0, 255, 100);    //IN USE
  menu.addIntSlider("ColorTransparency2", 0, 255, 100);    //IN USE
  menu.addIntSlider("ColorTransparency3", 0, 255, 100);    //IN USE
  menu.addFloatSlider("RotSpeed1", -0.5, 0.5, 0.11, 3);  //INUSE
  menu.addFloatSlider("RotSpeed2", -0.5, 0.5, -0.12, 3); //INUSE
  menu.addFloatSlider("RotSpeed3", -0.5, 0.5, 0.31, 3);  //INUSE
  menu.addFloatSlider("RotSpeedMAX", 0, 10, 0.5, 3);  //INUSE
  menu.addButtonController("RESET CONTROLS", "RESET");    //IN USE
  menu.addButtonController("NewTessalation1", "GENERATE");    //IN USE
  menu.addButtonController("NewTessalation2", "GENERATE");    //IN USE
  menu.addButtonController("NewTessalation3", "GENERATE");    //IN USE
}

void draw() {
  java.util.TreeMap <String, Controller> tempControllers = new java.util.TreeMap <String, Controller> (menu.getControllers());

  float newMaxSpeed = (float)tempControllers.get("RotSpeedMAX").getValue();
  ((FloatSlider)tempControllers.get("RotSpeed1")).setMax(newMaxSpeed);
  ((FloatSlider)tempControllers.get("RotSpeed1")).setMin(-newMaxSpeed);
  ((FloatSlider)tempControllers.get("RotSpeed2")).setMax(newMaxSpeed);
  ((FloatSlider)tempControllers.get("RotSpeed2")).setMin(-newMaxSpeed);
  ((FloatSlider)tempControllers.get("RotSpeed3")).setMax(newMaxSpeed);
  ((FloatSlider)tempControllers.get("RotSpeed3")).setMin(-newMaxSpeed);

  if ((boolean)tempControllers.get("NewTessalation1").getValue()) tessalation1.generateShape();
  if ((boolean)tempControllers.get("NewTessalation2").getValue()) tessalation2.generateShape();
  if ((boolean)tempControllers.get("NewTessalation3").getValue()) tessalation3.generateShape();

  if ((boolean)tempControllers.get("RESET CONTROLS").getValue()) menu.resetMenu();

  frameRate((int)tempControllers.get("FrameRate").getValue());
  //BACKGROUND
  //background(0);
  noStroke();
  fill(0, (int)tempControllers.get("TrailsTransparency").getValue());                        // a white translucent rectangle is the background
  rect(0, 0, width, height);

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
  strokeWeight(0);
  colorMode(HSB);

  //recalculate screen edges for scrolling zooming purposes.
  //float newScreenLeft = (-width/2.0 - zoomTransX - panXY.x)/(zoom/100);
  //float newScreenRight = (width/2.0 - zoomTransX - panXY.x)/(zoom/100);

  float tilingExtra = 0.6;

  point(0, 0);
  fill((int)tempControllers.get("Color1").getValue(), 255, 255, (int)tempControllers.get("ColorTransparency1").getValue());
  stroke(0, (int)tempControllers.get("ColorTransparency1").getValue());
  //1st Layer
  pushMatrix();
  int tess1Width = tessalation1.getTessalationWidth();
  int tess1Height = tessalation1.getTessalationHeight();
  rotate(rot1);
  rot1+=(float)tempControllers.get("RotSpeed1").getValue();
  translate(-width*tilingExtra, -width*tilingExtra);
  for (int totalYTrans = 0; totalYTrans < width*tilingExtra*2; totalYTrans += tess1Height) {
    int totalXTrans = 0;
    for (totalXTrans = 0; totalXTrans < width*tilingExtra*2; totalXTrans+=tess1Width) {
      float colorShift = 156.0/tess1Width;
      float colorDiff = (totalYTrans%(tess1Height*2.0)==0) ? (colorShift*(totalXTrans%(tess1Width*2.0))) : (colorShift*((totalXTrans+tess1Width)%(tess1Width*2.0)));
      fill(((int)tempControllers.get("Color1").getValue()+ colorDiff)%255, 255, 255, (int)tempControllers.get("ColorTransparency1").getValue());
      tessalation1.drawTessalation();
      translate(tess1Width, 0);
    }
    translate(-totalXTrans, tess1Height);
  }
  popMatrix();
  //2ndLayer
  fill((int)tempControllers.get("Color2").getValue(), 255, 255, (int)tempControllers.get("ColorTransparency2").getValue());
  stroke(0, (int)tempControllers.get("ColorTransparency2").getValue());
  pushMatrix();
  int tess2Width = tessalation2.getTessalationWidth();
  int tess2Height = tessalation2.getTessalationHeight();
  rotate(rot2);
  rot2+=(float)tempControllers.get("RotSpeed2").getValue();
  translate(-width*tilingExtra, -width*tilingExtra);
  for (int totalYTrans = 0; totalYTrans < width*tilingExtra*2; totalYTrans += tess2Height) {
    int totalXTrans = 0;
    for (totalXTrans = 0; totalXTrans < width*tilingExtra*2; totalXTrans+=tess2Width) {
      float colorShift = 75.0/tess2Width;
      float colorDiff = (totalYTrans%(tess2Height*2.0)==0) ? (colorShift*(totalXTrans%(tess2Width*2.0))) : (colorShift*((totalXTrans+tess2Width)%(tess2Width*2.0)));
      fill(((int)tempControllers.get("Color2").getValue()+ colorDiff)%255, 255, 255, (int)tempControllers.get("ColorTransparency2").getValue());
      tessalation2.drawTessalation();
      translate(tess2Width, 0);
    }
    translate(-totalXTrans, tess2Height);
  }
  popMatrix();

  //3rdLayer
  fill((int)tempControllers.get("Color3").getValue(), 255, 255, (int)tempControllers.get("ColorTransparency3").getValue());
  stroke(0, (int)tempControllers.get("ColorTransparency3").getValue());
  pushMatrix();
  int tess3Width = tessalation3.getTessalationWidth();
  int tess3Height = tessalation3.getTessalationHeight();
  rotate(rot3);
  rot3+=(float)tempControllers.get("RotSpeed3").getValue();
  translate(-width*tilingExtra, -width*tilingExtra);
  for (int totalYTrans = 0; totalYTrans < width*tilingExtra*2; totalYTrans += tess3Height) {
    int totalXTrans = 0;
    for (totalXTrans = 0; totalXTrans < width*tilingExtra*2; totalXTrans+=tess3Width) {
      float colorShift = 30.0/tess3Width;
      float colorDiff = (totalYTrans%(tess3Height*2.0)==0) ? (colorShift*(totalXTrans%(tess3Width*2.0))) : (colorShift*((totalXTrans+tess3Width)%(tess3Width*2.0)));
      fill(((int)tempControllers.get("Color3").getValue()+ colorDiff)%255, 255, 255, (int)tempControllers.get("ColorTransparency3").getValue());
      tessalation3.drawTessalation();
      translate(tess3Width, 0);
    }
    translate(-totalXTrans, tess3Height);
  }
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
  drawZoomCounter();

  /*******************************************
   *          MOUSE/WINDOW MANAGEMENT        *
   *******************************************/
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