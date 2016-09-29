/**
 * @title TangramHorse
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Feb 2, 2016
 * @author Tiger Mou
 * Description: This program draws three tangram horses. The pieces of the horse are dark and will randomly
 * flash with a lighter grey. When the pieces of the tangram horse are moused over,
 * they start shaking and mini tangram horses will spawn at the mouse location. These mini tangram horses will spin
 * in a random direction and initially move in a random direction and speed.Mousing over these mini tangram horses
 * will create even smaller tangram horses. The pieces of the mini tangram horses will change colors upon mouseover.
 * The horses will bounce off of the left and right sides of the screen. "Gravity" will pull the horses downward
 * until they fall off the screen. Once they fall off, they are removed from the program to clear up memory. 
 * If the tangram horse was moving downwards during mouseover, it will "bounce" off and move upwards. The moving mini tangram horses 
 * will leave streaks on the background. This is accomplished with a translucent rectangle drawn in the background every two
 * draw cycles instead of coloring the background a solid color. The top left of the screen will display the current
 * number of frames per second and the total number of active mini tangram horses.
 * 
 * "DIAGNOSTICS"
 * I can guarantee that the shapes are the correct sizes and are in the correct locations because of the way each shape was made.
 * Each shape is made with a corner at the origin and is sized with unit lengths and square roots of 2.
 * The shape is translated using a matrix by moving the point at the origin and rotating the shape about that origin to wherever
 * the shape needs to be. The location of the shape was determined by using relative distances and positionings from an "origin" point.
 * This origin point was the top right angle corner of the horse. The x coordinte of the shape below and touch it was determined by aligning
 * the X coordinates and by increasing the Y coordinate by the height of the triangle, which was calculated based on the unit length of the tangrams. 
 */
 
int frameCount = 0;  //counts the number of frames since the last time horses were spawned
ArrayList <TangHorse> horses = new ArrayList<TangHorse>();  //arraylist of the mini horse spawn objects
PFont font;    //global font variable for the fps and horse counters

