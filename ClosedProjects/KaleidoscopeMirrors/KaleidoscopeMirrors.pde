/**
 * @title PaperFolding5
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Mar 7, 2016
 * @author Tiger Mou
 * Description: Makes a kaleidoscope using a randomly generated tessalation
 * Features: Zooming (scrolling), Panning (click and drag), click detection (console and bigger "brush")
 */

//PGraphics pg;
public final float ACCY = 1E-9f;
ControllersMenu menu;

color mouseColor = color(100, 100, 100);
private Point panXY = new Point();

PFont cornerFont;    //global font variable for the fps and other counters
final boolean enableMatrixMovement = true;
final static boolean enableDebugShapes = false;

Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines

Tessalation tessalation1;
private float worldRotation = 0;
private boolean usePoints = false, useMap = false;

float rot1 = 0, rot2 = 0, rot3 = 0;
PImage myImage;
void setup() {
  size(900, 600);  //windowsize
  //fullScreen();  //fullscreen!
  noCursor();    //hides mouse cursor
  smooth();      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect
  // pg = createGraphics(width, height);
  tessalation1 = new Tessalation(0, 0, 100, 100, 2, 2, 150);

  menu = new ControllersMenu(Position.TOP_RIGHT, 300);
  //SLIDER MENU
  menu.addIntSlider("TrailsTransparency", 0, 255, 255);  //IN USE
  menu.addIntSlider("FrameRate", 5, 60, 60);              //IN USE
  menu.addIntSlider("1 Color", 0, 255, 28);        //IN USE
  menu.addIntSlider("1 ColorTransparency", 0, 255, 255);    //IN USE
  menu.addFloatSlider("1 RotSpeed", -0.1, 0.1, 0.04, 2);  //INUSE
  menu.addFloatSlider("RotSpeedMAX", 0, 10, 0.1, 2);  //INUSE
  menu.addFloatSlider("SampleSpacingAngle", 0.5, 20, 1, 2);  //INUSE
  menu.addFloatSlider("SampleSpacingRadius", 0.5, 20, 1, 2);  //INUSE
  menu.addIntSlider("NumberOfMirrors", 1, 24, 6);    //IN USE
  menu.addFloatSlider("PointSizeMultiplier", 1, 50, 20, 2);    //IN USE
  menu.addFloatSlider("PointSizeMin", 0, 50, 5, 2);    //IN USE
  menu.addFloatSlider("WorldRotationSpeed", 0, 6.28, 0.03, 2);    //IN USE

  menu.addSwitchController("USE POINTS/PIXELS", "USING PIXELS", "USING POINTS");    //IN USE
  menu.addSwitchController("USE MAP/ARRAY", "USING ARRAY", "USING MAP");    //IN USE
  menu.addButtonController("RESET CONTROLS", "RESET CONTROLS");    //IN USE
  menu.addButtonController("1 NewTessalation1", "GENERATE");    //IN USE
  menu.addButtonController("RESET ZOOM", "RESET ZOOM");    //IN USE
  myImage = loadImage("stars.jpg");
}

