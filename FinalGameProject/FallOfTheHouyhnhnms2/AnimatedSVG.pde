public class AnimatedSVG {

  protected boolean imageLoaded = false;
  protected String fileLoc;
  protected PShape SVGImage;
  protected float scale = 1;
  protected boolean isRunning = false;
  protected Point startPoint;
  protected Point endPoint;

  protected float animationTime = 0;
  protected int startTime = 0;

  public AnimatedSVG() {
  }
  public AnimatedSVG(String fileLoc, float scale, Point startPoint, Point endPoint, float animationTime) {
    this.fileLoc = fileLoc;
    this.scale = scale;
    this.startPoint = new Point(startPoint);
    this.endPoint = new Point(endPoint);
    this.animationTime = (animationTime > 0) ? animationTime : 1;
    println("Loading Image: " + fileLoc);
    try {
      SVGImage = loadShape(fileLoc);
      SVGImage.scale(scale);
      imageLoaded = true;
      println("Image loaded sucessfully!");
    }
    catch(Exception e) {
      println(e);
      println("ERROR: IMAGE \"" + fileLoc + "\" NOT LOADED CORRECTLY!");
    }
  }
  public Point getStartPoint() {
    return new Point(startPoint);
  }
  public Point getEndPoint() {
    return new Point(endPoint);
  }
  public void setStartPoint(Point aPoint) {
    startPoint = new Point(aPoint);
  }
  public void setEndPoint(Point aPoint) {
    endPoint = new Point(aPoint);
  }
  public boolean isRunning() {
    return isRunning;
  }

  public void start() {
    isRunning = true;
    startTime = millis();
    //TODO
  }

  public void stop() {
    isRunning = false;
    //TODO
  }
  public void draw() {
    if (isRunning) {
      int timeSince = millis() - startTime;
      if (timeSince <= animationTime) {
        Point currPoint = new Point(animatePointLerp(startPoint, endPoint, ((float)timeSince)/animationTime));
        if (imageLoaded) { 
          shape(SVGImage, currPoint.x - (SVGImage.width*scale*0.5), currPoint.y - (SVGImage.height*scale*0.5));
        } else {
          stroke(0);
          strokeWeight(30);
          point(currPoint.x, currPoint.y);
        }
      } else isRunning = false;
    }
  }

  public AnimatedSVG clone() {
    return new AnimatedSVG(fileLoc, scale, new Point(startPoint), new Point(endPoint), animationTime);
  }
}


//OBJECTS PASS BY REFERENCE!
//Move from here to here with this many frames remaining
Point animatePointLerp(Point startPoint, Point targetPoint, float lerpRatio) {
  float currPointX = lerp(startPoint.x, targetPoint.x, lerpRatio);
  float currPointY = lerp(startPoint.y, targetPoint.y, lerpRatio);
  return new Point(currPointX, currPointY);
}