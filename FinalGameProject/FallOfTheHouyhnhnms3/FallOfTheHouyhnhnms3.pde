/**
 * @title Fall of the houyhnhnms 2
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Mar 30, 2016
 * @author Tiger Mou
 * Description: Makes a horse game yay
 */
PopNodeManager nodeManager;
PopAIController aiController;
AnimSVGMinion tempMinion;

AnimSVGMinion tempMinion2;
AnimSVGMinion tempMinion3;
boolean gamePaused = false;

public final float ACCY = 1E-9f;
ControllersMenu menu;

color mouseColor = color(100, 100, 100);
boolean usePointMouse = false;
private Point panXY = new Point();

PFont cornerFont;    //global font variable for the fps and other counters
final boolean enableMatrixMovement = true;

Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines

static PShape horseGrey20;
static PShape horseGrey60;
static PShape horseBlack;
static PShape horseMaroon;
static PShape horseWhite;

static PShape houseGrey20;
static PShape houseGrey60;
static PShape houseBlack;
static PShape houseMaroon;
static PShape houseWhite;
ButtonController button;

void setup() {
  size(1280, 720);  //windowsize
  //fullScreen();  //fullscreen!
  if (usePointMouse) noCursor();    //hides mouse cursor
  smooth();      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect

  menu = new ControllersMenu(Position.TOP_RIGHT, 300);
  //SLIDER MENU
  menu.addIntSlider("FrameRate", 5, 60, 60);              //IN USE

  menu.addButtonController("RESET CONTROLS", "RESET CONTROLS");    //IN USE
  menu.closeMenu();

  horseGrey20 = loadShape("/img/horse_100x100_GRAY20.svg");
  horseGrey60 = loadShape("/img/horse_100x100_GRAY60.svg");
  horseBlack = loadShape("/img/horse_100x100_BLACK.svg");
  horseMaroon = loadShape("/img/horse_100x100_MAROON.svg");
  horseWhite = loadShape("/img/horse_100x100_WHITE.svg");

  houseGrey20 = loadShape("/img/house_100x100_GRAY20.svg");
  houseGrey60 = loadShape("/img/house_100x100_GRAY60.svg");
  houseBlack = loadShape("/img/house_100x100_BLACK.svg");
  houseMaroon = loadShape("/img/house_100x100_MAROON.svg");
  houseWhite = loadShape("/img/house_100x100_WHITE.svg");

  float scale = 0.5;
  horseGrey20.scale(scale);
  horseGrey60.scale(scale);
  horseBlack.scale(scale);
  horseMaroon.scale(scale);
  horseWhite.scale(scale);

  houseGrey20.scale(scale);
  houseGrey60.scale(scale);
  houseBlack.scale(scale);
  houseMaroon.scale(scale);
  houseWhite.scale(scale);

  nodeManager = new PopNodeManager();
  aiController = new PopAIController(nodeManager, "Team2", 900);
  float moveSpeed = 0.18;
  int numNeutrals = 22;
  tempMinion = new AnimSVGMinion(horseGrey60, 0.5, new Point(-200, -200), new Point(200, 200), -1, 3000, moveSpeed, 1, 1, "Team1", color(255, 0, 0));
  nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(-600, -300), 10, 2000, "Team1", color(255), tempMinion));
  //  nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(-550, -220), 10, 2000, "Team1", color(255), tempMinion));
  //  nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(-500, -310), 10, 2000, "Team1", color(255), tempMinion));

  tempMinion2 = new AnimSVGMinion(horseMaroon, 0.5, new Point(-200, -200), new Point(200, 200), -1, 3000, moveSpeed, 1, 1, "Team2", color(0, 0, 255));
  nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(600, 300), 10, 2000, "Team2", color(255), tempMinion2));
  //  nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(550, 220), 10, 2000, "Team2", color(255), tempMinion2));
  //  nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(500, 310), 10, 2000, "Team2", color(255), tempMinion2));

  tempMinion3 = new AnimSVGMinion(horseMaroon, 0.5, new Point(-200, -200), new Point(200, 200), -1, 3000, moveSpeed, 1, 1, "Neutral", color(0, 0, 255));
  //nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(0, 0), 10, 2000, "Neutral", color(255), tempMinion3));
  //nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(-400, -300), 10, 2000, "Neutral", color(255), tempMinion3));
  //nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(400, 300), 10, 2000, "Neutral", color(255), tempMinion3));
  //nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(-500, -200), 10, 2000, "Neutral", color(255), tempMinion3));
  //nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(-350, -150), 10, 2000, "Neutral", color(255), tempMinion3));
  //nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(-200, -100), 10, 2000, "Neutral", color(255), tempMinion3));
  //nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(200, 100), 10, 2000, "Neutral", color(255), tempMinion3));
  //nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(350, 150), 10, 2000, "Neutral", color(255), tempMinion3));
  //nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(500, 200), 10, 2000, "Neutral", color(255), tempMinion3));
float genMargins = 2.2;
  for (int count = 0; count < numNeutrals; count++) {
    boolean regenPos = false;
    do {
      regenPos = false;
      float x = random(-width/genMargins, width/genMargins);
      float y = random(-height/genMargins, height/genMargins);
      for (PopNodeSVG aNode : nodeManager.getNodes()) {
        float dist = distance(aNode.nodeLoc, new Point(x, y));
        if (dist < 75) regenPos = true;
      }
      if(!regenPos) nodeManager.addNode(new PopNodeSVG(nodeManager, 0.5, new Point(x, y), 5, 2000, "Neutral", color(255), tempMinion3));
    } while (regenPos);
  }

  button = new ButtonController("", "Menu", new Point(0, 0));
}