void setup() {
  //size(550, 550);
  fullScreen();  //fullscreen!
  noCursor();    //hides mouse cursor
  smooth(4);      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  font = createFont("Arial", 48);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect
}
void draw() {
  //CORNER TEXT
  fill(0);            //black rectangle in corner
  rect(0, 0, 45, 60);  //rectangle location
  fill(255);        //white text
  textFont(font, 22);  //font size 22
  text(int(frameRate), 5, 20);  //display framerate in the top
  text(horses.size(), 5, 50);    //display the number of live horses below that
  //BACKGROUND
  if (frameCount % 2 == 0) {              //redraw the "background" every two frames
   fill(255, 10);                        // a white translucent rectangle is the background
   rect(0, 0, width, height);
  }
  //SIZING VARIABLES
  int unit = 100;          //unit size for triangles
  int scale = 1;          //scale the horses! (DOES NOT WORK AS INTENDED)
  //MOVEMENT VARIABLES
  float gravity = 0.03;    //what is gravity

  float wind = 0;          //sideways "wind"
  float initMoveSize = 10;  //initial spawn move speed limit
  int shakeWeight = int(unit/4.0);      //how hard to shake the tangrams
  //COLOR of the MAIN tangram horse
  int mainHorseR = 0;
  int mainHorseG = 0;
  int mainHorseB = 0;
  int mainHorseA = 1;
  boolean mainFlashA = true; //flash the tiles alpha color
  //three MAIN tangram horses!
  boolean isHovered = drawTangramHorse((unit*2.5), (unit * 2.0/3.0), shakeWeight, unit, scale, false, 0, mainFlashA, mainHorseR, mainHorseG, mainHorseB, mainHorseA);
  isHovered = drawTangramHorse((unit*2.5)+unit*4, (unit * 2.0/3.0), shakeWeight, unit, scale, false, 0, mainFlashA, mainHorseR, mainHorseG, mainHorseB, mainHorseA) || isHovered;
  isHovered = drawTangramHorse((unit*2.5)+unit*8, (unit * 2.0/3.0), shakeWeight, unit, scale, false, 0, mainFlashA, mainHorseR, mainHorseG, mainHorseB, mainHorseA) || isHovered;

  //HORSE SPAWNS
  int firstSpawnSize = 2;  //size of spawns
  float rotationDiff = 4;    //rotation speed in degrees per frame of spawns
  if (int(random(2))==1) rotationDiff = -rotationDiff;  //make rotation speed either direction
  int spawnShakeWeight = 5;    //how hard to shake the spawns
  //COLOR OF HORSE SPAWNS
  int spawnHorseR = int(random(255));//30;
  int spawnHorseG = int(random(255));//30;
  int spawnHorseB = int(random(255));//30;
  int spawnHorseA = 30;
  boolean spawnFlashAOn = false; //flash the spawn alpha color

  //IF HOVERED AND EVERY THIRD FRAME COUNT
  if (isHovered && frameCount % 2 == 0) {
    //create a new spawn horse at the mouse locatoin
    TangHorse temp = new TangHorse(mouseX, mouseY, spawnShakeWeight, firstSpawnSize, scale, random(initMoveSize)-(initMoveSize/2.0), random(initMoveSize)-(initMoveSize/2.0), true, rotationDiff, spawnFlashAOn, spawnHorseR, spawnHorseG, spawnHorseB, spawnHorseA);
    horses.add(temp);  //add the horse to the arraylist of horses
  }
  //DRAW EACH HORSE IN THE ARRAYLIST
  for (int index = 0; index < horses.size(); index++) {
    TangHorse horse = horses.get(index);
    //if the horse is hovered over, is bigger that 1 unit large, and on every THIRD frame
    if (horse.isHovered() && horse.getUnitSize() >= 1 && frameCount % 3 == 0) {
      //if the horse is moving downwards, reverse the y direction
      if (horse.getYDiff() > 0) horse.reverseYDiff(); 
      //create a new horse at the mouse location
      TangHorse temp = new TangHorse(mouseX, mouseY, spawnShakeWeight, int(horse.getUnitSize()/1.5), scale, random(initMoveSize)-(initMoveSize/2.0), random(initMoveSize)-(initMoveSize/2.0), true, rotationDiff, spawnFlashAOn, spawnHorseR, spawnHorseG, spawnHorseB, spawnHorseA);
      horses.add(temp);  //add the horse to the arraylist
    }
    if (horse.getX() <=0 || horse.getX() >= width) horse.reverseXDiff();
    horse.updateDiff(wind, gravity); //update this horse's speed with a delta for gravity and wind
    horse.drawThisTangram();  //draw the horse on the screen
    //if the horse is off the screen, remove it from the arraylist. Java's garbage collection should take care of it
    if (horse.isOffScreen()) horses.remove(index);
  }
  frameCount++;  //iterate framecount each draw
  if (frameCount >= 101) frameCount = 0;    //to prevent frameCount from overflowing
  color mouseColor = get(mouseX, mouseY);    //get the color under the mouse cursor
  stroke(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));  //"reverse" the color
  strokeWeight(8);    //big strokes!
  line(pmouseX, pmouseY, mouseX, mouseY);    //create a line from the previous mouse location to the current
  noStroke();    //reset to no strokes for shapes!
}

/*
 *This is an abstract class for creating and managing the (mini) tangram shapes
 */
public abstract class TangShape { 
  protected float x;    //x location
  protected float y;    //y location
  protected int unit;    //unit size of the tangram
  protected int shakeWeight;  //how hard to shake the tangram upon hover
  protected float scale;      //how big to scale the tangram
  protected boolean alwaysShake = false;  //does the tangram always shake? (default false)
  protected float xDiff = 0;    //how fast is this tangram moving pre frame?
  protected float yDiff = 0;    //how fast is this tangram moving pre frame?
  protected boolean isHovered = false;  //is this tangram being hovered on?
  protected float rotation = 0;      //current tangram rotation in degrees
  protected float rotationDiff = 0;  //current rotation speed
  //horse color
  protected int r = 0;
  protected int g = 0;
  protected int b = 0;
  protected int a = 0;
  protected boolean flashAOn = false;  //flash the tangram alpha color?

  public abstract void drawThisTangram();
  /**
   * Updates tangram movement
   * @param addXDiff The amount of x difference you want to increment by this frame
   * @param addXDiff The amount of y difference you want to increment by this frame
   */
  public void updateDiff(float addXDiff, float addYDiff) {
    xDiff += addXDiff;
    x += xDiff;
    yDiff += addYDiff;
    y += yDiff;
  }

