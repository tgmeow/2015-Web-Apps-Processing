public abstract class Controller<T> {

  protected String name = "Null";
  protected int controllerX = 0;
  protected int controllerY = 0;
  protected int controllerWidth = 0;
  protected int controllerHeight = 0;
  protected final int TEXT_SIZE = 12;
  protected final color TEXT_COLOR = color(214);
  protected final int TEXT_PADDING_LEFT = 5;
  protected final color BACKGROUND_COLOR = color(26);
  protected final color HOVER_COLOR = color(60);

  protected final int HIGHLIGHTS_WIDTH = 3;
  protected Point superMenuCoordinates = new Point();
  protected boolean isPressed = false;
  protected PFont textFont;


  public void updateMenuXY(Point newXY) {
    this.superMenuCoordinates = new Point(newXY);
  }
  public String getControllerName() {
    return this.name;
  }
  public abstract void resetControls();
  public abstract void pressUpdate(int clickX, int clickY);
  public abstract void clickUpdate(int clickX, int clickY);
  public abstract void releaseUpdate(int clickX, int clickY);
  public abstract void drawController(int controllerX, int controllerY, int controllerWidth, int controllerHeight);

  public abstract T getValue();
  public abstract Object getReturnType();
}