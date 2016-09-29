public class ButtonController extends Controller {

  private PolygonButton button = new PolygonButton();
  private boolean currentValue = false;
  private String buttonLabel = "Null";

  private final color BUTTON_BACKGROUND_COLOR = color(48);
  private final int BUTTON_PADDING = 4;
  private final color HIGHLIGHTS_COLOR = color(30, 211, 111);

  private boolean initialValue = false;

  public ButtonController() {
    textFont = createFont("Calibri", TEXT_SIZE);
  }
  public ButtonController(String name, String buttonLabel, Point menuXY) {
    textFont = createFont("Calibri", TEXT_SIZE);
    this.name = name;
    this.buttonLabel = buttonLabel;
    this.superMenuCoordinates = new Point(menuXY);
    int slidingWidth = controllerWidth*2/5;
    button = new PolygonButton(slidingWidth, controllerY + BUTTON_PADDING, slidingWidth, controllerHeight - BUTTON_PADDING*2);
  }
  public Boolean getValue() {
    boolean temp = currentValue;
    currentValue = false;
    return temp;
  }
  private String getLabel(){
    return this.buttonLabel;
  }
  public void setSliderName(String newName) {
    this.name = newName;
  }
  public void setValue(boolean newValue) {
    this.currentValue = newValue;
  }
  public Object getReturnType() {
    return Float.class;
  }
  public void clickUpdate(int clickX, int clickY) {
    //currentValue = true;
  }
  public void pressUpdate(int clickX, int clickY) {
    isPressed = this.slidingWidthContains(clickX, clickY);
  }
  public void releaseUpdate(int clickX, int clickY) {
    if (isPressed) {
      currentValue = this.slidingWidthContains(clickX, clickY);
    }
    isPressed = false;
  }
  private boolean slidingWidthContains(int clickX, int clickY) {
    float slidingWidth = controllerWidth*2.0/5.0;
    return clickX >= slidingWidth && clickX <= slidingWidth*2 && clickY <= controllerY + controllerHeight - BUTTON_PADDING && clickY >= controllerY + BUTTON_PADDING;
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
    //if (isPressed && mousePressed) {
    //  float newValue = (this.getMax()-this.getMin()) * (actualX - slidingWidth)/(slidingWidth) + this.getMin();
    //  this.setValue((round(newValue * pow(10, accuracy))/pow(10, accuracy)));
    //} 
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

    //BUTTON
    fill(BUTTON_BACKGROUND_COLOR);  
    if (this.slidingWidthContains(mouseX - int(superMenuCoordinates.x), mouseY - int(superMenuCoordinates.y))) {
      fill(HOVER_COLOR);
      if(isPressed) fill(HIGHLIGHTS_COLOR);
    }
    //rect(slidingWidth, controllerY + BUTTON_PADDING, slidingWidth, controllerHeight - BUTTON_PADDING*2);
    button = new PolygonButton(int(slidingWidth), controllerY + BUTTON_PADDING, int(slidingWidth), controllerHeight - BUTTON_PADDING*2);
    button.drawButton();

    fill(HIGHLIGHTS_COLOR);
    //  rect(slidingWidth, controllerY + BUTTON_PADDING, round(slidingWidth * (this.peekValue()-this.getMin())/(this.getMax()-this.getMin())), controllerHeight - SLIDER_PADDING*2);

////CurrentValue
//    fill(HIGHLIGHTS_COLOR);
//    textFont(textFont);
//    text("" + this.peekValue(), controllerWidth*4.2/5.0, controllerY + controllerHeight/2.0 + TEXT_SIZE/4.0);
    
    fill(TEXT_COLOR);
    text(this.getLabel(), 1.5*int(slidingWidth) - 0.5*textWidth(this.getLabel()), controllerY + controllerHeight/2.0 + TEXT_SIZE/4.0);
  }
}