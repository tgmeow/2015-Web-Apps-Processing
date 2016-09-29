import peasy.*;
/**
 * @title TranslationExercise
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date IDK
 * @author Tiger Mou
 * Description: Makes a bar chart and stuff
 */

public final float ACCY = 1E-9f;
ControllersMenu menu;
PeasyCam cam;

color mouseColor = color(100, 100, 100);
private Point panXY = new Point();

PFont cornerFont;    //global font variable for the fps and other counters
final boolean enableMatrixMovement = true;
final static boolean enableDebugShapes = false;
final boolean usePointMouse = false; //VERY LAGGY
boolean rotateFollowMouse = true;
float rotXPos = 0;
float rotYPos = 0;
Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines

void setup() {
  //size(900, 600);  //windowsize
  fullScreen(P3D);  //fullscreen!
  lights();
  if (usePointMouse) noCursor();    //hides mouse cursor
  smooth();      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect

  menu = new ControllersMenu(Position.TOP_RIGHT, 300);
  //SLIDER MENU
  menu.addIntSlider("FrameRate", 5, 60, 60);              //IN USE

  menu.addButtonController("RESET CONTROLS", "RESET CONTROLS");    //IN USE
  menu.addButtonController("RESET ZOOM", "RESET ZOOM");    //IN USE
  cam = new PeasyCam(this, 1000);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(800);
}

void draw() {
  background(0);
  java.util.TreeMap <String, Controller> tempControllers = new java.util.TreeMap <String, Controller> (menu.getControllers());

  if ((boolean)tempControllers.get("RESET CONTROLS").getValue()) { 
    menu.resetMenu();
  }

  if ((boolean)tempControllers.get("RESET ZOOM").getValue()) {
    zoom = 100;
    zoomTransX = 0;
    zoomTransY = 0;
    panXY.x = 0;
    panXY.y = 0;
    rotXPos = 0;
    rotYPos = 0;
  }

  frameRate((int)tempControllers.get("FrameRate").getValue());
  //BACKGROUND
  //background(0);
  noStroke();

  /*******************************************
   *           BEGIN DRAW CONTENTS           *
   *******************************************/

  pushMatrix();
  if (enableMatrixMovement) {
    //translate(width/2.0, height/2.0);  //INITIALLY CENTER SCREEN AT "0,0"
    translateZoomScroll();
    //rotate(radians(0));  //ROTATE ALL CONTENT
  }
    
  //DRAW AXES
  stroke(255, 0, 0);
  strokeWeight(1);
  int axisLength = 3000;
  line(-axisLength, 0, 0, axisLength, 0, 0);
  stroke(0, 255, 0);
  line(0, -axisLength, 0, 0, axisLength, 0);
  stroke(0, 0, 255);
  line(0, 0, -axisLength, 0, 0, axisLength);

  /*******************************************
   *              BEGIN CONTENT              *
   *******************************************/
  
  //HOUSE
  /*
  fill(255, 60);
strokeWeight(2);
  stroke(255);
  box(200);
  translate(0, 0, 200);
  int pyrHeight = 30; 
  beginShape();
  vertex(   0, -100, pyrHeight);
  vertex(-100, -100, -100);
  vertex( 100, -100, -100);
  vertex(   0, -100, pyrHeight);

  vertex( 100, -100, -100);
  vertex( 100, 100, -100);
  vertex(   0, 100, pyrHeight);
  vertex(   0, -100, pyrHeight);

  vertex(   0, 100, pyrHeight);
  vertex( 100, 100, -100);
  vertex(-100, 100, -100);
  vertex(   0, 100, pyrHeight);

  vertex(-100, 100, -100);
  vertex(-100, -100, -100);
  vertex(   0, -100, pyrHeight);
  endShape();
  //END HOUSE
  */
  //CYLINDER
  stroke(0);
  strokeWeight(1);
  fill(220,30);
  int cylH = 10;
  int numMinMax = 30;
  float curveD = 0.5;
  int cylAcc = 18;
  for(float index = -numMinMax; index<=numMinMax; index = index+curveD){
    pushMatrix();
    translate(0, 0, index*cylH*curveD);
    drawCylinder(cylAcc,index*index, cylH * curveD);
    popMatrix();
  }
  /*******************************************
   *               END CONTENT               *
   *******************************************/
  popMatrix();
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
}
void drawCylinder(int sides, float r, float h)
{
    float angle = 360 / sides;
    float halfHeight = h / 2;
    // draw top shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, -halfHeight );    
    }
    endShape(CLOSE);
    // draw bottom shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight );    
    }
    endShape(CLOSE);
    // draw body
beginShape(TRIANGLE_STRIP);
for (int i = 0; i < sides + 1; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float y = sin( radians( i * angle ) ) * r;
    vertex( x, y, halfHeight);
    vertex( x, y, -halfHeight);    
}
endShape(CLOSE); 
} 
//Draws a gradiant line
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
void keyReleased() {
  if (key == ' ') {
    rotateFollowMouse = !rotateFollowMouse;
  }
}