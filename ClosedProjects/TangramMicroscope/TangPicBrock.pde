/**
 * Class implementation of the abstract class TangShape
 * This class (currently) uses the function drawTangramG() to actually draw the tangram
 */
public class TangPicBrock extends TangShape {
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

  public TangPicBrock(float x, float y, int aShakeWeight, int unit, float scale, float xDiff, float yDiff, boolean alwaysShake, float rotationDiff, boolean flashAOn, int red, int green, int blue, int alpha) {
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
    isHovered = drawPicBrock(x, y, shakeWeight, unit, scale, alwaysShake, rotation, flashAOn, r, g, b, a);
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
public boolean drawPicBrock(float x, float y, int shakeWeight, int unit, float scale, boolean shakeAlwaysOn, float rotation, boolean flashAOn, int r, int g, int b, int a) {
  boolean isHovered = false;    //initially set tangram hover to false
  pushMatrix();    //matrix for scaling the tangram
  noStroke();      //no borders
  scale(scale);    //scale the tangram
  float origX = x;  //X position for the top of the tangram
  float origY = y;  //Y position for the top of the tangram
  unit*=4;
  pushMatrix();    //new matrix for rotating the tangram about the approximate center of the tangram
  if (rotation != 0) {    //do this crazy math if the rotation is something other than 0
    translate(x + unit / 2.0, y + unit / 2.0);    //move the origin to the center of the tangram
    rotate(radians(rotation));                          //rotate the grid about the origin
    translate(-(x + unit / 2.0), -(y  + unit / 2.0));  //move the grid back
  }


  //If this tangram is supposed to always be shaking
  if (shakeAlwaysOn) {
    image(brock, x + (random(shakeWeight) - shakeWeight/2.0), y + (random(shakeWeight) - shakeWeight/2.0), unit, unit);
  } else {
    image(brock, x, y, unit, unit);
  }
  Square brockSquare = new Square(x, y, 0, unit);
  isHovered = brockSquare.ifContains(mouseX, mouseY);
  
  popMatrix();  //remove matrix
  popMatrix(); //remove matrix
  return isHovered;  //if this overall formation is currently moused over
}