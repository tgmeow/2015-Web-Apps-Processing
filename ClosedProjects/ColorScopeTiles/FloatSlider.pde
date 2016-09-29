public class FloatSlider extends Controller {

  private float min = 0;
  private float max = 1;
  private float currentValue = 0;
  private int accuracy = 0;
  private final int ACCURACY_MAX = 7;
  private final int ACCURACY_MIN = 0;

  private final color SLIDER_BACKGROUND_COLOR = color(48);
  private final int SLIDER_PADDING = 4;
  private final color HIGHLIGHTS_COLOR = color(30, 211, 111);

  private float initialValue = 0;
  private float initialMin = 0;
  private float initialMax = 0;

  public FloatSlider() {
    textFont = createFont("Calibri", TEXT_SIZE);
  }
  public FloatSlider(String name, float min, float max, float value, Point menuXY, int accuracy) {
    textFont = createFont("Calibri", TEXT_SIZE);
    this.name = name;
    this.min = min;
    this.max = max;
    this.setValue(value);
    this.superMenuCoordinates = new Point(menuXY);
    if (accuracy < ACCURACY_MIN) this.accuracy = ACCURACY_MIN;
    else if (accuracy > ACCURACY_MAX) this.accuracy = ACCURACY_MAX;
    else this.accuracy = accuracy;
    this.initialValue = value;
    this.initialMax = max;
    this.initialMin = min;
  }

  public float getMin() {
    return this.min;
  }
  public float getMax() {
    return this.max;
  }
  public float getRange() {
    return this.max - this.min;
  }
  public Float getValue() {
    return this.currentValue;
  }
  public void setSliderName(String newName) {
    this.name = newName;
  }
  public void setMin(float newMin) {
    this.min = newMin;
    this.setValue(this.getValue());
  }
  public void setMax(float newMax) {
    this.max = newMax;
    this.setValue(this.getValue());
  }
  public void setValue(float newValue) {
    if (newValue > this.getMax()) newValue = this.getMax();
    if (newValue < this.getMin()) newValue = this.getMin();
    this.currentValue = newValue;
  }
  public Object getReturnType() {
    return Float.class;
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
    this.min = initialMin;
    this.max = initialMax;
    this.currentValue = initialValue;
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
      this.setValue((round(newValue * pow(10, accuracy))/pow(10, accuracy)));
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
    text("" + this.getValue(), controllerWidth*4.2/5.0, controllerY + controllerHeight/2.0 + TEXT_SIZE/4.0);
  }
}