  /**
   * Checks if this mini tangram off the screen? (with extra margins just in case)
   * @return If this tangram is off the screen
   */
  public boolean isOffScreen() {
    if (x <= -width*0.1 || x >= width * 1.1) {
      return true;
    }
    if (y > (height * 1.1) || y < -height * 0.1 ) {
      return true;
    } else return false;
  }
  /**
   * Is this tangram currently being hovered on?
   * @return Currently hovered or not
   */
  public boolean isHovered() {
    return isHovered;
  }
  /**
   * Gets the unit size of this tangram shape
   * @return The unit size of this tangram shape
   */
  public int getUnitSize() {
    return unit;
  }
  /**
   * Reverses the X direction of movement speed of this tangram shape
   */
  public void reverseXDiff() {
    xDiff = -xDiff;
  }
  /**
   * Reverses the Y direction of movement speed of this tangram shape
   */
  public void reverseYDiff() {
    yDiff = -yDiff;
  }
  /**
   * Get the current X movement speed of this tangram shape 
   */
  public float getXDiff() {
    return xDiff;
  }
  /**
   * Get the current Y movement speed of this tangram shape 
   */
  public float getYDiff() {
    return yDiff;
  }
  /**
   * Get the current X position of this tangram shape 
   */
  public float getX() {
    return x;
  }
  /**
   * Get the current Y position of this tangram shape 
   */
  public float getY() {
    return y;
  }
}
/**
 * Class implementation of the abstract class TangShape
 * This class (currently) uses the function drawTangramHorse() to actually draw the horse
 */
public class TangHorse extends TangShape {
  /**
   * Public constructor for a Tangram Horse (TangHorse)
   * @param x The X location of the top of the tangram
   * @param x The Y location of the top of the tangram
   * @param aShakeWeight How hard to shake this tangram
   * @param unit The unit size for this tangram
   * @param scale The scale size for this tangram
   * @param xDiff The initial X "velocity" of this tangram
   * @param yDiff The initial Y "velocity" of this tangram
   * @param alwaysShake Should this tangram always shake?
   * @param rotationDiff Rotation velocity in degrees of this tangram. ROTATES AROUND THE ROUGH CENTER OF THE TANGRAM
   * @param flashAOn Flash the alpha color of the tangram?
   * @param red Red color value for this tangram
   * @param blue Blue color value for this tangram
   * @param green Green color value for this tangram
   * @param alpha Alpha transparency value for this tangram
   */
  public TangHorse(float x, float y, int aShakeWeight, int unit, float scale, float xDiff, float yDiff, boolean alwaysShake, float rotationDiff, boolean flashAOn, int red, int green, int blue, int alpha) {
    this.x = x;
    this.y = y;
    this.alwaysShake = alwaysShake;
    this.rotationDiff = rotationDiff;
    this.shakeWeight = aShakeWeight;
    this.unit = unit;
    this.scale = scale;
    this.r = red;
    this.g = green;
    this.b = blue;
    this.a = alpha;
    this.flashAOn = flashAOn;
    this.xDiff = xDiff;
    this.yDiff = yDiff;
  }
  /**
   * Draws this tangram
   */
  public void drawThisTangram() {
    rotation += rotationDiff;
    isHovered = drawTangramHorse(x, y, shakeWeight, unit, scale, alwaysShake, rotation, flashAOn, r, g, b, a);
  }
}
/**
 * The function to draw a tangram horse
 * @return Whether or not this tangram horse is currently being moused over
 * @param x The X location of the top of the tangram
 * @param x The Y location of the top of the tangram
 * @param aShakeWeight How hard to shake this tangram
 * @param unit The unit size for this tangram
 * @param scale The scale size for this tangram
 * @param xDiff The initial X "velocity" of this tangram
 * @param yDiff The initial Y "velocity" of this tangram
 * @param alwaysShake Should this tangram always shake?
 * @param rotationDiff Rotation velocity in degrees of this tangram. ROTATES AROUND THE ROUGH CENTER OF THE TANGRAM
 * @param flashAOn Flash the alpha color of the tangram?
 * @param red Red color value for this tangram
 * @param blue Blue color value for this tangram
 * @param green Green color value for this tangram
 * @param alpha Alpha transparency value for this tangram
 * 
 */
