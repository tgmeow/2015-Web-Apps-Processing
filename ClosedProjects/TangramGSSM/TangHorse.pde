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