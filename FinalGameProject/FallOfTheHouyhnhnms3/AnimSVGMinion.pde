public class AnimSVGMinion extends AnimatedSVG {
  private float moveSpeed = 3;
  private float health = 1;
  private float attack = 1;
  private String teamName;  
  private color minionColor;
  private int targetID = -1;
  
  public AnimSVGMinion() {
  }
  public AnimSVGMinion(String fileLoc, float scale, Point startPoint, Point endPoint, int targetID, float animationTime, float moveSpeed, float health, float attack, String teamName, color minionColor) {
    this.fileLoc = fileLoc;
    this.scale = scale;
    this.startPoint = new Point(startPoint);
    this.endPoint = new Point(endPoint);
    this.targetID = targetID;
    this.animationTime = (animationTime > 0) ? animationTime : 1;
    this.moveSpeed = (moveSpeed > 0) ? moveSpeed : 3;
    this.health = (health > 0) ? health : 1;
    this.attack = (attack > 0) ? attack : 1;
    this.teamName = teamName;
    this.minionColor = minionColor;
    
    println("Loading Image: " + fileLoc);
    try {
      SVGImage = loadShape(fileLoc);
      SVGImage.scale(scale);
      imageLoaded = true;
      println("Image loaded sucessfully!");
      SVGImage.setFill(minionColor);
    }
    catch(Exception e) {
      println(e);
      println("ERROR: IMAGE \"" + fileLoc + "\" NOT LOADED CORRECTLY!");
    }
  }
  public AnimSVGMinion(PShape image, float scale, Point startPoint, Point endPoint, int targetID, float animationTime, float moveSpeed, float health, float attack, String teamName, color minionColor) {
    this.SVGImage = image;
    this.scale = scale;
    this.startPoint = new Point(startPoint);
    this.endPoint = new Point(endPoint);
    this.targetID = targetID;
    this.animationTime = (animationTime > 0) ? animationTime : 1;
    this.moveSpeed = (moveSpeed > 0) ? moveSpeed : 300;
    this.health = (health > 0) ? health : 1;
    this.attack = (attack > 0) ? attack : 1;
    this.teamName = teamName;
    this.minionColor = minionColor;
    SVGImage.setFill(minionColor);
    this.imageLoaded = true;
  }
  public float getAttack(){
    return attack;
  }
  public float getHealth(){
    return health;
  }
  public float getSpeed(){
    return moveSpeed;
  }
  public AnimSVGMinion clone(){
    return new AnimSVGMinion(SVGImage, scale, new Point(startPoint), new Point(endPoint), targetID, animationTime, moveSpeed, health, attack, teamName, minionColor);
  }
  public void setTargetID(int anID){
   this.targetID = anID; 
  }
  public int getTargetID(){
    return this.targetID;
  }
  public void setAnimationTime(float newTime){
    this.animationTime = newTime;
  }
  public void draw() {
    if (isRunning) {
      float timeSince = millis() - startTime;
      float distanceTot = distance(startPoint, endPoint);
      if (timeSince <= distanceTot/moveSpeed) {
        Point currPoint = new Point(animatePointLerp(startPoint, endPoint, (timeSince*moveSpeed)/distanceTot));
        if (imageLoaded) { 
          SVGImage.setFill(color(255,0,0));
          fill(255,0,0);
          shape(SVGImage, currPoint.x - (SVGImage.width*scale*0.5), currPoint.y - (SVGImage.height*scale*0.5));
        } else {
          stroke(0);
          strokeWeight(30);
          point(currPoint.x, currPoint.y);
        }
      } else isRunning = false;
    }
  }
    
}