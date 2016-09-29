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
      void printDiagnostics(){
       print("Square Diagnostics");
    for (int i = 0; i < p.npoints; i++) {
      print(p.xpoints[i] + " " + p.ypoints[i] + "\n");
    } 
  }
}