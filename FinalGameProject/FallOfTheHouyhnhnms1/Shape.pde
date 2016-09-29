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
  abstract void printDiagnostics();
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
  public boolean doHoverShake(int shakeWeight, boolean flashAOn, color aColor) {
    if (this.ifContains(mouseX, mouseY)) {    //if this shape contais the mouse location
      fill(random(1) * 255, random(1) * 255, random(1) * 255);   //draw the shape with a random color
      this.setShake(shakeWeight);      //set the shake of the shape
      this.printDiagnostics();
      return true;      //This shape is being hovered
    } else {      //if it is not hovered, flash the alpha color if on
      if (flashAOn) {
        if (int(random(2)) == 1) {  //random on and off
          fill(aColor);      //fill with alpha
        } else fill(red(aColor), green(aColor), blue(aColor));    //fill without alpha
      } else fill(aColor);    //fill with alpha by default
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