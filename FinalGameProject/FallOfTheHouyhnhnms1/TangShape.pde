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
  protected color horseColor = color(0);
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