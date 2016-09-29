/**
 * Public class for an x y point
 */
public class Point {
  public float x = 0, y = 0;
  
  Point(Point aPoint){
    this.x = aPoint.x;
    this.y = aPoint.y;
  }
  Point(float x, float y){
    this.x = x;
    this.y = y;
  }
    Point(int x, int y){
    this.x = x;
    this.y = y;
  }
    Point(){
  }
}

void line(Point firstPoint, Point secondPoint){
  line(firstPoint.x, firstPoint.y, secondPoint.x, secondPoint.y);
}