public boolean drawTangramHorse(float x, float y, int shakeWeight, int unit, float scale, boolean shakeAlwaysOn, float rotation, boolean flashAOn, int r, int g, int b, int a) {
  boolean isHovered = false;    //initially set tangram hover to false
  Dimensions dim = new Dimensions(unit);  //create a dimensions instance to get tangram shape dimensions
  pushMatrix();    //matrix for scaling the horse
  noStroke();      //no borders
  scale(scale);    //scale the horse
  float origX = x;  //X position for the top of the horse
  float origY = y;  //Y position for the top of the horse
  pushMatrix();    //new matrix for rotating the horse about the approximate center of the horse
  if (rotation != 0) {    //do this crazy math if the rotation is something other than 0
    translate(x, (y + ((unit * 2.5) + (unit/6.0))));    //move the origin to the center of the horse
    rotate(radians(rotation));                          //rotate the grid about the origin
    translate(-x, -(y + ((unit * 2.5) + (unit/6.0))));  //move the grid back
  }
  TriM triM1 = new TriM(origX, origY, 45, unit);    //Draw the shape of the horse at the origin location origX, origY, with rotation and unit size

  //Draw the ________ tangram shape of the horse at this location, which is relative to the horse origin origX and origY, with rotation and unit size
  Square square = new Square(origX, origY + dim.medTriHeight(), 0, unit); 
  TriS triS1 = new TriS(origX - (dim.larTriLeg()/2.0), origY + dim.medTriHeight() + dim.squareHeight(), 45, unit);
  TriL triL1 = new TriL(origX + (dim.larTriLeg()/2.0), origY + dim.medTriHeight() + dim.squareWidth(), 90, unit);
  TriL triL2 = new TriL(origX + dim.squareWidth() + dim.larTriHeight(), origY + dim.medTriHeight() + dim.squareHeight() + (dim.larTriHyp()/2.0), 135, unit);
  TriS triS2 = new TriS(origX + dim.squareWidth(), origY + dim.medTriHeight() + dim.squareHeight() + dim.larTriLeg() + (unit/3) + dim.smaTriLeg(), 180, unit);
  Parallelogram parallelogram = new Parallelogram(origX + dim.squareWidth() + dim.larTriHeight(), origY + dim.medTriHeight() + dim.squareHeight() + (dim.larTriHyp()/2.0), 70, unit);

  //If this tangram is supposed to always be shaking
  if (shakeAlwaysOn) {
    triM1.setShake(shakeWeight);
    triS1.setShake(shakeWeight);
    triL1.setShake(shakeWeight);
    triS2.setShake(shakeWeight);
    triL2.setShake(shakeWeight);
    square.setShake(shakeWeight);
    parallelogram.setShake(shakeWeight);
  }

  //if one piece is being hovered, then the mouse is over the overall formation.
  isHovered = triM1.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triM1.drawShape();  //draw this tangram piece
  isHovered = square.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  square.drawShape();
  isHovered = triS1.doHoverShake(shakeWeight, flashAOn, r, g, b, a)  || isHovered;
  triS1.drawShape();
  isHovered = triL1.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triL1.drawShape();
  isHovered = triL2.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triL2.drawShape();
  isHovered = triS2.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triS2.drawShape();
  isHovered = parallelogram.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  parallelogram.drawShape();
  popMatrix();  //remove matrix
  popMatrix(); //remove matrix
  return isHovered;  //if this overall formation is currently moused over
}

/**
 * A dimensions class that gives most of the dimensions for each tangram shape
 */
