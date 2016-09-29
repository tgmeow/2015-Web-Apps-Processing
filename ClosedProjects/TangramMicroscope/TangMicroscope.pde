/**
 * Class implementation of the abstract class TangShape
 * This class (currently) uses the function drawTangramG() to actually draw the tangram
 */
public class TangMicroscope extends TangShape {
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
  public TangMicroscope(float x, float y, int aShakeWeight, int unit, float scale, float xDiff, float yDiff, boolean alwaysShake, float rotationDiff, boolean flashAOn, int red, int green, int blue, int alpha) {
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
    isHovered = drawTangramMicroscope(x, y, shakeWeight, unit, scale, alwaysShake, rotation, flashAOn, r, g, b, a);
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
public boolean drawTangramMicroscope(float x, float y, int shakeWeight, int unit, float scale, boolean shakeAlwaysOn, float rotation, boolean flashAOn, int r, int g, int b, int a) {
  boolean isHovered = false;    //initially set tangram hover to false
  Dimensions dim = new Dimensions(unit);  //create a dimensions instance to get tangram shape dimensions
  pushMatrix();    //matrix for scaling the tangram
  noStroke();      //no borders
  scale(scale);    //scale the tangram
  float origX = x;  //X position for the top of the tangram
  float origY = y;  //Y position for the top of the tangram
  pushMatrix();    //new matrix for rotating the tangram about the approximate center of the tangram
  if (rotation != 0) {    //do this crazy math if the rotation is something other than 0
    translate(x, (y + ((unit * 5.0))));    //move the origin to the center of the tangram
    rotate(radians(rotation));                          //rotate the grid about the origin
    translate(-(x), -(y + ((unit * 5.0))));  //move the grid back
  }

  ////Draw the ________ tangram shape of the tangram at this location, which is relative to the tangram origin origX and origY, with rotation and unit size
  //Draw the shape of the tangram at the origin location origX, origY, with rotation and unit size
  Square square1 = new Square(origX, origY, 0, unit);
  float offSet1X = origX - (unit * ((sqrt(2) - 1) / 2.0));
  float offSet1Y = origY + unit;
  TriM triM1 = new TriM(offSet1X + dim.medTriLeg(), offSet1Y, 90, unit);
  TriL triL1 = new TriL(offSet1X + dim.medTriLeg(), offSet1Y + dim.medTriLeg(), 135, unit);
  TriL triL2 = new TriL(offSet1X, offSet1Y + dim.larTriWidth(), -45, unit);
  TriM triM2 = new TriM(offSet1X, offSet1Y + dim.larTriWidth() + dim.medTriLeg(), -90, unit);
  Square square2 = new Square(origX, origY + dim.squareHeight() + dim.larTriWidth() + dim.medTriLeg(), 0, unit);
  
  float offSet2X = offSet1X - (2.0 * dim.paraHeight());
  float offSet2Y = offSet1Y + dim.medTriLeg() + (unit * (2.0 * sqrt(2.0))) + unit / 8.0;
  Parallelogram parallelogram1 = new Parallelogram(offSet1X, offSet1Y + dim.medTriLeg()  + unit / 8.0, 90, unit);
  Parallelogram parallelogram2 = new Parallelogram(offSet1X - dim.paraHeight(), offSet1Y + (unit * sqrt(2.0) / 2.0) + dim.medTriLeg()  + unit / 8.0, 90, unit);
  TriS triS1 = new TriS(offSet2X + dim.smaTriLeg(), offSet2Y, 180, unit);
  TriS triS2 = new TriS(offSet2X, offSet2Y, 0, unit);
  TriS triS3 = new TriS(offSet2X + dim.smaTriLeg(), offSet2Y + dim.smaTriLeg(), 180, unit);
  
  float offSet3X = offSet1X + (unit + unit * (-sqrt(2.0))) - dim.smaTriLeg();
  float offSet3Y = offSet2Y + dim.smaTriLeg();
  TriL triL3 = new TriL(offSet3X + dim.larTriWidth()/2.0, offSet3Y + dim.larTriHeight(), -135, unit);
  TriL triL4 = new TriL(offSet3X + dim.larTriWidth(), offSet3Y, 45, unit);
  
  TriS triS4 = new TriS(offSet3X + dim.larTriWidth()/2.0 - dim.smaTriWidth()/2.0, offSet3Y + dim.larTriHeight() - dim.smaTriHeight(), 45, unit);
  

  //If this tangram is supposed to always be shaking
  if (shakeAlwaysOn) {
    triM1.setShake(shakeWeight);
    triM2.setShake(shakeWeight);
    triS1.setShake(shakeWeight);
    triS2.setShake(shakeWeight);
    triS3.setShake(shakeWeight);
    triS4.setShake(shakeWeight);
    triL1.setShake(shakeWeight);
    triL2.setShake(shakeWeight);
    triL3.setShake(shakeWeight);
    triL4.setShake(shakeWeight);
    square1.setShake(shakeWeight);
    square2.setShake(shakeWeight);
    parallelogram1.setShake(shakeWeight);
    parallelogram2.setShake(shakeWeight);
  }

  //if one piece is being hovered, then the mouse is over the overall formation.
    isHovered = triS1.doHoverShake(shakeWeight, flashAOn, r, g, b, a)  || isHovered;
  triS1.drawShape();
    isHovered = triS2.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triS2.drawShape();
      isHovered = triS3.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triS3.drawShape();
      isHovered = triS4.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triS4.drawShape();
  isHovered = triM1.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triM1.drawShape();  //draw this tangram piece
    isHovered = triM2.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triM2.drawShape();  //draw this tangram piece
  isHovered = square1.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  square1.drawShape();
    isHovered = square2.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  square2.drawShape();

  isHovered = triL1.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triL1.drawShape();
  isHovered = triL2.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triL2.drawShape();
    isHovered = triL3.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triL3.drawShape();
    isHovered = triL4.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  triL4.drawShape();

  isHovered = parallelogram1.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  parallelogram1.drawShape();
    isHovered = parallelogram2.doHoverShake(shakeWeight, flashAOn, r, g, b, a) || isHovered;
  parallelogram2.drawShape();
  popMatrix();  //remove matrix
  popMatrix(); //remove matrix
  return isHovered;  //if this overall formation is currently moused over
}