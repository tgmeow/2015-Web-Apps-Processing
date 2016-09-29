//class to create nodes on the screen using svg shapes. these shapes serve as the "houses" for the horses

public class PopNodeSVG {
  private PopNodeManager superManager;
  private ArrayList<AnimSVGMinion> activeMinions = new ArrayList<AnimSVGMinion>();
  private String fileLoc;
  private PShape SVGImage;
  private float scale;
  private boolean imageLoaded = false;
  private int popSize = 0;
  private int popGrowthSpeed; //(How many ms = +1)
  private float lastGrow = -1;
  private Point nodeLoc;
  private String teamName;  
  private color nodeColor;
  private boolean isPressed = false;
  private boolean isReleased = false;
  private float mousePMult = 1.2;

  private ArrayList<Integer> sendRemaining = new ArrayList<Integer>();
  private float lastSent = -1;
  private final int SEND_DELAY = 5; //ms between new minion


  //Pop Info (NEED TO ALSO PUT THIS IN THE ANIMATEDSVG CLASS)!!!!
  private AnimSVGMinion nodePopModel;

  //load svg shape, XY, curr population, add population, subtract population, set color, set team String, growth speed, update grow method
  //horse speed px/ms, health, attack

  public PopNodeSVG(PopNodeManager superManager, String fileLoc, float scale, Point nodeLoc, int initPopSize, int popGrowthSpeed, String teamName, color nodeColor, AnimSVGMinion nodePopModel) {
    this.superManager = superManager;
    this.fileLoc = fileLoc;
    this.scale = scale;
    this.nodeLoc = new Point(nodeLoc);
    this.popSize = initPopSize;
    this.popGrowthSpeed = popGrowthSpeed; 
    this.teamName = teamName;
    this.nodeColor = nodeColor;
    this.nodePopModel = nodePopModel.clone();
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
    this.lastGrow = millis();
  }
  public PopNodeSVG(PopNodeManager superManager, float scale, Point nodeLoc, int initPopSize, int popGrowthSpeed, String teamName, color nodeColor, AnimSVGMinion nodePopModel) {
    this.superManager = superManager;
    this.SVGImage = teamSVG("house", teamName);
    this.scale = scale;
    this.nodeLoc = new Point(nodeLoc);
    this.popSize = initPopSize;
    this.popGrowthSpeed = popGrowthSpeed;
    this.teamName = teamName;
    this.nodeColor = nodeColor;
    this.nodePopModel = nodePopModel.clone();

    imageLoaded = true;
    this.lastGrow = millis();
  }

  public void draw() {
    //GrowNode
    if (!teamName.matches("Neutral")) {
      if (millis()-lastGrow >= popGrowthSpeed) {
        lastGrow = millis();
        this.popSize++;
        //if (this.popSize < 0) {
        //  this.popSize = 0;
        //  this.teamName = "Neutral";
        //  this.SVGImage = teamSVG("house", "Neutral");
        //  //this.nodePopModel = aMinion.clone();
        //  sendRemaining.clear();
        //}
      }
    }
    if (imageLoaded) shape(SVGImage, nodeLoc.x - scale*SVGImage.width/2.0, nodeLoc.y - scale*SVGImage.height/2.0);
    else {
      stroke(0);
      strokeWeight(30);
      point(nodeLoc.x, nodeLoc.y);
    }

    //SendMinions
    //check if empty or not
    if (sendRemaining.size() > 0) {
      //remove finished pairs
      if (sendRemaining.get(0) <= 0) {
        sendRemaining.remove(0);
        sendRemaining.remove(0);
        lastSent = -1;
      }
    }
    //check if empty after removal
    if (popSize <=0) sendRemaining.clear();
    if (sendRemaining.size() > 0) {
      if (millis() - lastSent >= SEND_DELAY) {
        sendRemaining.set(0, sendRemaining.get(0) - 1);

        int targetID = sendRemaining.get(1);

        nodePopModel.setStartPoint(this.getNodeLoc());
        nodePopModel.setEndPoint(superManager.getNode(targetID).getNodeLoc());
        nodePopModel.setTargetID(targetID);

        activeMinions.add(nodePopModel.clone());
        activeMinions.get(activeMinions.size()-1).start();
        popSize--;
        if (lastSent == -1) lastSent = millis();
        else lastSent += SEND_DELAY;
      }
    }
    //draw the minions of the node
    for (int index = 0; index < activeMinions.size(); index++) {
      AnimSVGMinion tempMin = activeMinions.get(index);
      tempMin.draw();
      //if finished
      if (!tempMin.isRunning()) {
        superManager.getNode(tempMin.getTargetID()).visit(tempMin);
        activeMinions.remove(index);
      }
    }
    textAlign(CENTER, TOP);
    fill(40);
    text(popSize, nodeLoc.x+2, nodeLoc.y+1);
    fill(220);
    text(popSize, nodeLoc.x, nodeLoc.y);
  }
  public Point getNodeLoc() {
    return new Point(nodeLoc);
  }
  public boolean contains(Point aPoint) {
    int circleRadius = int(mousePMult*scale*SVGImage.height/2.0);
    float dist = sqrt((nodeLoc.x - aPoint.x)*(nodeLoc.x - aPoint.x) + (nodeLoc.y - aPoint.y)*(nodeLoc.y - aPoint.y));
    return dist <= circleRadius;
  }
  public void visit(AnimSVGMinion aMinion) {
    if (aMinion.teamName.matches(this.teamName)) {
      popSize++;
    } else {
      popSize -= (aMinion.getAttack() * aMinion.getHealth());
      //CHANGING NODE OWNERSHIP
      if (popSize <= 0) {
        this.popSize +=3;
        this.teamName = aMinion.teamName;
        this.SVGImage = teamSVG("house", aMinion.teamName);
        this.nodePopModel = aMinion.clone();
        sendRemaining.clear();
      }
    }
  }
  public void goTo(int aNodeIndex) {
    int inMotion = 0;
    for (int index = 0; index < sendRemaining.size(); index+=2) {
      inMotion += sendRemaining.get(index);
    }
    sendRemaining.add(round((popSize-inMotion)/2.0));
    sendRemaining.add(aNodeIndex);
  }
  public boolean isPressed() {
    if (isPressed) {
      isPressed = false;
      return true;
    } else return false;
  }
  public boolean isReleased() {
    if (isReleased) {
      isReleased = false;
      return true;
    } else return false;
  }
  public boolean selectTeam1() {
    if (teamName.matches("Team1")) {
      isPressed = true;
      return true;
    }
    return false;
  }
  public boolean updateMousePress(int pressX, int pressY) {
    if (teamName.matches("Team1")) {
      if (this.contains(new Point(pressX, pressY))) {
        isPressed = true;
        return true;
      }
    }
    return false;
  }
  public boolean updateMouseRelease(int releaseX, int releaseY) {
    if (this.contains(new Point(releaseX, releaseY))) {
      isReleased = true;
      return true;
    }
    return false;
  }
  public void resetMouse() {
    isPressed = false;
    isReleased = false;
  }
  public PopNodeSVG clone() {
    return new PopNodeSVG(superManager, fileLoc, scale, nodeLoc.clone(), popSize, popGrowthSpeed, teamName, nodeColor, nodePopModel.clone());
  }
  public int getPop() {
    return popSize;
  }
  public int getPopGrowth() {
    return popGrowthSpeed;
  }
}