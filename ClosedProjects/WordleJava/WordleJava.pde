/**
 * @title Wordle
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Feb 6, 2016
 * @author Tiger Mou
 * Description: Java Wordle Generator.
 * Features: Zooming (scrolling), Panning (click and drag), click detection (console and bigger "brush")
 */
color mouseColor = color(100, 100, 100);
Point panXY = new Point();

int frameCount = 0;  //counts the number of frames
PFont cornerFont;    //global font variable for the fps and other counters
PFont wordFont;
final int wordFontSize = 18;
final int minFontSize = 10;
int wordColor = color(0, 0, 0);
final boolean enableMatrixMovement = true;
BufferedReader reader;
String readLine;
boolean placementFinished = false;
final static boolean enableDebugShapes = false;

float prevX = 0;
float prevY = 0;

//put first 50 (or less) words into an array of word objects
final int totalWantedWords = 50;
ArrayList<Word> wordObjects;
java.util.List<Word> drawnWordObjects = new ArrayList<Word>();
//java.util.List<Word> drawnWordObjects2 = new ArrayList<Word>();
int sumOfTotalMatches = 0;


Point mouseLocationPress;   //MouseLocations for drawing click and hold lines
Point mouseLocationRelease; //MouseLocations for drawing click and hold lines

void setup() {
  size(600, 600);  //windowsize
  //fullScreen();  //fullscreen!
  noCursor();    //hides mouse cursor
  smooth(4);      //ensure 4x antialiasing
  frameRate(60);  //sets framerate to 60
  cornerFont = createFont("Arial", 36);  //make a new font for the fps and spawn count
  wordFont = createFont("Arial", wordFontSize);
  background(255);      //set inital background color to black for that fade-in effect
  reader = createReader("wordleText5.txt");
  readWordsFromFile();
}

void draw() {
  //BACKGROUND
  background(255);
  if (frameCount % 2 == 0) {              //redraw the "background" every two frames
    noStroke();
    fill(255, 50);                        // a white translucent rectangle is the background
    rect(0, 0, width, height);
  }

  /*******************************************
   *           BEGIN DRAW CONTENTS           *
   *******************************************/
  pushMatrix();
  if (enableMatrixMovement) {
    
    translate(width/2.0, height/2.0);  //INITIALLY CENTER SCREEN AT "0,0"

    
    
    translateZoomScroll();

    rotate(radians(0));  //ROTATE ALL CONTENT
  }
  /*******************************************
   *               BEGIN WORDS               *
   *******************************************/
  //draw Words
  for (int i = drawnWordObjects.size()-1; i>=0; i--) {
    drawnWordObjects.get(i).drawWord();
  }

//draws a spiral and stuf for positions
  if (enableDebugShapes) {
    ////DRAW SPIRAL
    stroke(0);
    strokeWeight(1);
    int pos = 0;
    while (pos < 4000) {
      float x = pos * cos(radians(pos))/20.0;
      float y = pos * sin(radians(pos))/20.0;
      line(prevX, prevY, x, y);
      prevX = x;
      prevY = y;
      pos+=25;
    }
  }
  //DEBUGGING BOX INTERSECTIONS
  //   while(drawnWordObjects.get(1).wordIntersects(temp)){
  //   drawnWordObjects.get(1).setX(drawnWordObjects.get(1).getX()-1.0);
  //   println(drawnWordObjects.get(1).getX());
  //   }

  //   for(int i = 0; i < drawnWordObjects.size(); i++){
  //    Word aWord = drawnWordObjects.get(i);
  //    aWord.drawWord();
  //   ArrayList<Word> temp = new ArrayList<Word>(wordObjects);
  //   temp.remove(drawnWordObjects.get(1));

  // //   println(aWord.getText() + " " + aWord.wordIntersects(temp));
  //   }

//simple word placer
  // float xPrev = -width/2.0;
  // float yPrev = -height/3.0;
  // float space = 5;
  // for (int i = 0; i < wordObjects.size(); i++) {
  //   Word aWord = wordObjects.get(i);
  //   aWord.setX(xPrev);
  //   aWord.setY(yPrev);
  //   if (aWord.getPointBotR().x > width/2.0) {
  //     //println(aWord.getPointBotR().x);
  //     xPrev = -width/2.0;
  //     yPrev = aWord.getPointBotR().y + space;
  //     aWord.setX(xPrev);
  //     aWord.setY(yPrev);
  //   }
  //   aWord.drawWord();
  //   xPrev = aWord.getPointBotR().x + space;
  // }

  /*******************************************
   *                END WORDS                *
   *******************************************/
  popMatrix();

  /*******************************************
   *            END DRAW CONTENTS            *
   *******************************************/

  drawFPSCounter(); //CORNER TEXTS
  drawZoomCounter();

  /*******************************************
   *          MOUSE/WINDOW MANAGEMENT        *
   *******************************************/
  if (frameCount % 7 == 0) {              //lower mouse color sampling rate
    int newMouseColor = get(mouseX, mouseY);    //get the color under the mouse cursor
    //"Average" the mouse color
    mouseColor = color((red(newMouseColor)*0.9 + red(mouseColor)) / 1.9, (green(newMouseColor)*0.9 + green(mouseColor))/1.9, (blue(newMouseColor)*0.9 + blue(mouseColor))/1.9);
  }

  stroke(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));  //"reverse" the color
  if (mousePressed) {
    strokeWeight(38); //BIG Strokes!
    if (mouseButton == LEFT) {    //Pan the scene only if left click drag
      panXY.x += (mouseX - pmouseX);
      panXY.y += (mouseY - pmouseY);
    }
  } else strokeWeight(8);    //small strokes!
  line(pmouseX, pmouseY, mouseX, mouseY);  //Draw line 
  noStroke();    //reset mouse stroke

  frameCount++;  //iterate framecount each draw
  if (frameCount >= 100001) frameCount = 0;
}

