/**
 * @title TIGER GAME
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date IDK
 * @author Tiger Mou
 * Description: Makes a TIGER GAME YAY
 */
public final float ACCY = 1E-9f;
ControllersMenu menu;

//0 is no connection
//1 is right
//2 is down
//3 is left
//4 is up
//[from][to]
Integer[][] nodeMap = new Integer[][]
  {//0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
  {0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //0
  {0, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //1
  {4, 3, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0}, //2
  {4, 0, 3, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0}, //3
  {4, 0, 0, 3, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0}, //4
  {4, 0, 0, 0, 3, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0}, //5
  {0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0}, //6
  {0, 4, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0}, //7
  {0, 0, 4, 0, 0, 0, 0, 3, 0, 1, 0, 0, 0, 2, 0, 0, 0}, //8
  {0, 0, 0, 4, 0, 0, 0, 0, 3, 0, 1, 0, 0, 0, 2, 0, 0}, //9
  {0, 0, 0, 0, 4, 0, 0, 0, 0, 3, 0, 1, 0, 0, 0, 2, 0}, //10
  {0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 3, 0, 1, 0, 0, 0, 2}, //11
  {0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}, //12
  {0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 1, 0, 0}, //13
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 3, 0, 1, 0}, //14
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 3, 0, 1}, //15
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 3, 0}  //16
}; 
NodeBoard board;
int lambsPlaced = 0;
int totalLambs = 10;
boolean initLamb = false;
boolean lambSet = false;
boolean lambSelected = false;
boolean lambValidMove = false;
boolean lambTriedInvalid = false;
int selectedLamb = -1;
int selectedLambPos = -1;
boolean initTiger = false;
boolean tigerSelected = false;
int selectedTiger = -1;
int selectedTigerPos = -1;
boolean tigerValidMove = false;
boolean tigerTriedInvalid = false;
Occupant whoTurn = Occupant.LAMB;

color mouseColor = color(100, 100, 100);
private Point panXY = new Point();

PFont cornerFont;    //global font variable for the fps and other counters
final boolean enableMatrixMovement = false;
final static boolean enableDebugShapes = false;

Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines

private float worldRotation = 0;

void setup() {
  //size(900, 600);  //windowsize
  fullScreen();  //fullscreen!
  noCursor();    //hides mouse cursor
  smooth();      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect

  menu = new ControllersMenu(Position.TOP_RIGHT, 300);
  //SLIDER MENU
  menu.addIntSlider("FrameRate", 5, 60, 60);              //IN USE

  menu.addButtonController("RESET CONTROLS", "RESET CONTROLS");    //IN USE
  menu.addButtonController("RESET ZOOM", "RESET ZOOM");    //IN USE


  board = new NodeBoard(nodeMap);
  //NODES INFO AND STUFF
  int vertSep = 140;
  int horizSep = 90;
  int circleSize = 65;
  board.add(new Node(0, Occupant.TIGER, new Point(0, -2*vertSep + 0.5*vertSep), circleSize));
  board.add(new Node(1, null, new Point(-3*horizSep, -vertSep + 0.5*vertSep), circleSize));
  board.add(new Node(2, null, new Point(-2*horizSep, -vertSep + 0.5*vertSep), circleSize));
  board.add(new Node(3, Occupant.TIGER, new Point(-1*horizSep, -vertSep + 0.5*vertSep), circleSize));
  board.add(new Node(4, Occupant.TIGER, new Point(1*horizSep, -vertSep + 0.5*vertSep), circleSize));
  board.add(new Node(5, null, new Point(2*horizSep, -vertSep + 0.5*vertSep), circleSize));
  board.add(new Node(6, null, new Point(3*horizSep, -vertSep + 0.5*vertSep), circleSize));
  board.add(new Node(7, null, new Point(-6*horizSep, 0 + 0.5*vertSep), circleSize));
  board.add(new Node(8, null, new Point(-4*horizSep, 0 + 0.5*vertSep), circleSize));
  board.add(new Node(9, null, new Point(-2*horizSep, 0 + 0.5*vertSep), circleSize));
  board.add(new Node(10, null, new Point(2*horizSep, 0 + 0.5*vertSep), circleSize));
  board.add(new Node(11, null, new Point(4*horizSep, 0 + 0.5*vertSep), circleSize));
  board.add(new Node(12, null, new Point(6*horizSep, 0 + 0.5*vertSep), circleSize));
  board.add(new Node(13, null, new Point(-6*horizSep, vertSep + 0.5*vertSep), circleSize));
  board.add(new Node(14, null, new Point(-3*horizSep, vertSep + 0.5*vertSep), circleSize));
  board.add(new Node(15, null, new Point(3*horizSep, vertSep + 0.5*vertSep), circleSize));
  board.add(new Node(16, null, new Point(6*horizSep, vertSep + 0.5*vertSep), circleSize));
}

