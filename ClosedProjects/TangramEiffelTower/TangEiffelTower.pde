/**
 * Class implementation of the abstract class TangShape
 * This class (currently) uses the function drawTangramEiffelTower() to actually draw the tangram
 */
public class TangEiffelTower extends TangShape {
  /**
   * Public constructor for a Tangram G (TangLetterG)
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
  public TangEiffelTower(float x, float y, int aShakeWeight, int unit, float scale, float xDiff, float yDiff, boolean alwaysShake, float rotationDiff, boolean flashAOn, int red, int green, int blue, int alpha) {
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
    isHovered = drawTangramEiffelTower(x, y, shakeWeight, unit, scale, alwaysShake, rotation, flashAOn, r, g, b, a);
  }
}
/**
 * The function to draw a tangram letter S
 * @return Whether or not this tangram letter S is currently being moused over
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
public boolean drawTangramEiffelTower(float x, float y, int shakeWeight, int unit, float scale, boolean shakeAlwaysOn, float rotation, boolean flashAOn, int r, int g, int b, int a) {
  boolean isHovered = false;    //initially set tangram hover to false
  Dimensions dim = new Dimensions(unit);  //create a dimensions instance to get tangram shape dimensions
  pushMatrix();    //matrix for scaling the tangram
  noStroke();      //no borders
  scale(scale);    //scale the tangram
  float origX = x;  //X position for the top of the tangram
  float origY = y;  //Y position for the top of the tangram
  pushMatrix();    //new matrix for rotating the tangram about the approximate center of the tangram
  if (rotation != 0) {    //do this crazy math if the rotation is something other than 0
    translate(x, (y + (unit *( 6.0 * sqrt(2) + 3))));    //move the origin to the center of the tangram
    rotate(radians(rotation));                          //rotate the grid about the origin
    translate(-(x), -(y + (unit *( 6.0 * sqrt(2) + 3))));  //move the grid back
  }
ArrayList <Shape> theShapes = new ArrayList <Shape>();
  ////Draw the ________ tangram shape of the tangram at this location, which is relative to the tangram origin origX and origY, with rotation and unit size
  //Draw the shape of the tangram at the origin location origX, origY, with rotation and unit size
  TriS triS1 = new TriS(origX, origY, 45, unit);
  theShapes.add(triS1);
  Square square1 = new Square(origX - (dim.squareWidth()/2.0), origY + dim.smaTriHeight(), 0, unit);
  theShapes.add(square1);
Square square2 = new Square(origX - (dim.squareWidth()/2.0), origY + dim.smaTriHeight() + dim.squareHeight(), 0, unit);
theShapes.add(square2);
Parallelogram parallelogram1 = new Parallelogram(origX - (dim.medTriLeg()/2.0) - (dim.smaTriWidth()/2.0), origY + dim.smaTriHeight() + (2.0 * dim.squareHeight()), 0, unit);
theShapes.add(parallelogram1);
TriS triS2 = new TriS(origX + dim.medTriLeg() / 2.0, origY + (2.0*dim.smaTriHeight()) + (2.0 * dim.squareHeight()), -135, unit);
theShapes.add(triS2);
float offset1X = origX + dim.medTriLeg() / 2.0;
float offset1Y = origY + (2.0*dim.smaTriHeight()) + (2.0 * dim.squareHeight());

  TriM triM1 = new TriM(offset1X, offset1Y, 90, unit);
  theShapes.add(triM1);
  TriL triL1 = new TriL(offset1X, offset1Y + dim.medTriLeg(), 135, unit);
  theShapes.add(triL1);
  TriL triL2 = new TriL(offset1X - dim.larTriHeight(), offset1Y + dim.larTriWidth(), -45, unit);
  theShapes.add(triL2);
  TriL triL3 = new TriL(offset1X, offset1Y + dim.medTriLeg() + dim.larTriWidth(), 135, unit);
  theShapes.add(triL3);
  TriL triL4 = new TriL(offset1X - dim.larTriHeight(), offset1Y + 2.0 * dim.larTriWidth(), -45, unit);
  theShapes.add(triL4);
  TriM triM2 = new TriM(offset1X - dim.larTriHeight(), offset1Y + 2.5 * dim.larTriWidth(), -90, unit);
  theShapes.add(triM2);

float offset2X = origX;
float offset2Y = offset1Y + 2.5 * dim.larTriWidth() + 2.0 * dim.squareHeight() - dim.larTriHeight();
TriL triL5 = new TriL(offset2X, offset2Y, 45, unit);
theShapes.add(triL5);
TriL triL6 = new TriL(offset2X, offset2Y + dim.larTriHeight(), 45, unit);
theShapes.add(triL6);
Square square3 = new Square(offset2X - dim.larTriWidth()/2.0, offset2Y + dim.larTriHeight() - 2.0 * dim.squareHeight(), 0, unit);
theShapes.add(square3);
  TriS triS3 = new TriS(offset2X - dim.larTriWidth()/2.0, offset2Y + dim.larTriHeight() - dim.squareHeight(), 0, unit);
  theShapes.add(triS3);
  Square square4 = new Square(offset2X + dim.larTriWidth()/2.0, offset2Y + dim.larTriHeight() - 2.0 * dim.squareHeight(), 90, unit);
theShapes.add(square4);
TriS triS4 = new TriS(offset2X + dim.larTriWidth()/2.0, offset2Y + dim.larTriHeight() - dim.squareHeight(), 90, unit);
  theShapes.add(triS4);
  Parallelogram parallelogram2 = new Parallelogram(offset2X - dim.smaTriWidth() * 2.0, offset2Y + dim.larTriHeight(), 0, unit);
  theShapes.add(parallelogram2);
  TriS triS5 = new TriS(offset2X - dim.smaTriWidth()/2.0, offset2Y + dim.larTriHeight() + dim.smaTriHeight(), -135, unit);
  theShapes.add(triS5);
  Parallelogram parallelogram3 = new Parallelogram(offset2X, offset2Y + dim.larTriHeight(), 0, unit);
  theShapes.add(parallelogram3);
  TriS triS6 = new TriS(offset2X + 1.5 * dim.smaTriWidth(), offset2Y + dim.larTriHeight() + dim.smaTriHeight(), -135, unit);
  theShapes.add(triS6);
  TriM triM3 = new TriM(offset2X - dim.smaTriWidth() * 1.5, offset2Y + 1.5 * dim.larTriHeight(), 0, unit);
  theShapes.add(triM3);
  TriM triM4 = new TriM(offset2X + dim.smaTriWidth() * 1.5, offset2Y + 1.5 * dim.larTriHeight(), 90, unit);
  theShapes.add(triM4);
  TriS triS7 = new TriS(offset2X - dim.smaTriWidth() * 1.5, offset2Y + 1.5 * dim.larTriHeight() + dim.medTriLeg(), 180, unit);
  theShapes.add(triS7);
  TriS triS8 = new TriS(offset2X - dim.smaTriWidth() * 1.5 - dim.smaTriLeg(), offset2Y + 1.5 * dim.larTriHeight() + dim.medTriLeg(), 0, unit);
  theShapes.add(triS8);
  TriL triL7 = new TriL(offset2X - dim.smaTriWidth() * 1.5 - dim.smaTriLeg(), offset2Y + 1.5 * dim.larTriHeight() + dim.medTriLeg() + dim.larTriLeg(), 180, unit);
  theShapes.add(triL7);
  Parallelogram parallelogram4 = new Parallelogram(offset2X + dim.smaTriWidth() * 1.5, offset2Y + 1.5 * dim.larTriHeight() + dim.medTriLeg() - dim.smaTriLeg(), 45, unit);
  theShapes.add(parallelogram4);
  TriL triL8 = new TriL(offset2X + dim.smaTriWidth() * 1.5 + dim.smaTriLeg(), offset2Y + 1.5 * dim.larTriHeight() + dim.medTriLeg() + dim.larTriLeg(), -90, unit);
  theShapes.add(triL8);
  //If this tangram is supposed to always be shaking
  if (shakeAlwaysOn) {
    for(int i = 0; i < theShapes.size(); i++){
      theShapes.get(i).setShake(shakeWeight);
    }
  }
    for(int i = 0; i < theShapes.size(); i++){
      //if one piece is being hovered, then the mouse is over the overall formation.
      isHovered = theShapes.get(i).doHoverShake(shakeWeight, flashAOn, r, g, b, a)  || isHovered;;
      theShapes.get(i).drawShape();
    }
  popMatrix();  //remove matrix
  popMatrix(); //remove matrix
  return isHovered;  //if this overall formation is currently moused over
}