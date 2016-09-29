//Word class things

public class Word {
  public final float ACCY = 1E-9f;
  private String text;
  private PFont font;
  private int fontSize;
  private float x, y, rotation;
  private color wordColor;
  private int wordCount;
  //private Point pointTopR, pointTopL, pointBotL, pointBotR;

  public Word() {
  }
  
  public Word(String wordText, int wordCount, PFont font, int fontSize, float x, float y, float rotation, color wordColor) {
    this.text = wordText;
    this.wordCount = wordCount;
    this.font = font;
    this.fontSize = fontSize;
    this.x = x;
    this.y = y;
    this.rotation = rotation;
    this.wordColor = wordColor;
  }
  //method to draw the word
  public boolean drawWord() {
    fill(wordColor);
    textFont(this.getFont(), this.getFontSize());

    pushMatrix();
    translate(this.getX(), this.getY());
    rotate(radians(this.getRotation()));
    text(this.getText(), 0, 0 + this.getHeight());

    //draw frames around words, if enabled
    if (enableDebugShapes) {
      noFill();
      stroke(0);
      strokeWeight(1);
      //  rect(this.getPointTopL().x, this.getPointTopL().y, this.getWidth(), this.getHeight());
      java.awt.Polygon p = new java.awt.Polygon();
      p.addPoint((int)this.getPointTopL().x, (int)this.getPointTopL().y);
      p.addPoint((int)this.getPointTopR().x, (int)this.getPointTopR().y);
      p.addPoint((int)this.getPointBotR().x, (int)this.getPointBotR().y);
      p.addPoint((int)this.getPointBotL().x, (int)this.getPointBotL().y);
      p.addPoint((int)this.getPointTopL().x, (int)this.getPointTopL().y);
      beginShape();    //start drawing the shape

      //Undo rotation and translate because these calculations are already in the xy points of the polygon
      rotate(radians(-rotation));
      translate(-this.getX(), -this.getY());

      for (int i = 0; i < p.npoints; i++) {
        vertex(p.xpoints[i], p.ypoints[i]);
      }
      endShape();
    }
    popMatrix();
    return true;
  }
  //Check for word intersections
  public boolean wordIntersects(java.util.List <Word> theWords) {
    boolean intersects = false;
    for (int i = 0; i < theWords.size() && !intersects; i++ ) {
      Word currWord = theWords.get(i);

      ArrayList<Point> currRPoints = new ArrayList<Point>();
      currRPoints.add(currWord.getPointTopL());
      currRPoints.add(currWord.getPointTopR());
      currRPoints.add(currWord.getPointBotR());
      currRPoints.add(currWord.getPointBotL());

      ArrayList<Point> thisRPoints = new ArrayList<Point>();
      thisRPoints.add(this.getPointTopL());
      thisRPoints.add(this.getPointTopR());
      thisRPoints.add(this.getPointBotR());
      thisRPoints.add(this.getPointBotL());

      Point thisTopL = this.getPointTopL();
      Point thisBotR = this.getPointBotR();
      Point currTopL = currWord.getPointTopL();
      Point currBotR = currWord.getPointBotR();

      //Untranslate points according to "this" word and the unrotate according to each.
      Point currWordRotL = rotateTransPoint(currTopL, -currWord.getRotation(), thisTopL.x, thisTopL.y);
      Point currWordRotR = rotateTransPoint(currBotR, -currWord.getRotation(), thisTopL.x, thisTopL.y);
      Point thisWordRotL = rotateTransPoint(thisTopL, -this.getRotation(), thisTopL.x, thisTopL.y);
      Point thisWordRotR = rotateTransPoint(thisBotR, -this.getRotation(), thisTopL.x, thisTopL.y);
      intersects = box_box(currWordRotL.x, currWordRotL.y, currWordRotR.x, currWordRotR.y, 
        thisWordRotL.x, thisWordRotL.y, thisWordRotR.x, thisWordRotR.y);

      //println(i + " " + theWords.size() + " " +intersects);

      for (int thisRectCounter = 0; thisRectCounter < 16 && !intersects; thisRectCounter++) {
        int firstPoint = thisRectCounter%4;
        int secondPoint = (thisRectCounter+1)%4;
        int otherFirstPoint = thisRectCounter/4;
        int otherSecondPoint = (thisRectCounter/4 + 1) % 4;
        intersects = line_line(thisRPoints.get(firstPoint).x, thisRPoints.get(firstPoint).y, thisRPoints.get(secondPoint).x, thisRPoints.get(secondPoint).y, 
          currRPoints.get(otherFirstPoint).x, currRPoints.get(otherFirstPoint).y, currRPoints.get(otherSecondPoint).x, currRPoints.get(otherSecondPoint).y);
        if (intersects) {
          return true;
        }
      }
    }
    return intersects;
  }
  public int getWordCount() {
    return wordCount;
  }

