import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Photosphere extends PApplet {


/**
 * @title DATAVISUALIZATION
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date IDK
 * @author Tiger Mou
 * Description: Makes a bar chart and stuff
 */

public final float ACCY = 1E-9f;
ControllersMenu menu;

PImage photosphere;
int ptsW, ptsH;
int numPointsW;
int numPointsH_2pi; 
int numPointsH;

float[] coorX;
float[] coorY;
float[] coorZ;
float[] multXZ;

int mouseColor = color(100, 100, 100);
private Point panXY = new Point();

PFont cornerFont;    //global font variable for the fps and other counters
final boolean enableMatrixMovement = true;
final static boolean enableDebugShapes = false;

Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines

PeasyCam cam;
boolean usePointMouse = false;
public void setup() {
  //size(900, 600, P3D);  //windowsize
    //fullscreen!
  if (usePointMouse) noCursor();    //hides mouse cursor
        //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect
  ptsW=40;
  ptsH=40;
  initializeSphere(ptsW, ptsH);

  menu = new ControllersMenu(Position.TOP_RIGHT, 300);
  //SLIDER MENU
  menu.addIntSlider("FrameRate", 5, 60, 60);              //IN USE

  menu.addButtonController("RESET CONTROLS", "RESET CONTROLS");    //IN USE
  menu.addButtonController("RESET ZOOM", "RESET ZOOM");    //IN USE

  cam = new PeasyCam(this, 0);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(1500);
  new Thread() {
    public void run() {
      photosphere = loadImage("photosphereLOW.jpg");
    }
  }.start();
}

public void draw() {
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
    // translate(width/2.0, height/2.0);  //INITIALLY CENTER SCREEN AT "0,0"
    translateZoomScroll();
    rotate(radians(0));  //ROTATE ALL CONTENT
  }
  /*******************************************
   *              BEGIN CONTENT              *
   *******************************************/

  fill(255, 110);
  translate(0, -40);
  if(photosphere != null) textureSphere(150, 150, 150, photosphere);


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
    int tempOldMouseColor = color(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));
    if (frameCount % 2 == 0) {              //lower mouse color sampling rate
      int newMouseColor = get(mouseX, mouseY);    //get the color under the mouse cursor
      //"Average" the mouse color
      mouseColor = color((red(newMouseColor)*1 + red(mouseColor)) / 2, (green(newMouseColor)*1 + green(mouseColor))/2, (blue(newMouseColor)*1 + blue(mouseColor))/2);
    }
    stroke(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));  //"reverse" the color
    int tempNewMouseColor = color(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));
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
public void initializeSphere(int numPtsW, int numPtsH_2pi) {

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
    if (PApplet.parseInt(numPointsH_2pi/2) != (float)numPointsH_2pi/2 && i==numPointsH-1) {  // If the numPointsH_2pi is odd and it is at the last pt
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
public void textureSphere(float rx, float ry, float rz, PImage t) { 
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
//Draws a gradiant line
public void line(int xStart, int yStart, int xEnd, int yEnd, int colorStart, int colorEnd, int steps) {
  float[] xs = new float[steps+1];
  float[] ys = new float[steps+1];
  int[] cs = new int[steps+1];
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
public void animatePoint(Point originPoint, Point targetPoint, int framesLeft) {
  float deltaXLeftPerFrame = (targetPoint.x - originPoint.x)/framesLeft;
  float deltaYLeftPerFrame = (targetPoint.y - originPoint.y)/framesLeft;
  originPoint.x += deltaXLeftPerFrame;
  originPoint.y += deltaYLeftPerFrame;
}

public void drawFPSCounter() { 
  noStroke();
  fill(0);            //black rectangle in corner
  rect(0, 0, 35, 30);  //rectangle location
  fill(255);        //white text
  textFont(cornerFont, 22);  //font size 22
  text(PApplet.parseInt(frameRate), 5, 20);  //display framerate in the top
}
public void drawZoomCounter() { 
  noStroke();
  fill(0);            //black rectangle in corner
  int fpsWidth = 37;
  int fpsHeight = 25;
  rect(width-fpsWidth, height-fpsHeight, fpsWidth, fpsHeight);  //rectangle location
  fill(255);        //white text
  textFont(cornerFont, 18);  //font size 18
  text(PApplet.parseInt(zoom), width-fpsWidth+3, height - 5);  //display framerate in the top
}
public void mouseClicked() {
  print("\nClicked: " + mouseX + ", " + mouseY);
  menu.clickManager(mouseX, mouseY);
}
public void mousePressed() {
  mouseLocationPress = new Point(mouseX, mouseY);
  print("\nPressed: " + mouseX + ", " + mouseY);
  menu.pressManager(mouseX, mouseY);
}
public void mouseReleased() {
  mouseLocationRelease = new Point(mouseX, mouseY);
  print("\nReleased: " + mouseX + ", " + mouseY);
  menu.releaseManager(mouseX, mouseY);
}
public class ButtonController extends Controller {

  private PolygonButton button = new PolygonButton();
  private boolean currentValue = false;
  private String buttonLabel = "Null";

  private final int BUTTON_BACKGROUND_COLOR = color(48);
  private final int BUTTON_PADDING = 4;
  private final int HIGHLIGHTS_COLOR = color(30, 211, 111);

  private boolean initialValue = false;

  public ButtonController() {
    textFont = createFont("Calibri", TEXT_SIZE);
  }
  public ButtonController(String name, String buttonLabel, Point menuXY) {
    textFont = createFont("Calibri", TEXT_SIZE);
    this.name = name;
    this.buttonLabel = buttonLabel;
    this.superMenuCoordinates = new Point(menuXY);
    int slidingWidth = controllerWidth*2/5;
    button = new PolygonButton(slidingWidth, controllerY + BUTTON_PADDING, slidingWidth, controllerHeight - BUTTON_PADDING*2);
  }
  public Boolean getValue() {
    boolean temp = currentValue;
    currentValue = false;
    return temp;
  }
  private String getLabel(){
    return this.buttonLabel;
  }
  public void setSliderName(String newName) {
    this.name = newName;
  }
  public void setValue(boolean newValue) {
    this.currentValue = newValue;
  }
  public Object getReturnType() {
    return Float.class;
  }
  public void clickUpdate(int clickX, int clickY) {
    //currentValue = true;
  }
  public void pressUpdate(int clickX, int clickY) {
    isPressed = this.slidingWidthContains(clickX, clickY);
  }
  public void releaseUpdate(int clickX, int clickY) {
    if (isPressed) {
      currentValue = this.slidingWidthContains(clickX, clickY);
    }
    isPressed = false;
  }
  private boolean slidingWidthContains(int clickX, int clickY) {
    float slidingWidth = controllerWidth*2.0f/5.0f;
    return clickX >= slidingWidth && clickX <= slidingWidth*2 && clickY <= controllerY + controllerHeight - BUTTON_PADDING && clickY >= controllerY + BUTTON_PADDING;
  }
  public void resetControls() {
    currentValue = initialValue;
  }
  public void drawController(int controllerX, int controllerY, int controllerWidth, int controllerHeight) {
    this.controllerX = controllerX;
    this.controllerY = controllerY;
    this.controllerWidth = controllerWidth;
    this.controllerHeight = controllerHeight;
    float slidingWidth = controllerWidth*2.0f/5.0f;
    int actualX = PApplet.parseInt(mouseX - superMenuCoordinates.x);
    int actualY = PApplet.parseInt(mouseY - superMenuCoordinates.y);
    //if (isPressed && mousePressed) {
    //  float newValue = (this.getMax()-this.getMin()) * (actualX - slidingWidth)/(slidingWidth) + this.getMin();
    //  this.setValue((round(newValue * pow(10, accuracy))/pow(10, accuracy)));
    //} 
    fill(BACKGROUND_COLOR);
    rect(controllerX, controllerY, controllerWidth, controllerHeight);

    fill(HIGHLIGHTS_COLOR);
    rect(controllerX, controllerY, HIGHLIGHTS_WIDTH, controllerHeight);

    fill(TEXT_COLOR);
    textFont(textFont);
    String tempText = this.getControllerName();
    float nameArea = controllerWidth*2.0f/5.0f - HIGHLIGHTS_WIDTH - TEXT_PADDING_LEFT;
    if (textWidth("...") > nameArea) {
    } else if (textWidth(tempText) > nameArea) {
      while (textWidth(tempText + "...") > nameArea && tempText.length()>0) {
        tempText = tempText.substring(0, tempText.length()-1);
      }
      tempText += "...";
    }
    text(tempText, controllerX + HIGHLIGHTS_WIDTH + TEXT_PADDING_LEFT, controllerY + controllerHeight/2.0f + TEXT_SIZE/4.0f);

    //Hides Text Overflow
    fill(BACKGROUND_COLOR);
    rect(controllerWidth*2.0f/5.0f, controllerY, controllerWidth*3.0f/5.0f, controllerHeight);

    //BUTTON
    fill(BUTTON_BACKGROUND_COLOR);  
    if (this.slidingWidthContains(mouseX - PApplet.parseInt(superMenuCoordinates.x), mouseY - PApplet.parseInt(superMenuCoordinates.y))) {
      fill(HOVER_COLOR);
      if(isPressed) fill(HIGHLIGHTS_COLOR);
    }
    //rect(slidingWidth, controllerY + BUTTON_PADDING, slidingWidth, controllerHeight - BUTTON_PADDING*2);
    button = new PolygonButton(PApplet.parseInt(slidingWidth), controllerY + BUTTON_PADDING, PApplet.parseInt(slidingWidth), controllerHeight - BUTTON_PADDING*2);
    button.drawButton();

    fill(HIGHLIGHTS_COLOR);
    //  rect(slidingWidth, controllerY + BUTTON_PADDING, round(slidingWidth * (this.peekValue()-this.getMin())/(this.getMax()-this.getMin())), controllerHeight - SLIDER_PADDING*2);

////CurrentValue
//    fill(HIGHLIGHTS_COLOR);
//    textFont(textFont);
//    text("" + this.peekValue(), controllerWidth*4.2/5.0, controllerY + controllerHeight/2.0 + TEXT_SIZE/4.0);
    
    fill(TEXT_COLOR);
    text(this.getLabel(), 1.5f*PApplet.parseInt(slidingWidth) - 0.5f*textWidth(this.getLabel()), controllerY + controllerHeight/2.0f + TEXT_SIZE/4.0f);
  }
}
public abstract class Controller<T> {

  protected String name = "Null";
  protected int controllerX = 0;
  protected int controllerY = 0;
  protected int controllerWidth = 0;
  protected int controllerHeight = 0;
  protected final int TEXT_SIZE = 12;
  protected final int TEXT_COLOR = color(214);
  protected final int TEXT_PADDING_LEFT = 5;
  protected final int BACKGROUND_COLOR = color(26);
  protected final int HOVER_COLOR = color(60);

  protected final int HIGHLIGHTS_WIDTH = 3;
  protected Point superMenuCoordinates = new Point();
  protected boolean isPressed = false;
  protected PFont textFont;


  public void updateMenuXY(Point newXY) {
    this.superMenuCoordinates = new Point(newXY);
  }
  public String getControllerName() {
    return this.name;
  }
  public abstract void resetControls();
  public abstract void pressUpdate(int clickX, int clickY);
  public abstract void clickUpdate(int clickX, int clickY);
  public abstract void releaseUpdate(int clickX, int clickY);
  public abstract void drawController(int controllerX, int controllerY, int controllerWidth, int controllerHeight);

  public abstract T getValue();
  public abstract Object getReturnType();
}

public enum Position {
  TOP, TOP_RIGHT//,TOP_LEFT, RIGHT, LEFT, BOTTOM, BOTTOM_LEFT, BOTTOM_RIGHT
}

  public class ControllersMenu {

  PFont textFont;

  private final int TEXT_SIZE = 12;
  private final int TEXT_COLOR = color(214);
  private final int TEXT_PADDING_LEFT = 5;
  private Point menuCoordinates = new Point(); 
  //  private ArrayList<Controller> controllers = new ArrayList<Controller>();
  private java.util.TreeMap<String, Controller> controllers = new java.util.TreeMap<String, Controller>();
  private PolygonButton closeButton = new PolygonButton(0, 0, 0, 0);
  private boolean menuClosed = false;
  private boolean menuWasToggled = false;
  private boolean clickedOnLeftEdge = false;
  private final int EDGE_CLICK_MARGINS = 5;
  private Position position = Position.TOP_RIGHT;
  private int menuWidth = 100;
  private int controllersHeight = 30;
  private final boolean NO_STROKE = true;
  private final int FRAME_BORDER = 0;
  private final int BACKGROUND_COLOR = color(0);
  private final int HOVER_COLOR = color(17);
  private final int FRAME_COLOR = color(180);
  private final int CONTROLLERS_PADDING = 0;
  private final int HIDE_SIZE = 24;
  private final int CLOSE_BUTTON_PADDING = 1;
  private boolean menuReleased = true;

  public ControllersMenu() {
    textFont = createFont("Calibri", TEXT_SIZE);
  }
  public ControllersMenu(Position menuPosition, int menuWidth) {
    textFont = createFont("Calibri", TEXT_SIZE);
    this.position = menuPosition;
    this.menuWidth = menuWidth;
  }

  public void setMenuWidth(int newWidth) {
    this.menuWidth = newWidth;
  }
  public int getMenuWidth() {
    return this.menuWidth;
  }
  public int getMenuHeight() {
    return this.numberOfControllers() * controllersHeight + HIDE_SIZE + CONTROLLERS_PADDING*2*this.numberOfControllers();
  }
  public Position getMenuPosition() {
    return this.position;
  }
  public void setMenuPosition(Position newPosition) {
    this.position = newPosition;
    this.updateMenuPos(this.getMenuPosition());
  }
  public java.util.TreeMap<String, Controller> getControllers() {
    return new java.util.TreeMap<String, Controller>(controllers);
  }
  public int numberOfControllers() {
    return controllers.size();
  }
  public void addIntSlider(String name, int min, int max, int value) {
    controllers.put(name, new IntSlider(name, min, max, value, new Point(this.menuCoordinates)));
  }
  public void addFloatSlider(String name, float min, float max, float value, int accuracy) {
    controllers.put(name, new FloatSlider(name, min, max, value, new Point(this.menuCoordinates), accuracy));
  }
  public void addButtonController(String name, String label) {
    controllers.put(name, new ButtonController(name, label, new Point(this.menuCoordinates)));
  }
  public void addSwitchController(String name, String trueLabel, String falseLabel) {
    controllers.put(name, new SwitchController(name, trueLabel, falseLabel, new Point(this.menuCoordinates)));
  }
  public void setControllersHeight(int newHeight) {
    controllersHeight = newHeight;
  }
  public int getControllersHeight() {
    return controllersHeight;
  }
  public void closeMenu() {
    menuClosed = false;
    menuWasToggled = true;
  }
  public void openMenu() {
    menuClosed = false;
    menuWasToggled = true;
  }
  public void toggleMenu() {
    menuClosed = !menuClosed;
    menuWasToggled = true;
  }
  public void resetMenu() {
    for (Controller tempController : controllers.values()) {
      tempController.resetControls();
    }
  }

  public boolean clickOnLeftEdge(int clickX, int clickY, int plusMinus) {
    int clickedYChange = 0;
    if (clickedOnLeftEdge) clickedYChange = height*2;
    clickedOnLeftEdge = (clickX <= menuCoordinates.x+plusMinus && clickX >= menuCoordinates.x && clickY >= (menuCoordinates.y - clickedYChange) && clickY <= (menuCoordinates.y + this.getMenuHeight() + clickedYChange));
    return clickedOnLeftEdge;
  }
  private void updateMenuPos(Position newPos) {
    if (newPos == Position.TOP) {
      menuCoordinates = new Point(width/2-this.getMenuWidth()/2.0f, -FRAME_BORDER);
    } else if (newPos == Position.TOP_RIGHT) { 
      menuCoordinates = new Point(width-this.getMenuWidth(), -FRAME_BORDER);
    }
    //else if (newPos == Position.TOP_LEFT) { 
    //  menuCoordinates = new Point(-FRAME_BORDER, -FRAME_BORDER);
    //} 
    //else if (newPos == Position.LEFT) { 
    // menuCoordinates = new Point(-FRAME_BORDER, (height/2.0)-(menuHeight/2.0));
    //}
    //else if (newPos == Position.RIGHT) {
    // menuCoordinates = new Point(width-this.getMenuWidth(), (height/2.0)-(menuHeight/2.0));
    //}
    //else if (newPos == Position.BOTTOM) {
    // menuCoordinates = new Point(width/2-(this.getMenuWidth()/2.0), height-menuHeight);
    //}
    //else if (newPos == Position.BOTTOM_LEFT) {
    // menuCoordinates = new Point(-FRAME_BORDER, height-menuHeight);
    //}
    //else if (newPos == Position.BOTTOM_RIGHT) {
    // menuCoordinates = new Point(width-this.getMenuWidth(), height-menuHeight);
    //}
    pushMatrix();
    translate(menuCoordinates.x, menuCoordinates.y);
    if (menuWasToggled) {
      rect(0, 0, this.getMenuWidth(), this.getMenuHeight());
    }
    popMatrix();

    if (menuClosed) menuCoordinates.y -= (this.getMenuHeight() - HIDE_SIZE);
    for (Controller tempController : controllers.values()) {
      tempController.updateMenuXY(menuCoordinates);
    }
  }

  public void clickManager(int clickX, int clickY) {
    menuReleased = false;
    int actualX = clickX - PApplet.parseInt(menuCoordinates.x);
    int actualY = clickY - PApplet.parseInt(menuCoordinates.y);
    if (closeButton.contains(actualX, actualY)) this.toggleMenu();
    for (Controller tempController : controllers.values()) {
      tempController.clickUpdate(actualX, actualY);
    }
  }
  public void pressManager(int clickX, int clickY) {
    if (menuReleased) this.clickOnLeftEdge(clickX, clickY, EDGE_CLICK_MARGINS);
    int actualX = clickX - PApplet.parseInt(menuCoordinates.x);
    int actualY = clickY - PApplet.parseInt(menuCoordinates.y);
    for (Controller tempController : controllers.values()) {
      tempController.pressUpdate(actualX, actualY);
    }
  }
  public void releaseManager(int clickX, int clickY) {
    menuReleased = true;
    int actualX = clickX - PApplet.parseInt(menuCoordinates.x);
    int actualY = clickY - PApplet.parseInt(menuCoordinates.y);
    for (Controller tempController : controllers.values()) {
      tempController.releaseUpdate(actualX, actualY);
    }
  }
  public boolean isMenuReleased() {
    return menuReleased;
  }
  public boolean clickOnMenu(int clickX, int clickY) {
    int actualX = clickX;
    int actualY = clickY;
    boolean state = (actualX >= menuCoordinates.x && actualX <= (menuCoordinates.x + menuWidth) && actualY >= menuCoordinates.y && actualY <= (menuCoordinates.y + this.getMenuHeight()));
    if (state) menuReleased = false;
    return state;
  }

  public void drawMenu() {
    if (clickedOnLeftEdge && mousePressed) {
      if (menuWidth < EDGE_CLICK_MARGINS) {
        menuWidth = EDGE_CLICK_MARGINS;
      }
      menuWidth -= (mouseX - pmouseX);
      if (position == Position.TOP) menuWidth -= (mouseX - pmouseX);
    } 

    ArrayList<Controller> temp = new ArrayList<Controller>(this.getControllers().values());
    int menuHeight = this.getMenuHeight();
    //drawBackground
    fill(BACKGROUND_COLOR);
    strokeWeight(FRAME_BORDER);
    stroke(FRAME_COLOR);
    if (NO_STROKE) noStroke();
    this.updateMenuPos(this.getMenuPosition());

    pushMatrix();
    translate(menuCoordinates.x, menuCoordinates.y);

    rect(0, 0, this.getMenuWidth(), menuHeight);
    int controllersWidth = this.getMenuWidth() - CONTROLLERS_PADDING*2;
    if (controllersWidth < 0) controllersWidth = 0;
    for (int index = 0; index < this.numberOfControllers(); index++) {
      temp.get(index).drawController(CONTROLLERS_PADDING, CONTROLLERS_PADDING*2*index + CONTROLLERS_PADDING + this.getControllersHeight()*index, controllersWidth, this.getControllersHeight());
    }
    int closeButtonWidth = controllersWidth - CLOSE_BUTTON_PADDING*2;
    if (closeButtonWidth < 0) closeButtonWidth = 0;
    closeButton = new PolygonButton(CONTROLLERS_PADDING + CLOSE_BUTTON_PADDING, menuHeight - HIDE_SIZE + CLOSE_BUTTON_PADDING, closeButtonWidth, HIDE_SIZE - CLOSE_BUTTON_PADDING*2 - CONTROLLERS_PADDING);

    fill(BACKGROUND_COLOR);
    if (closeButton.contains(mouseX - PApplet.parseInt(menuCoordinates.x), mouseY - PApplet.parseInt(menuCoordinates.y))) fill(HOVER_COLOR);
    closeButton.drawButton();

    fill(TEXT_COLOR);
    textFont(textFont);
    String openClose = (menuClosed)? "Open Controls" : "Close Controls";
    float textX = (textWidth(openClose) <= controllersWidth - CLOSE_BUTTON_PADDING*2 + TEXT_PADDING_LEFT) ? menuWidth/2.0f - textWidth(openClose)/2.0f : (CONTROLLERS_PADDING + CLOSE_BUTTON_PADDING + TEXT_PADDING_LEFT); 
    text(openClose, textX, menuHeight - HIDE_SIZE/2.0f - CLOSE_BUTTON_PADDING + TEXT_SIZE/3.0f);

    popMatrix();
    menuWasToggled = false;
  }
}
public class FloatSlider extends Controller {

  private float min = 0;
  private float max = 1;
  private float currentValue = 0;
  private int accuracy = 0;
  private final int ACCURACY_MAX = 7;
  private final int ACCURACY_MIN = 0;

  private final int SLIDER_BACKGROUND_COLOR = color(48);
  private final int SLIDER_PADDING = 4;
  private final int HIGHLIGHTS_COLOR = color(30, 211, 111);

  private float initialValue = 0;
  private float initialMin = 0;
  private float initialMax = 0;

  public FloatSlider() {
    textFont = createFont("Calibri", TEXT_SIZE);
  }
  public FloatSlider(String name, float min, float max, float value, Point menuXY, int accuracy) {
    textFont = createFont("Calibri", TEXT_SIZE);
    this.name = name;
    this.min = min;
    this.max = max;
    this.setValue(value);
    this.superMenuCoordinates = new Point(menuXY);
    if (accuracy < ACCURACY_MIN) this.accuracy = ACCURACY_MIN;
    else if (accuracy > ACCURACY_MAX) this.accuracy = ACCURACY_MAX;
    else this.accuracy = accuracy;
    this.initialValue = value;
    this.initialMax = max;
    this.initialMin = min;
  }

  public float getMin() {
    return this.min;
  }
  public float getMax() {
    return this.max;
  }
  public float getRange() {
    return this.max - this.min;
  }
  public Float getValue() {
    return this.currentValue;
  }
  public void setSliderName(String newName) {
    this.name = newName;
  }
  public void setMin(float newMin) {
    this.min = newMin;
    this.setValue(this.getValue());
  }
  public void setMax(float newMax) {
    this.max = newMax;
    this.setValue(this.getValue());
  }
  public void setValue(float newValue) {
    if (newValue > this.getMax()) newValue = this.getMax();
    if (newValue < this.getMin()) newValue = this.getMin();
    this.currentValue = newValue;
  }
  public Object getReturnType() {
    return Float.class;
  }
  public void clickUpdate(int clickX, int clickY) {
  }
  public void pressUpdate(int clickX, int clickY) {
    int clickedChangeY = 0;
    int clickedChangeX = 0;
    if (isPressed) {
      clickedChangeY = height*2;
      clickedChangeX = width*2;
    }
    float slidingWidth = controllerWidth*2.0f/5.0f;
    isPressed = (clickX >= (slidingWidth - clickedChangeX) && clickX <= (slidingWidth*2 + clickedChangeX) && clickY <= (controllerY + controllerHeight - SLIDER_PADDING + clickedChangeY) && clickY >= (controllerY + SLIDER_PADDING - clickedChangeY));
  }
  public void releaseUpdate(int clickX, int clickY) {
    isPressed = false;
  }
  private boolean slidingWidthContains(int clickX, int clickY) {
    float slidingWidth = controllerWidth*2.0f/5.0f;
    return clickX >= slidingWidth && clickX <= slidingWidth*2 && clickY <= controllerY + controllerHeight - SLIDER_PADDING && clickY >= controllerY + SLIDER_PADDING;
  }
  public void resetControls() {
    this.min = initialMin;
    this.max = initialMax;
    this.currentValue = initialValue;
  }
  public void drawController(int controllerX, int controllerY, int controllerWidth, int controllerHeight) {

    this.controllerX = controllerX;
    this.controllerY = controllerY;
    this.controllerWidth = controllerWidth;
    this.controllerHeight = controllerHeight;
    float slidingWidth = controllerWidth*2.0f/5.0f;
    int actualX = PApplet.parseInt(mouseX - superMenuCoordinates.x);
    int actualY = PApplet.parseInt(mouseY - superMenuCoordinates.y);
    if (isPressed && mousePressed) {
      float newValue = (this.getMax()-this.getMin()) * (actualX - slidingWidth)/(slidingWidth) + this.getMin();
      this.setValue((round(newValue * pow(10, accuracy))/pow(10, accuracy)));
    } 
    fill(BACKGROUND_COLOR);
    rect(controllerX, controllerY, controllerWidth, controllerHeight);

    fill(HIGHLIGHTS_COLOR);
    rect(controllerX, controllerY, HIGHLIGHTS_WIDTH, controllerHeight);

    fill(TEXT_COLOR);
    textFont(textFont);
    String tempText = this.getControllerName();
    float nameArea = controllerWidth*2.0f/5.0f - HIGHLIGHTS_WIDTH - TEXT_PADDING_LEFT;
    if (textWidth("...") > nameArea) {
    } else if (textWidth(tempText) > nameArea) {
      while (textWidth(tempText + "...") > nameArea && tempText.length()>0) {
        tempText = tempText.substring(0, tempText.length()-1);
      }
      tempText += "...";
    }
    text(tempText, controllerX + HIGHLIGHTS_WIDTH + TEXT_PADDING_LEFT, controllerY + controllerHeight/2.0f + TEXT_SIZE/4.0f);

    //Hides Text Overflow
    fill(BACKGROUND_COLOR);
    rect(controllerWidth*2.0f/5.0f, controllerY, controllerWidth*3.0f/5.0f, controllerHeight);

    fill(SLIDER_BACKGROUND_COLOR);
    if (this.slidingWidthContains(mouseX - PApplet.parseInt(superMenuCoordinates.x), mouseY - PApplet.parseInt(superMenuCoordinates.y))) fill(HOVER_COLOR);
    rect(slidingWidth, controllerY + SLIDER_PADDING, slidingWidth, controllerHeight - SLIDER_PADDING*2);

    fill(HIGHLIGHTS_COLOR);
    rect(slidingWidth, controllerY + SLIDER_PADDING, round(slidingWidth * (this.getValue()-this.getMin())/(this.getMax()-this.getMin())), controllerHeight - SLIDER_PADDING*2);

    //CurrentValue
    fill(HIGHLIGHTS_COLOR);
    textFont(textFont);
    text("" + this.getValue(), controllerWidth*4.2f/5.0f, controllerY + controllerHeight/2.0f + TEXT_SIZE/4.0f);
  }
}
public class IntSlider extends Controller {

  private int min = 0;
  private int max = 1;
  private int currentValue = 0;

  private final int SLIDER_BACKGROUND_COLOR = color(48);
  private final int SLIDER_PADDING = 4;
  private final int HIGHLIGHTS_COLOR = color(47, 161, 214);

  private int initialValue = 0;
  private int initialMin = 0;
  private int initialMax = 0;

  public IntSlider() {
    textFont = createFont("Calibri", TEXT_SIZE);
  }
  public IntSlider(String name, int min, int max, int value, Point menuXY) {
    textFont = createFont("Calibri", TEXT_SIZE);
    this.name = name;
    this.min = min;
    this.max = max;
    this.setValue(value);
    this.superMenuCoordinates = new Point(menuXY);
    this.initialValue = value;
    this.initialMax = max;
    this.initialMin = min;
  }

  public int getMin() {
    return this.min;
  }
  public int getMax() {
    return this.max;
  }
  public int getRange() {
    return this.max - this.min;
  }
  public Integer getValue() {
    return this.currentValue;
  }
  public void setSliderName(String newName) {
    this.name = newName;
  }
  public void setMin(int newMin) {
    this.min = newMin;
    this.setValue(this.getValue());
  }
  public void setMax(int newMax) {
    this.max = newMax;
    this.setValue(this.getValue());
  }
  public void setValue(int newValue) {
    if (newValue > this.getMax()) newValue = this.getMax();
    if (newValue < this.getMin()) newValue = this.getMin();
    this.currentValue = newValue;
  }
  public Object getReturnType() {
    return Integer.class;
  }
  public void clickUpdate(int clickX, int clickY) {
  }
  public void pressUpdate(int clickX, int clickY) {
    int clickedChangeY = 0;
    int clickedChangeX = 0;
    if (isPressed) {
      clickedChangeY = height*2;
      clickedChangeX = width*2;
    }
    float slidingWidth = controllerWidth*2.0f/5.0f;
    isPressed = (clickX >= (slidingWidth - clickedChangeX) && clickX <= (slidingWidth*2 + clickedChangeX) && clickY <= (controllerY + controllerHeight - SLIDER_PADDING + clickedChangeY) && clickY >= (controllerY + SLIDER_PADDING - clickedChangeY));
  }
  public void releaseUpdate(int clickX, int clickY) {
    isPressed = false;
  }
  private boolean slidingWidthContains(int clickX, int clickY) {
    float slidingWidth = controllerWidth*2.0f/5.0f;
    return clickX >= slidingWidth && clickX <= slidingWidth*2 && clickY <= controllerY + controllerHeight - SLIDER_PADDING && clickY >= controllerY + SLIDER_PADDING;
  }
  public void resetControls() {
    this.min = initialMin;
    this.max = initialMax;
    this.currentValue = initialValue;
  }
  public void drawController(int controllerX, int controllerY, int controllerWidth, int controllerHeight) {

    this.controllerX = controllerX;
    this.controllerY = controllerY;
    this.controllerWidth = controllerWidth;
    this.controllerHeight = controllerHeight;
    float slidingWidth = controllerWidth*2.0f/5.0f;
    int actualX = PApplet.parseInt(mouseX - superMenuCoordinates.x);
    int actualY = PApplet.parseInt(mouseY - superMenuCoordinates.y);
    if (isPressed && mousePressed) {
      float newValue = (this.getMax()-this.getMin()) * (actualX - slidingWidth)/(slidingWidth) + this.getMin();
      this.setValue(round(newValue));
    } 
    fill(BACKGROUND_COLOR);
    rect(controllerX, controllerY, controllerWidth, controllerHeight);

    fill(HIGHLIGHTS_COLOR);
    rect(controllerX, controllerY, HIGHLIGHTS_WIDTH, controllerHeight);

    fill(TEXT_COLOR);
    textFont(textFont);
    String tempText = this.getControllerName();
    float nameArea = controllerWidth*2.0f/5.0f - HIGHLIGHTS_WIDTH - TEXT_PADDING_LEFT;
    if (textWidth("...") > nameArea) {
    } else if (textWidth(tempText) > nameArea) {
      while (textWidth(tempText + "...") > nameArea && tempText.length()>0) {
        tempText = tempText.substring(0, tempText.length()-1);
      }
      tempText += "...";
    }
    text(tempText, controllerX + HIGHLIGHTS_WIDTH + TEXT_PADDING_LEFT, controllerY + controllerHeight/2.0f + TEXT_SIZE/4.0f);

    //Hides Text Overflow
    fill(BACKGROUND_COLOR);
    rect(controllerWidth*2.0f/5.0f, controllerY, controllerWidth*3.0f/5.0f, controllerHeight);

    fill(SLIDER_BACKGROUND_COLOR);
    if (this.slidingWidthContains(mouseX - PApplet.parseInt(superMenuCoordinates.x), mouseY - PApplet.parseInt(superMenuCoordinates.y))) fill(HOVER_COLOR);
    rect(slidingWidth, controllerY + SLIDER_PADDING, slidingWidth, controllerHeight - SLIDER_PADDING*2);

    fill(HIGHLIGHTS_COLOR);
    rect(slidingWidth, controllerY + SLIDER_PADDING, round(slidingWidth * (this.getValue()-this.getMin())/(this.getMax()-this.getMin())), controllerHeight - SLIDER_PADDING*2);

    //CurrentValue
    fill(HIGHLIGHTS_COLOR);
    textFont(textFont);
    text(this.getValue(), controllerWidth*4.2f/5.0f, controllerY + controllerHeight/2.0f + TEXT_SIZE/4.0f);
  }
}
/**
 * Public class for an x y point
 */
public class Point {
  public float x = 0, y = 0;

  Point(Point aPoint) {
    this.x = aPoint.x;
    this.y = aPoint.y;
  }
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  Point() {
  }
}

public void line(Point firstPoint, Point secondPoint) {
  line(firstPoint.x, firstPoint.y, secondPoint.x, secondPoint.y);
}
public void point(Point aPoint) {
  point(aPoint.x, aPoint.y);
}
public void line(float x, float y, Point secondPoint) {
  line(x, y, secondPoint.x, secondPoint.y);
}
public void line(Point firstPoint, float x, float y) {
  line(firstPoint.x, firstPoint.y, x, y);
}
public class PolygonButton {
  int x = 0, y = 0, buttonWidth = 0, buttonHeight = 0;
  java.awt.Polygon button;

  public PolygonButton() {
    button = new java.awt.Polygon();
  }
  public PolygonButton(int x, int y, int buttonWidth, int buttonHeight) {
    this.x = x;
    this.y = y;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    button = new java.awt.Polygon();
  }
  public void drawButton() {
    button = new java.awt.Polygon();
    button.addPoint(x, y);
    button.addPoint(x + buttonWidth, y);
    button.addPoint(x + buttonWidth, y + buttonHeight);
    button.addPoint(x, y + buttonHeight);
    button.addPoint(x, y);
    beginShape();
    for (int i = 0; i < button.npoints; i++) {
      vertex(button.xpoints[i], button.ypoints[i]);
    } 
    endShape();
  }

  public void setX(int newX) {
    this.x = newX;
  }
  public void setY(int newY) {
    this.y = newY;
  }
  public void setWidth(int newWidth) {
    this.buttonWidth = newWidth;
  }
  public void setHeight(int newHeight) {
    this.buttonHeight = newHeight;
  }
  public boolean contains(int clickX, int clickY) {
    button = new java.awt.Polygon();
    button.addPoint(x, y);
    button.addPoint(x + buttonWidth, y);
    button.addPoint(x + buttonWidth, y + buttonHeight);
    button.addPoint(x, y + buttonHeight);
    button.addPoint(x, y);
    //    println(x + " " + y + " " + buttonWidth + " " + buttonHeight);
    return button.contains(clickX, clickY);
  }
}
//ZOOM SCROLL
//WORK IN PROGRESS

private float zoom = 100;
private final float zoomMin = 10;
private final float zoomMax = 2000;

//private boolean userZoomed = false;
private Point scrollLocation = new Point();
private float zoomTransX = 0, zoomTransY = 0, zoomDelta = 0, lastZoomDelta = 0;

public void mouseWheel(MouseEvent event) {
  scrollLocation = new Point(mouseX, mouseY);
  // userZoomed = true;  //boolean if the user scrollled or not
  float e = event.getCount();

  float screenWHalf = width/2.0f;
  float screenHHalf = height/2.0f;

  float stepSize = 1.5f;  //initial zoom step size
  zoomDelta = e * stepSize * (zoom/100.0f);
  if (zoom <= zoomMin && zoomDelta>0) zoomDelta = 0;    //limit the zooms
  if (zoom >= zoomMax && zoomDelta<0) zoomDelta = 0;    //limit the zooms
  zoom -= zoomDelta;                      //increment or decrement the zoom
  zoomTransX +=  ((mouseX - screenWHalf)) * zoomDelta/100;
  zoomTransY +=  ((mouseY - screenHHalf)) * zoomDelta/100;
  lastZoomDelta += zoomDelta;              //zoom delta for decay
  if (zoom <= zoomMin) zoom = zoomMin;    //limit the zooms
  if (zoom >= zoomMax) zoom = zoomMax;    //limit the zooms
}

public void translateZoomScroll() {
  float screenWHalf = width/2.0f;
  float screenHHalf = height/2.0f;

  lastZoomDelta *= 0.60f;    //DECAY THE DELTA
  if (abs(lastZoomDelta) <= 0.005f) lastZoomDelta = 0;  //TO GET RID OF THE "TAIL"
  zoom -= (lastZoomDelta);      //increment zoom by the decayed "momentum" value
  if (zoom <= zoomMin) zoom = zoomMin;  //limit zoom by bounds
  if (zoom >= zoomMax) zoom = zoomMax;
  zoomTransX += (scrollLocation.x - screenWHalf)  * (lastZoomDelta/ 100.0f);
  zoomTransY +=  (scrollLocation.y - screenHHalf)  * (lastZoomDelta/ 100.0f);

  translate(zoomTransX + panXY.x, zoomTransY + panXY.y);  //ZOOM INTO CURSOR
  scale(zoom/100.0f);    //matrix SCALE/ZOOM
}
public class SwitchController extends Controller {

  private PolygonButton button = new PolygonButton();
  private boolean currentValue = false;
  private String trueButtonLabel = "False";
  private String falseButtonLabel = "True";

  private final int BUTTON_BACKGROUND_COLOR = color(48);
  private final int BUTTON_PADDING = 4;
  private final int HIGHLIGHTS_COLOR = color(30, 211, 111);

  private boolean initialValue = false;

  public SwitchController() {
    textFont = createFont("Calibri", TEXT_SIZE);
  }
  public SwitchController(String name, String trueButtonLabel, String falseButtonLabel, Point menuXY) {
    textFont = createFont("Calibri", TEXT_SIZE);
    this.name = name;
    this.trueButtonLabel = trueButtonLabel;
    this.falseButtonLabel = falseButtonLabel;
    this.superMenuCoordinates = new Point(menuXY);
    int slidingWidth = controllerWidth*2/5;
    button = new PolygonButton(slidingWidth, controllerY + BUTTON_PADDING, slidingWidth, controllerHeight - BUTTON_PADDING*2);
  }
  public Boolean getValue() {
    return currentValue;
  }
  private String getLabel(){
    if(this.getValue()) return this.falseButtonLabel;
    else return this.trueButtonLabel;
  }
  public void setSliderName(String newName) {
    this.name = newName;
  }
  public void setValue(boolean newValue) {
    this.currentValue = newValue;
  }
  public Object getReturnType() {
    return Float.class;
  }
  public void clickUpdate(int clickX, int clickY) {
    //currentValue = true;
  }
  public void pressUpdate(int clickX, int clickY) {
    isPressed = this.slidingWidthContains(clickX, clickY);
  }
  public void releaseUpdate(int clickX, int clickY) {
    if (isPressed) {
      if( this.slidingWidthContains(clickX, clickY)) currentValue = !currentValue;
    }
    isPressed = false;
  }
  private boolean slidingWidthContains(int clickX, int clickY) {
    float slidingWidth = controllerWidth*2.0f/5.0f;
    return clickX >= slidingWidth && clickX <= slidingWidth*2 && clickY <= controllerY + controllerHeight - BUTTON_PADDING && clickY >= controllerY + BUTTON_PADDING;
  }
  public void resetControls() {
    currentValue = initialValue;
  }
  public void drawController(int controllerX, int controllerY, int controllerWidth, int controllerHeight) {
    this.controllerX = controllerX;
    this.controllerY = controllerY;
    this.controllerWidth = controllerWidth;
    this.controllerHeight = controllerHeight;
    float slidingWidth = controllerWidth*2.0f/5.0f;
    int actualX = PApplet.parseInt(mouseX - superMenuCoordinates.x);
    int actualY = PApplet.parseInt(mouseY - superMenuCoordinates.y);
    //if (isPressed && mousePressed) {
    //  float newValue = (this.getMax()-this.getMin()) * (actualX - slidingWidth)/(slidingWidth) + this.getMin();
    //  this.setValue((round(newValue * pow(10, accuracy))/pow(10, accuracy)));
    //} 
    fill(BACKGROUND_COLOR);
    rect(controllerX, controllerY, controllerWidth, controllerHeight);

    fill(HIGHLIGHTS_COLOR);
    rect(controllerX, controllerY, HIGHLIGHTS_WIDTH, controllerHeight);

    fill(TEXT_COLOR);
    textFont(textFont);
    String tempText = this.getControllerName();
    float nameArea = controllerWidth*2.0f/5.0f - HIGHLIGHTS_WIDTH - TEXT_PADDING_LEFT;
    if (textWidth("...") > nameArea) {
    } else if (textWidth(tempText) > nameArea) {
      while (textWidth(tempText + "...") > nameArea && tempText.length()>0) {
        tempText = tempText.substring(0, tempText.length()-1);
      }
      tempText += "...";
    }
    text(tempText, controllerX + HIGHLIGHTS_WIDTH + TEXT_PADDING_LEFT, controllerY + controllerHeight/2.0f + TEXT_SIZE/4.0f);

    //Hides Text Overflow
    fill(BACKGROUND_COLOR);
    rect(controllerWidth*2.0f/5.0f, controllerY, controllerWidth*3.0f/5.0f, controllerHeight);

    //BUTTON
    fill(BUTTON_BACKGROUND_COLOR);  
    if (this.slidingWidthContains(mouseX - PApplet.parseInt(superMenuCoordinates.x), mouseY - PApplet.parseInt(superMenuCoordinates.y))) {
      fill(HOVER_COLOR);
      if(isPressed) fill(HIGHLIGHTS_COLOR);
    }
    //rect(slidingWidth, controllerY + BUTTON_PADDING, slidingWidth, controllerHeight - BUTTON_PADDING*2);
    button = new PolygonButton(PApplet.parseInt(slidingWidth), controllerY + BUTTON_PADDING, PApplet.parseInt(slidingWidth), controllerHeight - BUTTON_PADDING*2);
    button.drawButton();

    fill(HIGHLIGHTS_COLOR);
    //  rect(slidingWidth, controllerY + BUTTON_PADDING, round(slidingWidth * (this.peekValue()-this.getMin())/(this.getMax()-this.getMin())), controllerHeight - SLIDER_PADDING*2);

////CurrentValue
//    fill(HIGHLIGHTS_COLOR);
//    textFont(textFont);
//    text("" + this.peekValue(), controllerWidth*4.2/5.0, controllerY + controllerHeight/2.0 + TEXT_SIZE/4.0);
    
    fill(TEXT_COLOR);
    text(this.getLabel(), 1.5f*PApplet.parseInt(slidingWidth) - 0.5f*textWidth(this.getLabel()), controllerY + controllerHeight/2.0f + TEXT_SIZE/4.0f);
  }
}
  public void settings() {  fullScreen(P3D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Photosphere" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