void draw() {
  background(0);
  java.util.TreeMap <String, Controller> tempControllers = new java.util.TreeMap <String, Controller> (menu.getControllers());

  if ((boolean)tempControllers.get("RESET CONTROLS").getValue()) { 
    menu.resetMenu();
  }
  /*
    if ((boolean)tempControllers.get("RESET ZOOM").getValue()) {
   zoom = 100;
   zoomTransX = 0;
   zoomTransY = 0;
   panXY.x = 0;
   panXY.y = 0;
   }
   */

  frameRate((int)tempControllers.get("FrameRate").getValue());

  /*******************************************
   *           BEGIN DRAW CONTENTS           *
   *******************************************/
  pushMatrix();
  int adjMouseX;
  int adjMouseY;
  if (enableMatrixMovement) {
    translate(width/2.0, height/2.0);  //INITIALLY CENTER SCREEN AT "0,0"
    //translateZoomScroll();
    rotate(radians(0));  //ROTATE ALL CONTENT
    adjMouseX = mouseX - width/2;
    adjMouseY = mouseY - height/2;
  } else {
    adjMouseX = mouseX;
    adjMouseY = mouseY;
  }

  /*******************************************
   *              BEGIN CONTENT              *
   *******************************************/
  boolean pause = button.getValue();
  boolean resume = false;
  if (pause) {
    if (!gamePaused) gamePaused = true;
    else {
      gamePaused = false;
      resume = true;
    }
  }
  if (!gamePaused) {
    if (!resume) {
      aiController.update();
      textFont(cornerFont, 16);
      nodeManager.drawNodes();
      nodeManager.updateMousePos(adjMouseX, adjMouseY);
    } else {
      //do resumeing methods
    }
  } else {
    //do pausing methods
  }

  /*******************************************
   *               END CONTENT               *
   *******************************************/
  popMatrix();
  textAlign(BASELINE);
  menu.drawMenu();
  button.drawController(-15, 0, 85, 40);
  textAlign(LEFT, TOP);

  /*******************************************
   *            END DRAW CONTENTS            *
   *******************************************/

  //drawFPSCounter(); //CORNER TEXTS
  //drawZoomCounter();

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
    //   println(menu.isMenuReleased());
    if (mousePressed) {
      strokeWeight(14); //BIG Strokes!
      if (mouseButton == LEFT && !menu.clickOnMenu(mouseX, mouseY) && menu.isMenuReleased()) {    //Pan the scene only if left click drag
        panXY.x += (mouseX - pmouseX);
        panXY.y += (mouseY - pmouseY);
      }
    } else strokeWeight(8);    //small strokes!
    line(mouseX, mouseY, pmouseX, pmouseY, tempOldMouseColor, tempNewMouseColor, 10);
    //line(pmouseX, pmouseY, mouseX, mouseY);  //Draw line
  }
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
//Move from here to here with this many frames remaining
void animatePointFrames(Point currPoint, Point targetPoint, int framesLeft) {
  float deltaXLeftPerFrame = (targetPoint.x - currPoint.x)/framesLeft;
  float deltaYLeftPerFrame = (targetPoint.y - currPoint.y)/framesLeft;
  currPoint.x += deltaXLeftPerFrame;
  currPoint.y += deltaYLeftPerFrame;
}

void drawFPSCounter() { 
  noStroke();
  fill(0);            //black rectangle in corner
  rect(0, 0, 5, 5);  //rectangle location
  fill(255);        //white text
  textFont(cornerFont, 16);  //font size 16
  text(int(frameRate), 5, 5);  //display framerate in the top
}
void drawZoomCounter() { 
  noStroke();
  fill(0);            //black rectangle in corner
  int fpsWidth = 45;
  int fpsHeight = 25;
  rect(width-fpsWidth, height-fpsHeight, fpsWidth, fpsHeight);  //rectangle location
  fill(255);        //white text
  textFont(cornerFont, 18);  //font size 18
  text(int(zoom), width-fpsWidth+3, height - fpsHeight + 5);  //display zoom in the bottomRight
}
void mouseClicked() {
  print("\nClicked: " + mouseX + ", " + mouseY);
  menu.clickManager(mouseX, mouseY);
  button.clickUpdate(mouseX, mouseY);
}
void mousePressed() {
  mouseLocationPress = new Point(mouseX, mouseY);
  print("\nPressed: " + mouseX + ", " + mouseY);
  menu.pressManager(mouseX, mouseY);
  button.pressUpdate(mouseX, mouseY);
  nodeManager.updateMousePress(mouseX - width/2, mouseY - height/2);
}
void mouseReleased() {
  mouseLocationRelease = new Point(mouseX, mouseY);
  print("\nReleased: " + mouseX + ", " + mouseY);
  menu.releaseManager(mouseX, mouseY);
  button.releaseUpdate(mouseX, mouseY);
  nodeManager.updateMouseRelease(mouseX - width/2, mouseY - height/2);
}
void keyPressed(){
  if(key == ' '){
    nodeManager.selectAllPossible();
  }
}