void readWordsFromFile() {
  //WHILE THERE IS MORE TEXT, READ LINE
  java.util.HashMap<String, Integer> wordleWords = new java.util.HashMap<String, Integer>();  //Read-in map of wordleWords
  String [] dumbWordsToRemove =
    {
      "of", "am", "is", "are", "the", "so", "and", "in", "to", "as", "by", "from", "for", 
    "it", "or", "that", "was", "this", "with", "on", "be", "an", "has", "its", "these", 
    "he", "his", "had", "her", "him", "but", "you", "she", "if"
  };
  if (reader != null) {
    do {
      try {
        readLine = reader.readLine();
      } 
      catch (IOException e) {
        e.printStackTrace();
        readLine = null;
      }
      //If the read line is not null, then add the words to the TreeMap
      if (readLine != null) {
        //REMOVE NONALPHABETICALS
        readLine = readLine.replaceAll("[^\\dA-Za-z ]", " ");//.replaceAll("[()?:!.,;{}<>+]+", " ");
        String [] linePieces = split(readLine, " ");
        for (int i = 0; i < linePieces.length; i++) {
          String aWord = linePieces[i].toLowerCase();
          if (aWord.length() > 1) {
            int number = 0;
            if (wordleWords.containsKey(aWord)) number += wordleWords.get(aWord);
            wordleWords.put(aWord, number + 1);
          }
        }
      }
    } while (readLine != null);
  } else println("File not found!");
  try {
    reader.close();
  } 
  catch(IOException e) {
    e.printStackTrace();
    println("Could not close file!");
  }
  println("Read File Finished");
  for (String badWord : dumbWordsToRemove) { 
    wordleWords.remove(badWord);
  }  //REMOVE BAD WORDS FROM HASHMAP
  println(wordleWords.toString());
  println(wordleWords.size() + " unique words found.");

  //SORT THE HASH MAP
  ValueComparator vc =  new ValueComparator(wordleWords);
  java.util.TreeMap<String, Integer> sortedMapWords = new java.util.TreeMap<String, Integer>(vc); //Sorted map of wordleWords
  sortedMapWords.putAll(wordleWords);

  //SORTED WORDS!
  println(sortedMapWords.toString());

  //PUT SORTED WORDS INTO ARRAYLIST OF WORD OBJECTS
  ArrayList<String> theWordsKey = new ArrayList<String>(sortedMapWords.keySet());
  ArrayList<Integer> theWordsValues = new ArrayList<Integer>(sortedMapWords.values());
  wordObjects = new ArrayList<Word>();

  for (int i = 0; i < theWordsKey.size() && i < totalWantedWords; i++) {
    sumOfTotalMatches += theWordsValues.get(i);
    //println(i + " " + theWordsKey.get(i) + " " + theWordsValues.get(i));
    wordObjects.add(new Word((String)theWordsKey.get(i), theWordsValues.get(i), wordFont, minFontSize, 0.0, 0.0, 0.0, color(random(200), random(20), random(200))));
  }

  //Threading causes collision test problems :(
  //new Thread(new Runnable() {
   //public void run() {

  int theIndex = 0; //Place biggest word first
  for (int i = 0; wordObjects.size() > 0; i++) {
    boolean canDraw = false;

    Word thisWord = wordObjects.remove(theIndex);
    float pos = 0;
    float x = 0;
    float y = 0;
    float rotation = random(-90,90);
    int propFontSize = int((wordFontSize*50.0*(float)thisWord.getWordCount())/((float)sumOfTotalMatches));
    println(thisWord.getText() + ":\t " + thisWord.getWordCount() + " / " + sumOfTotalMatches + " = " + ((propFontSize < minFontSize) ? minFontSize : propFontSize));
    thisWord.setFontSize(propFontSize);

    while (!canDraw) {
      thisWord.setX(x);
      thisWord.setY(y);
      thisWord.setRotation(rotation);
      if (thisWord.wordIntersects(new ArrayList<Word>(drawnWordObjects))) {
        x = pos * cos(radians(pos))/20.0;
        y = pos * sin(radians(pos))/20.0;
        if (int(random(3)) != 0)
          pos+=5;
        else rotation = random(-90,90);
      } else {
        canDraw = true;
      }
    }
    println((i + 1) + " Words Placed!");
    drawnWordObjects.add(thisWord);

    //Increases chances of placing big words early
    theIndex = int(random(wordObjects.size()));
    if (int(random(2)) == 0) theIndex/=4;
  }
  placementFinished = true;
}
//Threading causes collision test problems :(
//  }
//  ).start();
//}

