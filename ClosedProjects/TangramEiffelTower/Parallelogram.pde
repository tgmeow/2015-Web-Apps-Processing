/**
 * Constructor for Parallelogram
 * @param x The X location of the top left pointy corner of the parallelogram
 * @param y The Y location of the top left pointy corner of the parallelogram
 * @param rotation The rotation in degrees of the parallelogram around the top left pointy corner
 * @param unit The unit size of the parallelogram
 */
public class Parallelogram extends Shape {
  public Parallelogram (float x, float y, float rotation, int unit) {
    topP.x = x;
    topP.y = y;
    this.rotation = rotation;
    p.addPoint(0, 0);
    p.addPoint(int(unit*sqrt(2)), 0);
    p.addPoint(int((unit*sqrt(2))+(unit/sqrt(2))), int(unit/sqrt(2)));
    p.addPoint(int(unit/sqrt(2)), int(unit/sqrt(2)));
    p.addPoint(0, 0);
  }
      void printDiagnostics(){
       print("Parallelogram Diagnostics");
    for (int i = 0; i < p.npoints; i++) {
      print(p.xpoints[i] + " " + p.ypoints[i] + "\n");
    } 
  }
}