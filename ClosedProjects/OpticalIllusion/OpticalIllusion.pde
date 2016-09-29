/**
 * @title PaperFolding5
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Mar 22, 2016
 * @author Tiger Mou
 * Description: Makes a stereogram
 * Features: Zooming (scrolling), Panning (click and drag), click detection (console and bigger "brush")
 */

PGraphics pg;
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

float circleRadius = 100;
float dRadius = 5;

float rot1 = 0, rot2 = 0, rot3 = 0;
PImage doge;
void setup() {
  //size(900, 600);  //windowsize
  fullScreen();  //fullscreen!
  noCursor();    //hides mouse cursor
  smooth();      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect
  tessalation1 = new Tessalation(0, 0, 100, 100, 2, 2, 150);
  pg = createGraphics(800, 600);
  doge = loadImage("cube.jpg");
  doge.resize(750, 555);

  menu = new ControllersMenu(Position.TOP_RIGHT, 300);
  //SLIDER MENU
  menu.addIntSlider("FrameRate", 5, 60, 60);              //IN USE
  menu.addButtonController("REGEN STEREOGRAM", "REGEN STEREOGRAM");    //IN USE

  menu.addButtonController("RESET CONTROLS", "RESET CONTROLS");    //IN USE
  menu.addButtonController("RESET ZOOM", "RESET ZOOM");    //IN USE
  pg.beginDraw();
 // pg.image(doge, 0, 0);
  //pg.background(255);
  //pg.noStroke();
  //pg.fill(0);
  //pg.ellipse(pg.width/2.0, pg.height/2.0, 400, 400);
  //pg.fill(100);
  //pg.ellipse(pg.width/2.0, pg.height/2.0, 350, 350);
  //pg.fill(150);
  //pg.ellipse(pg.width/2.0, pg.height/2.0, 300, 300);
  //pg.fill(200);
  //pg.ellipse(pg.width/2.0, pg.height/2.0, 200, 200);
  pg.fill(255);
  pg.ellipse(pg.width/2.0, pg.height/2.0, circleRadius, circleRadius);
 drawAutoStereogram();
  //pg.loadPixels();
  //for (int index = 0; index < pg.pixels.length; index++) {
  // pg.pixels[index] = color(getLum(pg.pixels[index]));
  //}
  //pg.updatePixels();
  pg.endDraw();
}

void draw() {
  background(0);
  java.util.TreeMap <String, Controller> tempControllers = new java.util.TreeMap <String, Controller> (menu.getControllers());

  if ((boolean)tempControllers.get("RESET CONTROLS").getValue()) { 
    menu.resetMenu();
    worldRotation = 0;
  }

 // if ((boolean)tempControllers.get("REGEN STEREOGRAM").getValue()) { 
    pg.beginDraw();
    //pg.image(doge, 0, 0);
    /*
    pg.background(255);
    pg.noStroke();
    pg.fill(0);
    pg.fill(0);
    pg.ellipse(pg.width/2.0, pg.height/2.0, 400, 400);
    pg.fill(100);
    pg.ellipse(pg.width/2.0, pg.height/2.0, 350, 350);
    pg.fill(150);
    pg.ellipse(pg.width/2.0, pg.height/2.0, 300, 300);
    pg.fill(200);
    pg.ellipse(pg.width/2.0, pg.height/2.0, 200, 200);
    pg.fill(255);
    pg.ellipse(pg.width/2.0, pg.height/2.0, 100, 100);
    */
    pg.fill(255);
    //pg.ellipse(pg.width/2.0, pg.height/2.0, circleRadius, circleRadius);
    circleRadius+=dRadius;
    if(circleRadius > pg.height || circleRadius < 0) dRadius *= -1;
    
    //drawAutoStereogram();
    pg.endDraw();
//  }

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


  image(pg, -pg.width/2.0, -pg.height/2.0);


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
float getLum(color aColor) {
  return (0.2126*red(aColor) + 0.7152*green(aColor) + 0.0722*blue(aColor));
}
int separation(float anInt) {
  float mu = (1.0/3.0);
  float DPI = 120;
  float E = round(2.5*DPI);
  return round((1.0-mu*anInt)*E/(2.0-mu*anInt));
}
void drawAutoStereogram() {
  pg.loadPixels();

  int maxY = pg.height;
  int maxX = pg.width;
  float mu = (1.0/3.0);
  float DPI = 120;
  float E = round(2.5*DPI);

  int x, y;
  for (y = 0; y < maxY; y++) {
    float[] pix = new float[maxX];
    int[] same = new int[maxX];

    int s;
    int left, right;

    for (x = 0; x < maxX; x++)
      same[x] = x;

    for (x = 0; x < maxX; x++) {
      s = separation(getLum(pg.pixels[x + y*maxX])/255.0);
      left = x - s/2;
      right = left + s;

      if (0 <= left && right < maxX) {
        boolean visible;
        int t = 1;
        float zt;

        do {
          zt = (getLum(pg.pixels[x-t + y*maxX])/255.0) + 2 * (2 - mu * getLum(pg.pixels[x-t + y*maxX])/255.0) * t/(mu*E);
          visible = (getLum(pg.pixels[x-t + y*maxX])/255.0)<zt && (getLum(pg.pixels[x-t + y*maxX])/255.0)<zt;
          t++;
        } while (visible && zt < 1);

        if (visible) {
          int l = same[left];
          while (l != left && l != right)
            if (l < right) {
              left = l;
              l = same[left];
            } else {
              same[left] = right;
              left = right;
              l = same[left];
              right = l;
            }
          same[left] = right;
        }
      }
    }
    for (x = maxX-1; x >= 0; x--) {
      if (same[x] == x) pix[x] = round(random(1));
      else pix[x] = pix[same[x]];
      pg.pixels[x+ y*maxX] = (color(pix[x]*255.0));
    }
  }
  pg.updatePixels();
  pg.fill(0);
  float ellipseSize = 20;
  pg.ellipse(pg.width/2.0+pg.width*0.1, pg.height*0.95, ellipseSize, ellipseSize);
  pg.ellipse(pg.width/2.0-pg.width*0.1, pg.height*0.95, ellipseSize, ellipseSize);
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