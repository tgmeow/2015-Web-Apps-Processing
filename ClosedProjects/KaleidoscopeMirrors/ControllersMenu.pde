
public enum Position {
  TOP, TOP_RIGHT//,TOP_LEFT, RIGHT, LEFT, BOTTOM, BOTTOM_LEFT, BOTTOM_RIGHT
}

  public class ControllersMenu {

  PFont textFont;

  private final int TEXT_SIZE = 12;
  private final color TEXT_COLOR = color(214);
  private final int TEXT_PADDING_LEFT = 5;
  private Point menuCoordinates = new Point(); 
  //  private ArrayList<Controller> controllers = new ArrayList<Controller>();
  private java.util.TreeMap<String, Controller> controllers = new java.util.TreeMap<String, Controller>();
  private PolygonButton closeButton = new PolygonButton(0, 0, 0, 0);
  private boolean menuClosed = false;
  private boolean menuWasToggled = false;
  private boolean clickedOnLeftEdge = false;
  private final int EDGE_CLICK_MARGINS = 5;
  private Position position = Position.TOP_RIGHT;
  private int menuWidth = 100;
  private int controllersHeight = 30;
  private final boolean NO_STROKE = true;
  private final int FRAME_BORDER = 0;
  private final color BACKGROUND_COLOR = color(0);
  private final color HOVER_COLOR = color(17);
  private final color FRAME_COLOR = color(180);
  private final int CONTROLLERS_PADDING = 0;
  private final int HIDE_SIZE = 24;
  private final int CLOSE_BUTTON_PADDING = 1;
  private boolean menuReleased = true;

  public ControllersMenu() {
    textFont = createFont("Calibri", TEXT_SIZE);
  }
  public ControllersMenu(Position menuPosition, int menuWidth) {
    textFont = createFont("Calibri", TEXT_SIZE);
    this.position = menuPosition;
    this.menuWidth = menuWidth;
  }

  public void setMenuWidth(int newWidth) {
    this.menuWidth = newWidth;
  }
  public int getMenuWidth() {
    return this.menuWidth;
  }
  public int getMenuHeight() {
    return this.numberOfControllers() * controllersHeight + HIDE_SIZE + CONTROLLERS_PADDING*2*this.numberOfControllers();
  }
  public Position getMenuPosition() {
    return this.position;
  }
  public void setMenuPosition(Position newPosition) {
    this.position = newPosition;
    this.updateMenuPos(this.getMenuPosition());
  }
  public java.util.TreeMap<String, Controller> getControllers() {
    return new java.util.TreeMap<String, Controller>(controllers);
  }
  public int numberOfControllers() {
    return controllers.size();
  }
  public void addIntSlider(String name, int min, int max, int value) {
    controllers.put(name, new IntSlider(name, min, max, value, new Point(this.menuCoordinates)));
  }
  public void addFloatSlider(String name, float min, float max, float value, int accuracy) {
    controllers.put(name, new FloatSlider(name, min, max, value, new Point(this.menuCoordinates), accuracy));
  }
  public void addButtonController(String name, String label) {
    controllers.put(name, new ButtonController(name, label, new Point(this.menuCoordinates)));
  }
  public void addSwitchController(String name, String trueLabel, String falseLabel) {
    controllers.put(name, new SwitchController(name, trueLabel, falseLabel, new Point(this.menuCoordinates)));
  }
  public void setControllersHeight(int newHeight) {
    controllersHeight = newHeight;
  }
  public int getControllersHeight() {
    return controllersHeight;
  }
  public void closeMenu() {
    menuClosed = false;
    menuWasToggled = true;
  }
  public void openMenu() {
    menuClosed = false;
    menuWasToggled = true;
  }
  public void toggleMenu() {
    menuClosed = !menuClosed;
    menuWasToggled = true;
  }
  public void resetMenu() {
    for (Controller tempController : controllers.values()) {
      tempController.resetControls();
    }
  }

  public boolean clickOnLeftEdge(int clickX, int clickY, int plusMinus) {
    int clickedYChange = 0;
    if (clickedOnLeftEdge) clickedYChange = height*2;
    clickedOnLeftEdge = (clickX <= menuCoordinates.x+plusMinus && clickX >= menuCoordinates.x && clickY >= (menuCoordinates.y - clickedYChange) && clickY <= (menuCoordinates.y + this.getMenuHeight() + clickedYChange));
    return clickedOnLeftEdge;
  }
  private void updateMenuPos(Position newPos) {
    if (newPos == Position.TOP) {
      menuCoordinates = new Point(width/2-this.getMenuWidth()/2.0, -FRAME_BORDER);
    } else if (newPos == Position.TOP_RIGHT) { 
      menuCoordinates = new Point(width-this.getMenuWidth(), -FRAME_BORDER);
    }
    //else if (newPos == Position.TOP_LEFT) { 
    //  menuCoordinates = new Point(-FRAME_BORDER, -FRAME_BORDER);
    //} 
    //else if (newPos == Position.LEFT) { 
    // menuCoordinates = new Point(-FRAME_BORDER, (height/2.0)-(menuHeight/2.0));
    //}
    //else if (newPos == Position.RIGHT) {
    // menuCoordinates = new Point(width-this.getMenuWidth(), (height/2.0)-(menuHeight/2.0));
    //}
    //else if (newPos == Position.BOTTOM) {
    // menuCoordinates = new Point(width/2-(this.getMenuWidth()/2.0), height-menuHeight);
    //}
    //else if (newPos == Position.BOTTOM_LEFT) {
    // menuCoordinates = new Point(-FRAME_BORDER, height-menuHeight);
    //}
    //else if (newPos == Position.BOTTOM_RIGHT) {
    // menuCoordinates = new Point(width-this.getMenuWidth(), height-menuHeight);
    //}
    pushMatrix();
    translate(menuCoordinates.x, menuCoordinates.y);
    if (menuWasToggled) {
      rect(0, 0, this.getMenuWidth(), this.getMenuHeight());
    }
    popMatrix();

    if (menuClosed) menuCoordinates.y -= (this.getMenuHeight() - HIDE_SIZE);
    for (Controller tempController : controllers.values()) {
      tempController.updateMenuXY(menuCoordinates);
    }
  }

  public void clickManager(int clickX, int clickY) {
    menuReleased = false;
    int actualX = clickX - int(menuCoordinates.x);
    int actualY = clickY - int(menuCoordinates.y);
    if (closeButton.contains(actualX, actualY)) this.toggleMenu();
    for (Controller tempController : controllers.values()) {
      tempController.clickUpdate(actualX, actualY);
    }
  }
  public void pressManager(int clickX, int clickY) {
    if (menuReleased) this.clickOnLeftEdge(clickX, clickY, EDGE_CLICK_MARGINS);
    int actualX = clickX - int(menuCoordinates.x);
    int actualY = clickY - int(menuCoordinates.y);
    for (Controller tempController : controllers.values()) {
      tempController.pressUpdate(actualX, actualY);
    }
  }
  public void releaseManager(int clickX, int clickY) {
    menuReleased = true;
    int actualX = clickX - int(menuCoordinates.x);
    int actualY = clickY - int(menuCoordinates.y);
    for (Controller tempController : controllers.values()) {
      tempController.releaseUpdate(actualX, actualY);
    }
  }
  public boolean isMenuReleased() {
    return menuReleased;
  }
  public boolean clickOnMenu(int clickX, int clickY) {
    int actualX = clickX;
    int actualY = clickY;
    boolean state = (actualX >= menuCoordinates.x && actualX <= (menuCoordinates.x + menuWidth) && actualY >= menuCoordinates.y && actualY <= (menuCoordinates.y + this.getMenuHeight()));
    if (state) menuReleased = false;
    return state;
  }

  public void drawMenu() {
    if (clickedOnLeftEdge && mousePressed) {
      if (menuWidth < EDGE_CLICK_MARGINS) {
        menuWidth = EDGE_CLICK_MARGINS;
      }
      menuWidth -= (mouseX - pmouseX);
      if (position == Position.TOP) menuWidth -= (mouseX - pmouseX);
    } 

    ArrayList<Controller> temp = new ArrayList<Controller>(this.getControllers().values());
    int menuHeight = this.getMenuHeight();
    //drawBackground
    fill(BACKGROUND_COLOR);
    strokeWeight(FRAME_BORDER);
    stroke(FRAME_COLOR);
    if (NO_STROKE) noStroke();
    this.updateMenuPos(this.getMenuPosition());

    pushMatrix();
    translate(menuCoordinates.x, menuCoordinates.y);

    rect(0, 0, this.getMenuWidth(), menuHeight);
    int controllersWidth = this.getMenuWidth() - CONTROLLERS_PADDING*2;
    if (controllersWidth < 0) controllersWidth = 0;
    for (int index = 0; index < this.numberOfControllers(); index++) {
      temp.get(index).drawController(CONTROLLERS_PADDING, CONTROLLERS_PADDING*2*index + CONTROLLERS_PADDING + this.getControllersHeight()*index, controllersWidth, this.getControllersHeight());
    }
    int closeButtonWidth = controllersWidth - CLOSE_BUTTON_PADDING*2;
    if (closeButtonWidth < 0) closeButtonWidth = 0;
    closeButton = new PolygonButton(CONTROLLERS_PADDING + CLOSE_BUTTON_PADDING, menuHeight - HIDE_SIZE + CLOSE_BUTTON_PADDING, closeButtonWidth, HIDE_SIZE - CLOSE_BUTTON_PADDING*2 - CONTROLLERS_PADDING);

    fill(BACKGROUND_COLOR);
    if (closeButton.contains(mouseX - int(menuCoordinates.x), mouseY - int(menuCoordinates.y))) fill(HOVER_COLOR);
    closeButton.drawButton();

    fill(TEXT_COLOR);
    textFont(textFont);
    String openClose = (menuClosed)? "Open Controls" : "Close Controls";
    float textX = (textWidth(openClose) <= controllersWidth - CLOSE_BUTTON_PADDING*2 + TEXT_PADDING_LEFT) ? menuWidth/2.0 - textWidth(openClose)/2.0 : (CONTROLLERS_PADDING + CLOSE_BUTTON_PADDING + TEXT_PADDING_LEFT); 
    text(openClose, textX, menuHeight - HIDE_SIZE/2.0 - CLOSE_BUTTON_PADDING + TEXT_SIZE/3.0);

    popMatrix();
    menuWasToggled = false;
  }
}