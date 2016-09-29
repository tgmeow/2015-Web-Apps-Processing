/**
 * Class implementation of the abstract class TangShape
 * This class (currently) uses the function drawTangramHorse() to actually draw the horse
 */
public class SolidTangHorse extends TangShape {
  /**
   * Public constructor for a Solid Tangram Horse (SolidTangHorse) (single piece)
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
  public SolidTangHorse(float x, float y, int aShakeWeight, int unit, float scale, float xDiff, float yDiff, boolean alwaysShake, float rotationDiff, boolean flashAOn, color aColor) {
    this.x = x;
    this.y = y;
    this.alwaysShake = alwaysShake;
    this.rotationDiff = rotationDiff;
    this.shakeWeight = aShakeWeight;
    this.unit = unit;
    this.scale = scale;
    this.horseColor = aColor;
    this.flashAOn = flashAOn;
    this.xDiff = xDiff;
    this.yDiff = yDiff;
  }
  /**
   * Draws this tangram
   */
  public void drawThisTangram() {
    rotation += rotationDiff;
    isHovered = drawSolidTangramHorse(x, y, shakeWeight, unit, scale, alwaysShake, rotation, flashAOn, horseColor);
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
public boolean drawSolidTangramHorse(float x, float y, int shakeWeight, int unit, float scale, boolean shakeAlwaysOn, float rotation, boolean flashAOn, color aColor) {
  boolean isHovered = false;    //initially set tangram hover to false
  pushMatrix();    //matrix for scaling the horse
  noStroke();      //no borders

  float origX = x;  //X position for the top of the horse
  float origY = y;  //Y position for the top of the horse
  pushMatrix();    //new matrix for rotating the horse about the approximate center of the horse
  if (rotation != 0) {    //do this crazy math if the rotation is something other than 0
    translate(x, (y + ((unit * 2.5) + (unit/6.0))));    //move the origin to the center of the horse
    rotate(radians(rotation));                          //rotate the grid about the origin
    translate(-x, -(y + ((unit * 2.5) + (unit/6.0))));  //move the grid back
  }
    scale(scale);    //scale the horse

  //Draw the ________ tangram shape of the horse at this location, which is relative to the horse origin origX and origY, with rotation and unit size
  SolidHorseShape horseShape = new SolidHorseShape(origX, origY, 0, unit); 

  //If this tangram is supposed to always be shaking
  if (shakeAlwaysOn) {
    horseShape.setShake(shakeWeight);
  }

  //if one piece is being hovered, then the mouse is over the overall formation.
  isHovered = horseShape.doHoverShake(shakeWeight, flashAOn, aColor) || isHovered;
  horseShape.drawShape();  //draw this tangram piece
  popMatrix();  //remove matrix
  popMatrix(); //remove matrix
  return isHovered;  //if this overall formation is currently moused over
}