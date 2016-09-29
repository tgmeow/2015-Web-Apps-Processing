/**
 * @title PaperFolding5
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Mar 7, 2016
 * @author Tiger Mou
 * Description: Makes a kaleidoscope using a randomly generated tessalation
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

Tessalation tessalation1;
private float worldRotation = 0;

float rot1 = 0, rot2 = 0, rot3 = 0;
//PImage doge;
void setup() {
  //size(900, 600);  //windowsize
  fullScreen();  //fullscreen!
  noCursor();    //hides mouse cursor
  smooth();      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect
  tessalation1 = new Tessalation(0, 0, 100, 100, 2, 2, 150);

  menu = new ControllersMenu(Position.TOP_RIGHT, 300);
  //SLIDER MENU
  menu.addIntSlider("TrailsTransparency", 0, 255, 255);  //IN USE
  menu.addIntSlider("StrokeWeight", 0, 200, 5);  //IN USE
  menu.addIntSlider("FrameRate", 5, 60, 60);              //IN USE
  menu.addIntSlider("NumberOfBoardChunks", 1, 24, 6);    //IN USE
  menu.addIntSlider("NumBoardSections", 1, 24, 3);    //IN USE
  menu.addFloatSlider("WorldRotationSpeed", 0, 6.28, 0.03, 2);    //IN USE

  menu.addButtonController("RESET CONTROLS", "RESET CONTROLS");    //IN USE
  menu.addButtonController("RESET ZOOM", "RESET ZOOM");    //IN USE
}

void draw() {
  java.util.TreeMap <String, Controller> tempControllers = new java.util.TreeMap <String, Controller> (menu.getControllers());

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

  //recalculate screen edges for scrolling zooming purposes.
  //float newScreenLeft = (-width/2.0 - zoomTransX - panXY.x)/(zoom/100);
  //float newScreenRight = (width/2.0 - zoomTransX - panXY.x)/(zoom/100);
  
  float boardRadius = height;
  int chunkNum = (int)tempControllers.get("NumberOfBoardChunks").getValue();
  int numSections = (int)tempControllers.get("NumBoardSections").getValue();
  float pieChunkRad = 2.0*PI/chunkNum;
  point(0, 0);

  colorMode(RGB);
  fill(255);
  rotate(worldRotation);
  worldRotation += (float)tempControllers.get("WorldRotationSpeed").getValue();
//  stroke(255, 0, 0);
  strokeWeight((int)tempControllers.get("StrokeWeight").getValue());
strokeCap(SQUARE);
  for (int chunk = 1; chunk<=chunkNum; chunk++) {
    for (int section = numSections; section>=1; section--) {
      fill(((chunk+section)%2 == 0) ? 255 : 0);
      stroke(((chunk+section)%2 == 0) ? color(255,0,0) : color(0,0,255));
      arc(0, 0, boardRadius*((float)section/(float)numSections), boardRadius*((float)section/(float)numSections), pieChunkRad * (chunk-1), pieChunkRad * chunk);
    }
  }



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
   strokeCap(ROUND);
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