public class Dimensions {
  private int unit;
  /**
   * Constructor for a Dimensions object
   * @param unit The unit size of this tangram
   */
  Dimensions(int unit) {
    this.unit = unit;
  }
  /**
   * Small Triangle Height
   * @return The distance from the hypotenuse to the opposite corner
   */
  public float smaTriHeight() { 
    return unit * sqrt(2.0) / 2.0;
  }
  /**
   * Small Triangle Width
   * @return The length of the hypotenuse
   */
  public float smaTriWidth() { 
    return unit * sqrt(2.0);
  }
  /**
   * Small Triangle Leg Length
   * @return The length of the leg
   */
  public float smaTriLeg() {
    return unit;
  }
  /**
   * Small Triangle Hypotenuse
   * @return The length of the hypotenuse
   */
  public float smaTriHyp() { 
    return unit * sqrt(2.0);
  }
    /**
   * Medium Triangle Height
   * @return The distance from the hypotenuse to the opposite corner
   */
  public float medTriHeight() { 
    return unit;
  }
  /**
   * Medium Triangle Width
   * @return The length of the hypotenuse
   */
  public float medTriWidth() { 
    return unit * 2.0;
  }
    /**
   * Medium Triangle Leg Length
   * @return The length of the leg
   */
  public float medTriLeg() { 
    return unit * sqrt(2.0);
  }
    /**
   * Medium Triangle Hypotenuse
   * @return The length of the hypotenuse
   */
  public float medTriHyp() { 
    return unit * sqrt(2.0) * sqrt(2.0);
  }
      /**
   * Large Triangle Height
   * @return The distance from the hypotenuse to the opposite corner
   */
  public float larTriHeight() { 
    return unit * sqrt(2.0);
  }
    /**
   * Large Triangle Width
   * @return The length of the hypotenuse
   */
  public float larTriWidth() { 
    return unit * sqrt(2.0) * 2.0;
  }
      /**
   * Large Triangle Leg Length
   * @return The length of the leg
   */
  public float larTriLeg() { 
    return unit * 2.0;
  }
      /**
   * Large Triangle Hypotenuse
   * @return The length of the hypotenuse
   */
  public float larTriHyp() { 
    return unit * sqrt(2.0) * 2.0;
  }
        /**
   * Square Height (side length)
   * @return The height (side length) of the square
   */
  public float squareHeight() { 
    return unit;
  }
          /**
   * Square Width (side length)
   * @return The width (side length) of the square
   */
  public float squareWidth() { 
    return unit;
  }
            /**
   * Square Diagonal
   * @return The diagonal length of the square
   */
  public float squareDiagonal() { 
    return unit * sqrt(2);
  }
            /**
   * Parallelogram Height
   * @return The height of the parallelogram (shortest length)
   */
  public float paraHeight() { 
    return unit / sqrt(2.0);
  }
            /**
   * Parallelogram Width
   * @return The width of the parallelogram (longest "straight" width)
   */
  public float paraWidth() { 
    return (unit*sqrt(2.0))+(unit/sqrt(2.0));
  }
}
/**
 * Public class for an x y point
 */
public class Point {
  public float x, y;
}
/**
 * Public abstract class of a tangram shape or piece
 */
public abstract class Shape {
  protected java.awt.Polygon p = new java.awt.Polygon();  //polygon to make a shape
  protected int shake = 0;          //shake weight (default 0)
  protected float rotation = 0;      //rotation of the shape (default 0)
  protected Point topP = new Point();  //the "top" point location of this shape

/**
 * Method to draw this shape using the points in the polygon
 */
  public void drawShape() {
    pushMatrix();  //translate and rotation matrix
    translate(topP.x + (random(shake) - shake/2.0), topP.y + (random(shake) - shake/2.0));  //translate the matrix by x and y and the shake weight
    rotate(radians(rotation)); //rotate the matrix to the desired shape rotation (rotates about the "top")
    beginShape();    //start drawing the shape
    for (int i = 0; i < p.npoints; i++) {
      vertex(p.xpoints[i], p.ypoints[i]);
    }
    endShape();
    popMatrix();
  }
  /**
   * Method to set the shake value of this shape
   * @param shakeValue How hard to shake this shape
   */
  public void setShake(int shakeValue) {
    shake = shakeValue;
  }
  /**
   * Returns the "top" point value location
   * @return The top point location
   */
  public Point getTopP() {
    return topP;
  }
  /**
   * Method to do hovering AND shaking of the shape, flashing the alpha, and set to fill color 
   * @return The top point location
   * @param shakeWeight How hard to shake this shape
   * @param flashAOn To flash the alpha value (Will fill using alpha if false)
   * @param r The red color value of the shape
   * @param g The green color value of the shape
   * @param b The blue color value of the shape
   * @param a The alpha transparency value of the shape
   */
  public boolean doHoverShake(int shakeWeight, boolean flashAOn, int r, int g, int b, int a) {
    if (this.ifContains(mouseX, mouseY)) {    //if this shape contais the mouse location
      fill(random(1) * 255, random(1) * 255, random(1) * 255);   //draw the shape with a random color
      this.setShake(shakeWeight);      //set the shake of the shape
      return true;      //This shape is being hovered
    } else {      //if it is not hovered, flash the alpha color if on
      if (flashAOn) {
        if (int(random(2)) == 1) {  //random on and off
          fill(r, g, b, a);      //fill with alpha
        } else fill(r, g, b);    //fill without alpha
      } else fill(r, g, b, a);    //fill with alpha by default
      return false;      //Shape is not being hovered
    }
  }
  /**
   * Checks if this shape is currently being hovered by an X coordinate and Y coordinate
   * @return Whether or not this shape contains this point
   * @param x The X coordinate
   * @param y The Y coordinate
   */
  public boolean ifContains(float x, float y) {
    float newX = x - topP.x;    //untranslate the point
    float newY = y - topP.y;    //untranslate the point
    //Unrotate the point using MATH!
    return p.contains((newX*cos(radians(-1.0 * rotation)) - newY * sin(radians(-1.0 *rotation))), (newX * sin(radians(-1.0 * rotation)) + newY * cos(radians(-1.0 * rotation))));
  }
}
/**
 * Small Triangle Object extends Shape
 */