void draw() {
  java.util.TreeMap <String, Controller> tempControllers = new java.util.TreeMap <String, Controller> (menu.getControllers());

  float newMaxSpeed = (float)tempControllers.get("RotSpeedMAX").getValue();
  ((FloatSlider)tempControllers.get("1 RotSpeed")).setMax(newMaxSpeed);
  ((FloatSlider)tempControllers.get("1 RotSpeed")).setMin(-newMaxSpeed);

  if ((boolean)tempControllers.get("1 NewTessalation1").getValue()) tessalation1.generateShape();

  usePoints = (boolean)tempControllers.get("USE POINTS/PIXELS").getValue();
  useMap = (boolean)tempControllers.get("USE MAP/ARRAY").getValue();

  if ((boolean)tempControllers.get("RESET CONTROLS").getValue()) { 
    menu.resetMenu();
    worldRotation = 0;
  }

  if ((boolean)tempControllers.get("RESET ZOOM").getValue()) {
    zoom = 100;
    zoomTransX = 0;
    zoomTransY = 0;
    panXY.x = 0;
    panXY.y = 0;
  }

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
  //strokeWeight(0);
  noStroke();
  colorMode(HSB);

  //recalculate screen edges for scrolling zooming purposes.
  //float newScreenLeft = (-width/2.0 - zoomTransX - panXY.x)/(zoom/100);
  //float newScreenRight = (width/2.0 - zoomTransX - panXY.x)/(zoom/100);
  float tessSize = height;
  float tilingExtra = 0.5;
  point(0, 0);
  fill((int)tempControllers.get("1 Color").getValue(), 255, 255, (int)tempControllers.get("1 ColorTransparency").getValue());
  //  stroke(0, (int)tempControllers.get("1 ColorTransparency").getValue());
  //1st Layer


  pushMatrix();
  int tess1Width = tessalation1.getTessalationWidth();
  int tess1Height = tessalation1.getTessalationHeight();
  rotate(rot1);
  rot1+=(float)tempControllers.get("1 RotSpeed").getValue();
  translate(-tessSize*tilingExtra, -tessSize*tilingExtra);
  for (int totalYTrans = 0; totalYTrans < tessSize*tilingExtra*2; totalYTrans += tess1Height) {
    int totalXTrans = 0;
    for (totalXTrans = 0; totalXTrans < tessSize*tilingExtra*2; totalXTrans+=tess1Width) {
      float colorShift = 156.0/tess1Width;
      float colorDiff = (totalYTrans%(tess1Height*2.0)==0) ? (colorShift*(totalXTrans%(tess1Width*2.0))) : (colorShift*((totalXTrans+tess1Width)%(tess1Width*2.0)));
      fill(((int)tempControllers.get("1 Color").getValue()+ colorDiff)%255, 255, 255, (int)tempControllers.get("1 ColorTransparency").getValue());
      tessalation1.drawTessalation();
      translate(tess1Width, 0);
    }
    translate(-totalXTrans, tess1Height);
  }
  popMatrix();
/*
   pushMatrix();
   rotate(rot1);  
   rot1+=(float)tempControllers.get("1 RotSpeed").getValue();
   image(myImage, -myImage.width/2.0, -myImage.height/2.0);
   popMatrix();
*/
  colorMode(RGB);

  float mirrorAngle = PI/(int)tempControllers.get("NumberOfMirrors").getValue();
  float kaleidoRadius = tessSize/2.0;
  float thetaAccuracy = (float)tempControllers.get("SampleSpacingAngle").getValue();
  float radiusAccuracy = (float)tempControllers.get("SampleSpacingRadius").getValue();
  HashMap<Integer, Integer> colors = new HashMap<Integer, Integer>();
  ArrayList<Integer> colorsArray = new ArrayList<Integer>();
  for (float radius = 0.01; radius<=kaleidoRadius; radius+=radiusAccuracy) {
    for (float currRad = 0; currRad <= mirrorAngle; currRad+=thetaAccuracy/radius) {
      int x = int(radius * cos(currRad) + width/2.0);
      int y = int(radius * sin(currRad)+height/2.0);
      if (useMap) colors.put(x + y * width, get(x, y));
      else colorsArray.add(get(x, y));
    }
  }

  float pointSizeMult = (float)tempControllers.get("PointSizeMultiplier").getValue();
  float pointSizeMin = (float)tempControllers.get("PointSizeMin").getValue();
  background(0);
  if (!usePoints) loadPixels();
  rotate(worldRotation);
  worldRotation += (float)tempControllers.get("WorldRotationSpeed").getValue();
  //strokeWeight(1);
  float thetaMax = (2*PI)/mirrorAngle;
  for (int mult = 1; mult<=thetaMax; mult++) {
    int index = 0;
    // int currTime = millis();
    for (float radius = 0.01; radius<=kaleidoRadius; radius+=radiusAccuracy) {
      float radiusIncrement = thetaAccuracy/radius;
      float strokeWeight = pointSizeMult*radius/width;
      strokeWeight((strokeWeight < pointSizeMin) ? pointSizeMin : strokeWeight);

      for (float currRad = 0; currRad <= mirrorAngle; currRad+= radiusIncrement) {
        float calcRad = 0; 
        if (mult%2 == 0) calcRad = mirrorAngle * mult - currRad;
        else calcRad = currRad + mirrorAngle*(mult-1);
        color tempColor = color(0);
        
        if (useMap) {
          int x = int(radius*cos(currRad) + width/2.0);
          int y = int(radius*sin(currRad) + height/2.0);
          int colorKey = x + y*width;
          if (colors.containsKey(colorKey)) tempColor = colors.get(colorKey);
        } else {
          tempColor = colorsArray.get(index);
          stroke(tempColor);
        }
        if (usePoints) point(int(radius*cos(calcRad)), int(radius*sin(calcRad)));
        else pixels[int(radius*cos(calcRad)) + int(radius*sin(calcRad))*width + int(width/2.0 + width*height/2.0)] = tempColor;

        if(!useMap) if (index<colorsArray.size()-1)index++;
        
      }
      
    }
    //println(millis()-currTime);
  }
  if (!usePoints) updatePixels();
  //EXPERIMENTAL "PGraphics pg"
  /*************************************************************************************
   pg.beginDraw();
   float pointSizeMult = (float)tempControllers.get("PointSizeMultiplier").getValue();
   float pointSizeMin = (float)tempControllers.get("PointSizeMin").getValue();
   background(0);
   rotate(worldRotation);
   worldRotation += (float)tempControllers.get("WorldRotationSpeed").getValue();
   //strokeWeight(1);
   float thetaMax = (2*PI)/mirrorAngle;
   
   int index = 0;
   
   for (float radius = 0.01; radius<=kaleidoRadius; radius+=radiusAccuracy) {
   float radiusIncrement = thetaAccuracy/radius;
   float strokeWeight = pointSizeMult*radius/width;
   pg.strokeWeight((strokeWeight < pointSizeMin) ? pointSizeMin : strokeWeight);
   
   for (float currRad = 0; currRad <= mirrorAngle; currRad+= radiusIncrement) {
   float calcRad = currRad + mirrorAngle; 
   // if (mult%2 == 0) calcRad = mirrorAngle * mult - currRad;
   // else calcRad = currRad + mirrorAngle*(mult-1);
   pg.stroke(colors.get(index));
   pg.point(int(radius*cos(calcRad)), int(radius*sin(calcRad)));
   if (index<colors.size()-1)index++;
   }
   }
   
   
   pg.endDraw();
   int currTime = millis();
   for (int mult = 1; mult<=thetaMax; mult++) {
   pushMatrix();
   rotate((mult-1)*mirrorAngle);
   image(pg, 0, 0);
   popMatrix();
   }
   println(millis()-currTime);
   
   */


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