void draw() {
  background(0);
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
  translate(width/2, height/2);
  int actualX = mouseX - width/2;
  int actualY = mouseY - height/2;  
  fill(0);
  stroke(220);
  strokeWeight(4);
  board.drawNodeConnections();
  board.drawNodes(color(0, 255, 0), color(220));

  if (whoTurn == Occupant.LAMB) {
    if (!initLamb) {
      board.unselectAll();
      lambSet = false;
      lambSelected = false;
      lambValidMove = false;
      initLamb = true;
    }
    if (lambsPlaced < totalLambs) {

      if (!lambSet) {
        fill(220);
        tigerText("LAMBS: Where do you want to place a lamb? (" + lambsPlaced + " placed)");
        selectedLamb = board.getSelection();
        if (selectedLamb != -1 && board.nodes.get(selectedLamb).getOccupant() == null) {
          board.nodes.get(selectedLamb).setOccupant(Occupant.LAMB);
          lambSet = true;
          lambsPlaced++;
        }
      } else {
        whoTurn = Occupant.TIGER;
        initTiger = false;
      }
      if (lambsPlaced >= totalLambs) {
        whoTurn = Occupant.TIGER;
        initTiger = false;
      }
    } else {
      if (!lambSelected) {
        fill(220);
        tigerText("LAMBS: All lambs placed. Which lamb do you want to move?");
        selectedLamb = board.getSelection();
        if (selectedLamb != -1 && board.nodes.get(selectedLamb).getOccupant() == Occupant.LAMB) {
          lambSelected = true;
        }
      } else if (!lambValidMove) {
        fill(220);
        if (!lambTriedInvalid) tigerText("LAMBS: Select a new position.");
        else tigerText("LAMBS: INVALID MOVE. Select a new position.!");
        int tempNewPos = board.getSelection();
        if (tempNewPos != selectedLambPos) lambTriedInvalid = false;
        selectedLambPos = tempNewPos;
        if (selectedLambPos != -1 && board.nodes.get(selectedLambPos).getOccupant() == null) {
          //if adjacent
          if (board.nodeConnects(selectedLamb, selectedLambPos)) {
            board.nodes.get(selectedLamb).setOccupant(null);
            board.nodes.get(selectedLambPos).setOccupant(Occupant.LAMB);
            lambValidMove = true;
          }
        } else if (selectedLambPos != selectedLamb) {
          lambTriedInvalid = true;
        }
      } else {
        whoTurn = Occupant.TIGER;
        initTiger = false;
      }
    }
  }
  //TIGERS TURN
  else if (whoTurn == Occupant.TIGER) {
    if (!initTiger) {
      board.unselectAll();
      selectedTiger = -1;
      tigerSelected = false;
      tigerValidMove = false;
      initTiger = true;
    }
    if (!tigerSelected) {
      fill(220);
      tigerText("TIGERS: Select a tiger.");
      selectedTiger = board.getSelection();
      if (selectedTiger != -1 && board.nodes.get(selectedTiger).getOccupant() == Occupant.TIGER) {
        tigerSelected = true;
      }
    } else if (!tigerValidMove) {
      fill(220);
      if (!tigerTriedInvalid) tigerText("TIGERS: Select a new position.");
      else tigerText("TIGERS: INVALID MOVE. Select a new position.!");
      int tempNewPos = board.getSelection();
      if (tempNewPos != selectedTigerPos) tigerTriedInvalid = false;
      selectedTigerPos = tempNewPos;
      if (selectedTigerPos != -1 && board.nodes.get(selectedTigerPos).getOccupant() == null) {
        //checkAdjacency or path through lamb
        //if adjacent
        if (board.nodeConnects(selectedTiger, selectedTigerPos)) {
          board.nodes.get(selectedTiger).setOccupant(null);
          board.nodes.get(selectedTigerPos).setOccupant(Occupant.TIGER);
          tigerValidMove = true;
        } else {
          if (!tigerTriedInvalid) {
            //check passthroughLAMB
            ArrayList<Integer> connections = new ArrayList<Integer>(board.nodeConnectsTo(selectedTiger));
            tigerTriedInvalid = true;
            for (int hopNode : connections) {
              //if hopNode is a lamb the 3 are connected
              if (board.nodes.get(hopNode).getOccupant() == Occupant.LAMB && board.nodeConnects(hopNode, selectedTigerPos) && board.nodesDir(selectedTiger, hopNode) == board.nodesDir(hopNode, selectedTigerPos)) {
                board.nodes.get(selectedTiger).setOccupant(null);
                board.nodes.get(hopNode).setOccupant(null);
                board.nodes.get(selectedTigerPos).setOccupant(Occupant.TIGER);
                tigerValidMove = true;
                tigerTriedInvalid = false;
              }
            }
          }
        }
      } else if (selectedTigerPos != selectedTiger) {
        tigerTriedInvalid = true;
      }
    } else {
      whoTurn = Occupant.LAMB;
      initLamb = false;
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
  if (enableMatrixMovement) drawZoomCounter();

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

void tigerText(String text) {
  text(text, -textWidth(text)/2.0, 300);
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
  board.clickUpdate(mouseX - width/2, mouseY-height/2);
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