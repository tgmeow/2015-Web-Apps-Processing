/**
 * Constructor for SolidHorseShape Object
 * @param x The X location of the right angle corner of the horse
 * @param y The Y location of the right angle corner of the horse
 * @param rotation The rotation in degrees of the square around the top point
 * @param unit The unit size of the horse
 */
public class SolidHorseShape extends Shape {
  public SolidHorseShape (float x, float y, float rotation, int unit) {
    topP.x = x;
    topP.y = y;
    this.rotation = rotation;
    Dimensions dim = new Dimensions(unit);
    
    //BEGIN SHAPE
    p.addPoint(0, 0);
    
    p.addPoint(int(dim.medTriHeight()), int(dim.medTriHeight()));
    p.addPoint(int(dim.medTriHeight()), int(dim.medTriHeight()+dim.squareHeight()));
    
    //TAIL
    p.addPoint(int(dim.medTriHeight()+dim.larTriHeight()), int(dim.medTriHeight()+dim.squareHeight()+dim.larTriHeight()));
    
    //TEMP
    p.addPoint(int(dim.medTriHeight()+dim.larTriHeight()+unit), int(dim.medTriHeight()+dim.squareHeight()+dim.larTriHeight()+unit));
    p.addPoint(int(dim.medTriHeight()+dim.larTriHeight()+unit*0.5), int(dim.medTriHeight()+dim.squareHeight()+dim.larTriHeight()+unit));
    
    p.addPoint(int(dim.medTriHeight()+dim.larTriHeight()), int(dim.medTriHeight()+dim.squareHeight()+dim.larTriHeight()));
    //END TAIL
    
    p.addPoint(int(dim.squareWidth()), int(dim.medTriHeight()+dim.squareHeight()+dim.larTriHyp()));
    p.addPoint(int(dim.squareWidth()), int(dim.medTriHeight()+dim.squareHeight()+dim.larTriLeg()+(unit/3.0)+dim.smaTriLeg()));
    p.addPoint(0, int(dim.medTriHeight()+dim.squareHeight()+dim.larTriLeg()+(unit/3.0)+dim.smaTriLeg()));
    p.addPoint(int(dim.squareWidth()), int(dim.medTriHeight()+dim.squareHeight()+dim.larTriLeg()+(unit/3.0)));
    p.addPoint(int(dim.squareWidth()), int(dim.medTriHeight()+dim.squareHeight()+dim.larTriLeg()));
    p.addPoint(int(-dim.squareWidth()-dim.smaTriHeight()+dim.smaTriHyp()), int(dim.medTriHeight()+dim.squareHeight()+dim.smaTriHeight()));
    p.addPoint(int(-dim.squareWidth()-dim.smaTriHeight()+dim.smaTriHyp()), int(dim.medTriHeight()+dim.squareHeight()+dim.smaTriHeight()));
    p.addPoint(int(-dim.squareWidth()-dim.smaTriHeight()), int(dim.medTriHeight()+dim.squareHeight()+dim.smaTriHeight()));
    p.addPoint(-int(dim.squareWidth()), int(dim.medTriHeight()+dim.squareHeight()));
    p.addPoint(0, int(dim.medTriHeight()+dim.squareHeight()));
    p.addPoint(0, int(dim.medTriHeight()));
    p.addPoint(-int(dim.medTriHeight()), int(dim.medTriHeight()));
    
    p.addPoint(0, 0);
    //ENDSHAPE
    
  }
  
  void printDiagnostics() {
    print("Square Diagnostics");
    for (int i = 0; i < p.npoints; i++) {
      print(p.xpoints[i] + " " + p.ypoints[i] + "\n");
    }
  }
  
}