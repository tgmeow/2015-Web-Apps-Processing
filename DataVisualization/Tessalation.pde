public class Tessalation {
  int x = 0, y = 0, tessalationWidth = 0, tessalationHeight = 0, xRandoms = 0, yRandoms = 0, randomVariance = 0;
  java.awt.Polygon tessalation;

  public Tessalation() {
    tessalation = new java.awt.Polygon();
  }

  public Tessalation(int x, int y, int tessalationWidth, int tessalationHeight, int xRandoms, int yRandoms, int variance) {
    this.x = x;
    this.y = y;
    this.tessalationWidth = tessalationWidth;
    this.tessalationHeight = tessalationHeight;
    this.xRandoms = xRandoms;
    this.yRandoms = yRandoms;
    this.randomVariance = variance;
    tessalation = new java.awt.Polygon();
    this.generateShape();
  }
  private int newRandom(int variance) {
    return round(random(-variance/2.0, variance/2.0));
  }
  public void generateShape() {
    tessalation.reset();
    
    //Top Side
    ArrayList <Point> topLine = new ArrayList<Point>();
    Point topLeft = new Point(x + newRandom(randomVariance) , y );
    tessalation.addPoint(int(topLeft.x), int(topLeft.y));
    topLine.add(new Point(topLeft));
    for (int index = 0; index < xRandoms; index++) {
      int xNumShift = ((index+1)*tessalationWidth)/(xRandoms+1);
      Point temp = new Point(x + xNumShift, y + newRandom(randomVariance));
      tessalation.addPoint(int(temp.x), int(temp.y));
      topLine.add(new Point(temp));
    }
    Point topRight = new Point(topLeft.x + tessalationWidth, topLeft.y);
    tessalation.addPoint(int(topRight.x), int(topRight.y));
    topLine.add(new Point(topRight));

    //Right Side
    ArrayList <Point> rightLine = new ArrayList<Point>();
    for (int index = 0; index < yRandoms; index++) {
      int yNumShift = ((index+1)*tessalationHeight)/(yRandoms+1);
      Point temp = new Point(x + tessalationWidth + newRandom(randomVariance), y + yNumShift );
      tessalation.addPoint(int(temp.x), int(temp.y));
      rightLine.add(new Point(temp));
    }
    //Bottom Side
    for(int index = topLine.size()-1; index >=0; index--){
      Point thePoint = new Point(topLine.get(index));
      tessalation.addPoint(int(thePoint.x), int(thePoint.y + tessalationHeight));
    }
    //Left Side
    for(int index = rightLine.size()-1; index >=0; index--){
      Point thePoint = new Point(rightLine.get(index));
      tessalation.addPoint(int(thePoint.x - tessalationWidth), int(thePoint.y));
    }
    tessalation.addPoint(int(topLeft.x), int(topLeft.y));
  }
  
  public void drawTessalation(){
    beginShape();
    for (int i = 0; i < tessalation.npoints; i++) {
      vertex(tessalation.xpoints[i], tessalation.ypoints[i]);
    } 
    endShape();
  }
  public int getTessalationWidth(){
    return this.tessalationWidth;
  }
  public int getTessalationHeight(){
     return this.tessalationHeight;
  }
}