public class PopNodeManager {
  ArrayList<Integer> pressedNodeIndex = new ArrayList<Integer>();
  ArrayList<PopNodeSVG> nodes = new ArrayList<PopNodeSVG>();


  public PopNodeManager() {
    pressedNodeIndex.clear();
  }

  public void addNode(PopNodeSVG aNode) {
    nodes.add(aNode);
  }
  public void drawNodes() {
    for (PopNodeSVG aNode : nodes) {
      aNode.draw();
    }
  }
  public void selectAllPossible() {
    for (int index = 0; index < nodes.size(); index++) {
        if(nodes.get(index).selectTeam1()) pressedNodeIndex.add(index);
    }
  }
  public void updateMousePress(int pressX, int pressY) {
    for (int index = 0; index < nodes.size(); index++) {
      if (nodes.get(index).updateMousePress(pressX, pressY)) {
        pressedNodeIndex.clear();
        pressedNodeIndex.add(index);
      }
    }
  }
  public void updateMouseRelease(int releaseX, int releaseY) {
    //if Something was selected
    if (pressedNodeIndex.size() > 0) {
      for (int index = 0; index < nodes.size(); index++) {
        //send release position
        if (nodes.get(index).updateMouseRelease(releaseX, releaseY)) {
          //if this node was released on
          for (int sendIndex : pressedNodeIndex) {
            if (sendIndex!=index) nodes.get(sendIndex).goTo(index);
          }
        }
      }
      pressedNodeIndex.clear();
    }
  }
  public void updateMousePos(int mousePosX, int mousePosY) {
    //if something was selected
    if (pressedNodeIndex.size() > 0) {
      for (int index = 0; index < nodes.size(); index++) {
        //if mouse is pressed and hovered over a node
        if (nodes.get(index).updateMousePress(mousePosX, mousePosY)) {
          //only add if does not alreay contain
          if (!pressedNodeIndex.contains(index)) pressedNodeIndex.add(index);
        }
      }
      stroke(230);
      strokeWeight(10);
      for (int sendIndex : pressedNodeIndex) {
        line(mousePosX, mousePosY, nodes.get(sendIndex).getNodeLoc());
      }
    }
  }
  public PopNodeSVG getNode(int index) {
    return nodes.get(index);
  }
  public  ArrayList<PopNodeSVG> getNodes() {
    return nodes;
  }
}

public PShape teamSVG(String type, String teamName) {
  //team 1 = grey60
  //team 2 = maroon
  //neutral = white

  if (type.matches("horse")) {
    if (teamName.matches("Team1")) {
      return horseGrey60;
    } else if (teamName.matches("Team2")) {
      return horseMaroon;
    } else if (teamName.matches("Neutral")) {
      return horseGrey20;
    }
  } else if (type.matches("house")) {
    if (teamName.matches("Team1")) {
      return houseGrey60;
    } else if (teamName.matches("Team2")) {
      return houseMaroon;
    } else if (teamName.matches("Neutral")) {
      return houseGrey20;
    }
  }
  return horseWhite;
}