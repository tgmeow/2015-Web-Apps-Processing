/**
 * Public class for an x y point
 */
public class Point {
  public float x = 0, y = 0;

  Point(Point aPoint) {
    this.x = aPoint.x;
    this.y = aPoint.y;
  }
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  Point() {
  }
  public boolean matches(Point aPoint) {
    if (aPoint.x == this.x && aPoint.y == this.y) return true;
    return false;
  }
  public Point clone(){
    return new Point(this.x, this.y);
  }
  public String toString(){
    return (this.x + " " + this.y);
  }
}

public float distance(Point point1, Point point2) {
  //float disx = (point1.x - point2.x);
  //float disy = point1.y - point2.y;
  //return sqrt(disx * disx + disy * disy);
  return dist(point1.x, point1.y, point2.x, point2.y);
  
}
public void line(Point firstPoint, Point secondPoint) {
  line(firstPoint.x, firstPoint.y, secondPoint.x, secondPoint.y);
}
public void point(Point aPoint) {
  point(aPoint.x, aPoint.y);
}
public void line(float x, float y, Point secondPoint) {
  line(x, y, secondPoint.x, secondPoint.y);
}