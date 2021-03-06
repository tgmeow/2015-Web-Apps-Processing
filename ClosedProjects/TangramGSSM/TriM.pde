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
    void printDiagnostics(){
       print("TriM Diagnostics");
    for (int i = 0; i < p.npoints; i++) {
      print(p.xpoints[i] + " " + p.ypoints[i] + "\n");
    } 
  }
}