  /**
   * http://www.lagers.org.uk/how-to/ht-geom-01/index.html
   * Determine whether two boxes intersect.
   * The boxes are represented by the top-left and bottom-right corner coordinates. 
   * 
   * [ax0, ay0]/[ax1, ay1] top-left and bottom-right corners of rectangle A
   * [bx0, by0]/[bx1, by1] top-left and bottom-right corners of rectangle B
   */
  public boolean box_box(float ax0, float ay0, float ax1, float ay1, float bx0, float by0, float bx1, float by1) {
    float topA = min(ay0, ay1);
    float botA = max(ay0, ay1);
    float leftA = min(ax0, ax1);
    float rightA = max(ax0, ax1);
    float topB = min(by0, by1);
    float botB = max(by0, by1);
    float leftB = min(bx0, bx1);
    float rightB = max(bx0, bx1);
    //println(leftA + " " + rightA + " " + leftB + " " + rightB);

    return !(botA <= topB  || botB <= topA || rightA <= leftB || rightB <= leftA);
  }

  /**
   * http://www.lagers.org.uk/how-to/ht-geom-01/index.html
   * See if two finite lines intersect.
   * [x0, y0]-[x1, y1] start and end of the first line
   * [x2, y2]-[x3, y3] start and end of the second line
   */
  public boolean line_line(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3) {
    float f1 = (x1 - x0);
    float g1 = (y1 - y0);
    float f2 = (x3 - x2);
    float g2 = (y3 - y2);
    float f1g2 = f1 * g2;
    float f2g1 = f2 * g1;
    float det = f2g1 - f1g2;
    if (abs(det) > ACCY) {
      float s = (f2*(y2 - y0) - g2*(x2 - x0))/ det;
      float t = (f1*(y2 - y0) - g1*(x2 - x0))/ det;
      return (s >= 0 && s <= 1 && t >= 0 && t <= 1);
    }
    return false;
  }
  //method to unrotate and untranslate a point
  public Point rotateTransPoint(Point aPoint, float aRotation, float tX, float tY) {
    float originalX = aPoint.x - tX;
    float originalY = aPoint.y - tY;
    float rotatedX = originalX*cos(radians(aRotation)) - originalY * sin(radians(aRotation));
    float rotatedY = originalX * sin(radians(aRotation)) + originalY * cos(radians(aRotation));
    return new Point(rotatedX, rotatedY);
  }

  //Lots of getters and setters

  public Point getPointTopL() {
    return new Point(this.getX(), this.getY());
  }
  public Point getPointTopR() {
    float originalX = this.getWidth();
    float originalY = 0;
    float rotatedX = originalX*cos(radians(rotation)) - originalY * sin(radians(rotation));
    float rotatedY = originalX * sin(radians(rotation)) + originalY * cos(radians(rotation));
    return new Point(this.getX() + rotatedX, this.getY() + rotatedY);
  }
  public Point getPointBotL() {
    float originalX = 0;
    float originalY = this.getHeight();
    float rotatedX = originalX*cos(radians(rotation)) - originalY * sin(radians(rotation));
    float rotatedY = originalX * sin(radians(rotation)) + originalY * cos(radians(rotation));
    return new Point(this.getX() + rotatedX, this.getY() + rotatedY);
  }
  public Point getPointBotR() {
    float originalX = this.getWidth();
    float originalY = this.getHeight();
    float rotatedX = originalX*cos(radians(rotation)) - originalY * sin(radians(rotation));
    float rotatedY = originalX * sin(radians(rotation)) + originalY * cos(radians(rotation));
    return new Point(this.getX() + rotatedX, this.getY() + rotatedY);
  }
  public ArrayList<Point> getPoints() {
    ArrayList<Point> points = new ArrayList<Point>();
    points.add(this.getPointTopL());
    points.add(this.getPointTopR());
    points.add(this.getPointBotL());
    points.add(this.getPointBotR());
    return points;
  }

  public void setX(float x) {
    this.x = x;
  }
  public void setY(float y) {
    this.y = y;
  }
  public void setRotation(float rotation) {
    this.rotation = rotation;
  }
  public void setFontSize(int fontSize) {
    this.fontSize = fontSize;
  }
  public void setWordColor(color aColor) {
    this.wordColor = aColor;
  }
  public String getText() {
    return text;
  }
  public float getX() {
    return x;
  }
  public float getY() {
    return y;
  }
  public float getRotation() {
    return rotation;
  }
  public float getWidth() {
    textSize(fontSize);
    return textWidth(text);
  }
  public int getHeight() {
    return fontSize;
  }
  public int getFontSize() {
    return fontSize;
  }
  public PFont getFont() {
    return font;
  }
  public color getColor() {
    return wordColor;
  }
}