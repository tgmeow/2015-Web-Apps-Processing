public class PolygonButton {
  int x = 0, y = 0, buttonWidth = 0, buttonHeight = 0;
  java.awt.Polygon button;

  public PolygonButton() {
    button = new java.awt.Polygon();
  }
  public PolygonButton(int x, int y, int buttonWidth, int buttonHeight) {
    this.x = x;
    this.y = y;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    button = new java.awt.Polygon();
  }
  public void drawButton() {
    button = new java.awt.Polygon();
    button.addPoint(x, y);
    button.addPoint(x + buttonWidth, y);
    button.addPoint(x + buttonWidth, y + buttonHeight);
    button.addPoint(x, y + buttonHeight);
    button.addPoint(x, y);
    beginShape();
    for (int i = 0; i < button.npoints; i++) {
      vertex(button.xpoints[i], button.ypoints[i]);
    } 
    endShape();
  }

  public void setX(int newX) {
    this.x = newX;
  }
  public void setY(int newY) {
    this.y = newY;
  }
  public void setWidth(int newWidth) {
    this.buttonWidth = newWidth;
  }
  public void setHeight(int newHeight) {
    this.buttonHeight = newHeight;
  }
  public boolean contains(int clickX, int clickY) {
    button = new java.awt.Polygon();
    button.addPoint(x, y);
    button.addPoint(x + buttonWidth, y);
    button.addPoint(x + buttonWidth, y + buttonHeight);
    button.addPoint(x, y + buttonHeight);
    button.addPoint(x, y);
    //    println(x + " " + y + " " + buttonWidth + " " + buttonHeight);
    return button.contains(clickX, clickY);
  }
}