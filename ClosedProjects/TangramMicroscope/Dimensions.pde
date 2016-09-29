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