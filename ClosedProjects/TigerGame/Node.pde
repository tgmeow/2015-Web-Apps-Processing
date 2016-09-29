public enum Occupant{
  TIGER, LAMB
}
public class Node{
  private int id = 0;
  private Occupant occupant;
  private Point pos;
  private int size = 50; //CIRCLE WIDTH
  private boolean isSelected = false;
  
  public Node(){
  }
  public Node(int id, Occupant occupant, Point pos, int size){
    this.id = id;
    this.occupant = occupant;
    this.pos = new Point(pos);
    this.size = size;
  }
  
  public boolean isEmpty(){
    return (occupant == null);
  }
  public Point getPos(){
    return new Point(pos);
  }
  public void setID(int newID){
    this.id = newID;
  }
  public int getID(){
    return id;
  }
  public Occupant getOccupant(){
    return occupant;
  }
  public void setOccupant(Occupant newOccupant){
    this.occupant = newOccupant;
  }
  public void draw(){
    circle(pos, size);
  }
  public void select(){
    isSelected = true;
  }
  public void unselect(){
    isSelected = false;
  }
  public void toggleSelect(){
    isSelected = !isSelected;
  }
  public Node clone(){
    return new Node(this.id, this.occupant, new Point(pos), this.size);
  }
  public boolean contains(int pointX, int pointY){
    float diffX = pointX - this.pos.x;
    float diffY = pointY - this.pos.y;
    return sqrt(diffX * diffX + diffY * diffY) <= size/2.0;
  }
}