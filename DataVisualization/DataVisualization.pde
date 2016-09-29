import peasy.*;
/**
 * @title DATAVISUALIZATION
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date IDK
 * @author Tiger Mou
 * Description: Makes a bar chart and stuff. THIS PROJECT USES THE PEASYCAM LIBRARIES
 */

public final float ACCY = 1E-9f;
ControllersMenu menu;
String countryName = "Country";
int countryInc = 0;

FloatTable data; //holds the data
//minmax values
float dataMin, dataMax;
//4 corners of the graph
float plotX1, plotY1;
float plotX2, plotY2;
//minmax values
int yearMin, yearMax;
//holds the years
int[] years;
//scales the z axis
float zScale = 0;

color mouseColor = color(100, 100, 100);
private Point panXY = new Point();

PFont cornerFont;    //global font variable for the fps and other counters
final boolean enableMatrixMovement = false;
final static boolean enableDebugShapes = false;

Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines

PeasyCam cam;
boolean usePointMouse = false;
ArrayList<String> countryIndex;
void setup() {
  //size(900, 600);  //windowsize
  fullScreen(P3D);  //fullscreen!
  if (usePointMouse) noCursor();    //hides mouse cursor
  smooth();      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect

  menu = new ControllersMenu(Position.TOP_RIGHT, 300);
  //SLIDER MENU
 // menu.addIntSlider("FrameRate", "FrameRate", 5, 60, 60);              //IN USE
  menu.addSwitchController("Toggle All/One", "LOOK AT ALL", "LOOK AT ONE");
  menu.addButtonController("RESET CONTROLS", "RESET CONTROLS");    //IN USE
//  menu.addButtonController("RESET ZOOM", "RESET ZOOM");    //IN USE

  data = new FloatTable("carbon.tsv");
  years = int(data.getColumnNames());
  yearMin = years[0];
  yearMax = years[years.length - 1];
  dataMin = 0;
  dataMax = data.getTableMax();
  println(dataMax);
  countryIndex = new ArrayList<String>(java.util.Arrays.asList(data.getRowNames()));
  menu.addIntSlider("Country", "Temp", 0, countryIndex.size()-1, 0);
  menu.addFloatSlider("ScaleMax", 0.01, dataMax, dataMax, 3);
  menu.addFloatSlider("Stroke Weight", 0.05, 20, 1, 2);
  menu.addFloatSlider("Z Pop Distance", 0, 6, 0, 2);
  
  // Corners of the plotted time series
  plotX1 = 50;
  plotX2 = width - plotX1;
  plotY1 = 60;
  plotY2 = height - plotY1;
  smooth();
  cam = new PeasyCam(this, 700);
  cam.setMinimumDistance(20);
  cam.setMaximumDistance(10000);
}

void draw() {
  background(0);
  java.util.TreeMap <String, Controller> tempControllers = new java.util.TreeMap <String, Controller> (menu.getControllers());

  if ((boolean)tempControllers.get("RESET CONTROLS").getValue()) { 
    menu.resetMenu();
  }

  //if ((boolean)tempControllers.get("RESET ZOOM").getValue()) {
  //  zoom = 100;
  //  zoomTransX = 0;
  //  zoomTransY = 0;
  //  panXY.x = 0;
  //  panXY.y = 0;
  //}
  boolean drawOne = (boolean)tempControllers.get("Toggle All/One").getValue();
  IntSlider tempIntSCountry = (IntSlider)tempControllers.get("Country");
  tempIntSCountry.setValue((int)tempIntSCountry.getValue()+countryInc);
  countryInc = 0;
  int onePicked = (int)tempIntSCountry.getValue();
  countryName = data.getRowNames()[onePicked];
  tempIntSCountry.setSliderName(countryName);
  dataMax = (float)tempControllers.get("ScaleMax").getValue();
  zScale = (float)tempControllers.get("Z Pop Distance").getValue();

  //frameRate((int)tempControllers.get("FrameRate").getValue());
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
  translate(-width/2.0, -height/2.0);
  //if the mouse is over the menu disable peasycam
  if(mouseX+10 > width-menu.getMenuWidth() && mouseY < menu.getMenuHeight()){
    cam.setActive(false);
  }else{
    cam.setActive(true);
  }
  background(22);
  // Show the plot area as a white box.
  fill(0, 0);
  rectMode(CORNERS);
  stroke(30);
  
  strokeWeight(1);
  //rect(plotX1, plotY1, plotX2, plotY2);
  
  strokeWeight((float)tempControllers.get("Stroke Weight").getValue());

  // Draw the data for the first column.
  stroke(color(220, 255, 220));
    fill(255);
  textSize(12);
  if (drawOne) {
    //draw one data point
    drawDataP(onePicked);
  } else {
    //draw all the data points
    for (int colNums = 0; colNums< data.rowCount; colNums++) {
      drawDataP(colNums);
      //println(colNums);
    }
  }
  fill(255);
  textSize(11);
  drawYearLabels();
  drawScaleLabels();
  textSize(18);
  //drawing one country or all the countries
  if(drawOne) text(countryName + " CO2 Emissions / GDP (Metric Tons per Capita)", plotX1 + 20, plotY1 - 20);
  else text("All the Countries" + " CO2 Emissions / GDP (Metric Tons per Capita)", plotX1 + 20, plotY1 - 20);
  
  //draw the title text
  textAlign(CENTER, CENTER);
  text("Year", (plotX1+plotX2)/2.0, plotY2 + 50);
  pushMatrix();
  translate(plotX1 - 50 , (plotY1+plotY2)/2.0);
  rotate(radians(90));
  text("Metric Tons CO2 per Capita", 0, 0);
  popMatrix();

  rectMode(CORNER);
  /*******************************************
   *               END CONTENT               *
   *******************************************/
  popMatrix();
  textAlign(LEFT, BASELINE);
  cam.beginHUD();
  menu.drawMenu();

  /*******************************************
   *            END DRAW CONTENTS            *
   *******************************************/

  drawFPSCounter(); //CORNER TEXTS
 // drawZoomCounter();
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

// Draw the data as a series of points.
void drawDataP(int rowNum) {
  int colCount = data.getColumnCount();
  Point prevPoint = null;
  float z = (rowNum-data.getRowCount()/2)*zScale;
  for (int col = 0; col < colCount; col++) {
    if (data.isValid(rowNum, col)) {
      float value = data.getFloat(rowNum, col);
      float x = map(years[col], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      
      if (prevPoint != null) line(prevPoint.x, prevPoint.y, z, x, y, z);
      prevPoint = new Point(x, y);
      point(x, y, z);
    }
  }
  text(data.getRowNames()[rowNum], plotX1-150, plotY2, z);
}
// Draw the year labels
void drawYearLabels() {
  textAlign(CENTER, TOP);
  int colCount = data.getColumnCount();
  int yearInterval = 2;
  for (int row = 0; row < colCount; row++) {
    if (years[row] % yearInterval == 0) {       
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);       
      text(years[row], x, plotY2 + 10);
    }
  }
  textAlign(LEFT);
}
//Draw the scale labels
void drawScaleLabels() {
  textAlign(CENTER, RIGHT);
  float number = 10;
  float scaleInterval = dataMax/number;
  for (float point = 0; point <= number; point++) {
    float value = round(point*scaleInterval*1000.0)/1000.0;
    float y = map(value, dataMax, 0, plotY1, plotY2);       
      text(value, plotX1 - 20, y);
  }
  textAlign(LEFT);
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
void keyPressed(){
  if(key == 'A' || key == 'a'){
    countryInc--;
  }
  else if(key == 'D' || key == 'd'){
    countryInc++;
  }
}