public class IntSlider extends Controller {

  private int min = 0;
  private int max = 1;
  private int currentValue = 0;

  private final color SLIDER_BACKGROUND_COLOR = color(48);
  private final int SLIDER_PADDING = 4;
  private final color HIGHLIGHTS_COLOR = color(47, 161, 214);

  private int initialValue = 0;

  public IntSlider() {
    textFont = createFont("Calibri", TEXT_SIZE);
  }
  public IntSlider(String name, int min, int max, int value, Point menuXY) {
    textFont = createFont("Calibri", TEXT_SIZE);
    this.name = name;
    this.min = min;
    this.max = max;
    this.setValue(value);
    this.superMenuCoordinates = new Point(menuXY);
    this.initialValue = value;
  }

  public int getMin() {
    return this.min;
  }
  public int getMax() {
    return this.max;
  }
  public int getRange() {
    return this.max - this.min;
  }
  public Integer getValue() {
    return this.currentValue;
  }
  public void setSliderName(String newName) {
    this.name = newName;
  }
  public void setMin(int newMin) {
    this.min = newMin;
  }
  public void setMax(int newMax) {
    this.max = newMax;
  }
  public void setValue(int newValue) {
    if (newValue > this.getMax()) newValue = this.getMax();
    if (newValue < this.getMin()) newValue = this.getMin();
    this.currentValue = newValue;
  }
  public Object getReturnType() {
    return Integer.class;
  }
  public void clickUpdate(int clickX, int clickY) {
  }
  public void pressUpdate(int clickX, int clickY) {
    int clickedChangeY = 0;
    int clickedChangeX = 0;
    if (isPressed) {
      clickedChangeY = height*2;
      clickedChangeX = width*2;
    }
    float slidingWidth = controllerWidth*2.0/5.0;
    isPressed = (clickX >= (slidingWidth - clickedChangeX) && clickX <= (slidingWidth*2 + clickedChangeX) && clickY <= (controllerY + controllerHeight - SLIDER_PADDING + clickedChangeY) && clickY >= (controllerY + SLIDER_PADDING - clickedChangeY));
  }
  public void releaseUpdate(int clickX, int clickY) {
    isPressed = false;
  }
  private boolean slidingWidthContains(int clickX, int clickY) {
    float slidingWidth = controllerWidth*2.0/5.0;
    return clickX >= slidingWidth && clickX <= slidingWidth*2 && clickY <= controllerY + controllerHeight - SLIDER_PADDING && clickY >= controllerY + SLIDER_PADDING;
  }
  public void resetControls() {
    currentValue = initialValue;
  }
  public void drawController(int controllerX, int controllerY, int controllerWidth, int controllerHeight) {

    this.controllerX = controllerX;
    this.controllerY = controllerY;
    this.controllerWidth = controllerWidth;
    this.controllerHeight = controllerHeight;
    float slidingWidth = controllerWidth*2.0/5.0;
    int actualX = int(mouseX - superMenuCoordinates.x);
    int actualY = int(mouseY - superMenuCoordinates.y);
    if (isPressed && mousePressed) {
      float newValue = (this.getMax()-this.getMin()) * (actualX - slidingWidth)/(slidingWidth) + this.getMin();
      this.setValue(round(newValue));
    } 
    fill(BACKGROUND_COLOR);
    rect(controllerX, controllerY, controllerWidth, controllerHeight);

    fill(HIGHLIGHTS_COLOR);
    rect(controllerX, controllerY, HIGHLIGHTS_WIDTH, controllerHeight);

    fill(TEXT_COLOR);
    textFont(textFont);
    String tempText = this.getControllerName();
    float nameArea = controllerWidth*2.0/5.0 - HIGHLIGHTS_WIDTH - TEXT_PADDING_LEFT;
    if (textWidth("...") > nameArea) {
    } else if (textWidth(tempText) > nameArea) {
      while (textWidth(tempText + "...") > nameArea && tempText.length()>0) {
        tempText = tempText.substring(0, tempText.length()-1);
      }
      tempText += "...";
    }
    text(tempText, controllerX + HIGHLIGHTS_WIDTH + TEXT_PADDING_LEFT, controllerY + controllerHeight/2.0 + TEXT_SIZE/4.0);

    //Hides Text Overflow
    fill(BACKGROUND_COLOR);
    rect(controllerWidth*2.0/5.0, controllerY, controllerWidth*3.0/5.0, controllerHeight);

    fill(SLIDER_BACKGROUND_COLOR);
    if (this.slidingWidthContains(mouseX - int(superMenuCoordinates.x), mouseY - int(superMenuCoordinates.y))) fill(HOVER_COLOR);
    rect(slidingWidth, controllerY + SLIDER_PADDING, slidingWidth, controllerHeight - SLIDER_PADDING*2);

    fill(HIGHLIGHTS_COLOR);
    rect(slidingWidth, controllerY + SLIDER_PADDING, round(slidingWidth * (this.getValue()-this.getMin())/(this.getMax()-this.getMin())), controllerHeight - SLIDER_PADDING*2);

//CurrentValue
    fill(HIGHLIGHTS_COLOR);
    textFont(textFont);
    text(this.getValue(), controllerWidth*4.2/5.0, controllerY + controllerHeight/2.0 + TEXT_SIZE/4.0);
  }
}