public class TriS extends Shape {
  /**
   * Constructor for Small Triangle Object
   * @param x The X location of the right angle corner of the triangle
   * @param y The Y location of the right angle corner of the triangle
   * @param rotation The rotation in degrees of the triangle around the right angle corner
   * @param unit The unit size of the triangle
   */
  public TriS (float x, float y, float rotation, int unit) {
    topP.x = x;
    topP.y = y;
    this.rotation = rotation;
    p.addPoint(0, 0);
    p.addPoint(0, unit);
    p.addPoint(unit, 0);
    p.addPoint(0, 0);
  }
}  
  /**
   * Constructor for Medium Triangle Object
   * @param x The X location of the right angle corner of the triangle
   * @param y The Y location of the right angle corner of the triangle
   * @param rotation The rotation in degrees of the triangle around the right angle corner
   * @param unit The unit size of the triangle
   */
public class TriM extends Shape {
  public TriM (float x, float y, float rotation, int unit) {
    topP.x = x;
    topP.y = y;
    this.rotation = rotation;
    p.addPoint(0, 0);
    p.addPoint(0, int(unit*sqrt(2)));
    p.addPoint(int(unit*sqrt(2)), 0);
    p.addPoint(0, 0);
  }
}
  /**
   * Constructor for Large Triangle Object
   * @param x The X location of the right angle corner of the triangle
   * @param y The Y location of the right angle corner of the triangle
   * @param rotation The rotation in degrees of the triangle around the right angle corner
   * @param unit The unit size of the triangle
   */
public class TriL extends Shape {
  public TriL (float x, float y, float rotation, int unit) {
    topP.x = x;
    topP.y = y;
    this.rotation = rotation;
    p.addPoint(0, 0);
    p.addPoint(0, unit * 2);
    p.addPoint(unit * 2, 0);
    p.addPoint(0, 0);
  }
}
  /**
   * Constructor for Square Object
   * @param x The X location of the right angle corner of the triangle
   * @param y The Y location of the right angle corner of the triangle
   * @param rotation The rotation in degrees of the square around the top left corner
   * @param unit The unit size of the square
   */
public class Square extends Shape {
  public Square (float x, float y, float rotation, int unit) {
    topP.x = x;
    topP.y = y;
    this.rotation = rotation;
    p.addPoint(0, 0);
    p.addPoint(unit, 0);
    p.addPoint(unit, unit);
    p.addPoint(0, unit);
    p.addPoint(0, 0);
  }
}
  /**
   * Constructor for Parallelogram
   * @param x The X location of the top left pointy corner of the parallelogram
   * @param y The Y location of the top left pointy corner of the parallelogram
   * @param rotation The rotation in degrees of the parallelogram around the top left pointy corner
   * @param unit The unit size of the parallelogram
   */
public class Parallelogram extends Shape {
  public Parallelogram (float x, float y, float rotation, int unit) {
    topP.x = x;
    topP.y = y;
    this.rotation = rotation;
    p.addPoint(0, 0);
    p.addPoint(int(unit*sqrt(2)), 0);
    p.addPoint(int((unit*sqrt(2))+(unit/sqrt(2))), int(unit/sqrt(2)));
    p.addPoint(int(unit/sqrt(2)), int(unit/sqrt(2)));
    p.addPoint(0, 0);
  }
}