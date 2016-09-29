/**
 * Public class for an x y point
 */
public class Point {
  public float x, y;
  
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