//OBJECTS PASS BY REFERENCE!
void animatePoint(Point originPoint, Point targetPoint, int framesLeft) {
  float deltaXLeftPerFrame = (targetPoint.x - originPoint.x)/framesLeft;
  float deltaYLeftPerFrame = (targetPoint.y - originPoint.y)/framesLeft;
  originPoint.x += deltaXLeftPerFrame;
  originPoint.y += deltaYLeftPerFrame;
}

void drawFPSCounter() { 
  noStroke();
  fill(0);            //black rectangle in corner
  rect(0, 0, 35, 30);  //rectangle location
  fill(255);        //white text
  textFont(cornerFont, 22);  //font size 22
  text(int(frameRate), 5, 20);  //display framerate in the top
}
void drawZoomCounter() { 
  noStroke();
  fill(0);            //black rectangle in corner
  int fpsWidth = 37;
  int fpsHeight = 25;
  rect(width-fpsWidth, height-fpsHeight, fpsWidth, fpsHeight);  //rectangle location
  fill(255);        //white text
  textFont(cornerFont, 18);  //font size 18
  text(int((float)zoom), width-fpsWidth+3, height - 5);  //display framerate in the top
}
void mouseClicked() {
  print("\nClicked: " + mouseX + ", " + mouseY);
}
void mousePressed() {
  mouseLocationPress = new Point(mouseX, mouseY);
  print("\nPressed: " + mouseX + ", " + mouseY);
}
void mouseReleased() {
  mouseLocationRelease = new Point(mouseX, mouseY);
  print("\nReleased: " + mouseX + ", " + mouseY);
  //stroke(0);
  //strokeWeight(8);
  //line(mouseLocationPress.x, mouseLocationPress.y, mouseLocationRelease.x, mouseLocationRelease.y);
  //noStroke();
}