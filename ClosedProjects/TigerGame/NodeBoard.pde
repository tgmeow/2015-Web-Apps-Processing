public class NodeBoard {
  private int size = 0;
  //0 is no connection
  //1 is right
  //2 is down
  //3 is left
  //4 is up
  //[from][to]
  private Integer[][] board;
  ArrayList<Node> nodes = new ArrayList<Node>();
  private Occupant nextSet = null;
  private int lastSelection = -1;

  public NodeBoard() {
  }
  public NodeBoard(Integer[][] board) {
    this.size = board.length;
    this.board = board.clone();
  }
  public int size() {
    return size;
  }
  public boolean nodeConnects(int fromNode, int toNode) {
    return board[fromNode][toNode] != 0;
  }
  public ArrayList<Integer> nodeConnectsTo(int originNode) {
    ArrayList<Integer> connections = new ArrayList<Integer>();
    for(int indexTo = 0; indexTo < size; indexTo++){
      if(nodesDir(originNode, indexTo) != 0){
        connections.add(indexTo);
      }
    }
    return connections;
  }
  public int nodesDir(int fromNode, int toNode) {
    return board[fromNode][toNode];
  }
  public void add(Node aNode) {
    nodes.add(aNode.clone());
  }
  public void drawNodes(color strokeSelected, color strokeUnselected) {
    for (Node node : nodes) {
      if (node.isSelected) stroke(strokeSelected);
      else stroke(strokeUnselected);
      if (node.getOccupant() == Occupant.TIGER) fill(0, 0, 255);
      else if (node.getOccupant() == Occupant.LAMB) fill(255, 0, 0);
      else fill(0);
      node.draw();
    }
  }
  public void drawNodeConnections() {
    for (int from = 0; from < size; from++) {
      for (int to = 0; to < size; to++) {
        if (board[from][to] != 0) {
          line(nodes.get(from).getPos(), nodes.get(to).getPos());
        }
      }
    }
  }

  public void clickUpdate(int clickX, int clickY) {
    for (int index = 0; index < nodes.size(); index++) {
      if (nodes.get(index).contains(clickX, clickY)) {
        nodes.get(index).select();
        lastSelection = index;
        if (!occupantSet()){
          nodes.get(index).setOccupant(nextSet);
          nextSet = null;
        }
      } else nodes.get(index).unselect();
    }
  }
  public void unselectAll() {
    lastSelection = -1;
    for (Node node : nodes) {
      node.unselect();
    }
  }
  //public void setNextOccupant(Occupant occupant) {
  //  this.nextSet = occupant;
  //}
  public boolean occupantSet() {
   return nextSet == null;
  }
  public int getSelection(){
     return lastSelection;
  }
  public boolean hasEmptyNode(){
    for (Node node : nodes) {
      if(node.getOccupant() != null) return false;
    }
    return true;
  }
}