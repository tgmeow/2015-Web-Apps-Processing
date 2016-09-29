/**
 * @title TangramGSSM
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Feb 4, 2016
 * @author Tiger Mou
 * Description: This program draws tangram shapes. The pieces of the tangram are dark and will randomly
 * flash with a lighter grey. When the pieces of the tangram shape are moused over,
 * they start shaking and mini tangram shapes will spawn at the mouse location. These mini tangram spawns will spin
 * in a random direction and initially move in a random direction and speed.Mousing over these mini tangram spawns
 * will create even smaller tangram spawns. The pieces of the mini tangram spawns will change colors upon mouseover.
 * The mini tangram spawns will bounce off of the left and right sides of the screen. "Gravity" will pull the spawns downward
 * until they fall off the screen. Once they fall off, they are removed from the program to clear up memory. 
 * If the tangram spawns was moving downwards during mouseover, it will "bounce" off and move upwards. The moving mini tangram spawns 
 * will leave streaks on the background. This is accomplished with a translucent rectangle drawn in the background every two
 * draw cycles instead of coloring the background a solid color. The top left of the screen will display the current
 * number of frames per second and the total number of active mini tangram spawns.
 * 
 * "DIAGNOSTICS"
 * I can guarantee that the shapes are the correct sizes and are in the correct locations because of the way each shape was made.
 * Each shape is made with a corner at the origin and is sized with unit lengths and square roots of 2.
 * The shape is translated using a matrix by moving the point at the origin and rotating the shape about that origin to wherever
 * the shape needs to be. The location of the shape was determined by using relative distances and positionings from an "origin" point.
 * This origin point was the top right angle corner of the spawns. The x coordinte of the shape below and touch it was determined by aligning
 * the X coordinates and by increasing the Y coordinate by the height of the triangle, which was calculated based on the unit length of the tangrams. 
 */

int frameCount = 0;  //counts the number of frames since the last time miniSpawns were spawned
ArrayList <TangShape> miniSpawns = new ArrayList<TangShape>();  //arraylist of the miniSpawn objects
PFont font;    //global font variable for the fps and miniSpawns counters

void setup() {
  //size(800, 600);
  fullScreen();  //fullscreen!
  noCursor();    //hides mouse cursor
  smooth(4);      //ensure antialiasing
  frameRate(60);  //sets framerate to 60
  font = createFont("Arial", 48);  //make a new font for the fps and spawn count
  background(0);      //set inital background color to black for that fade-in effect
}
void draw() {
  //CORNER TEXT
  fill(0);            //black rectangle in corner
  rect(0, 0, 45, 60);  //rectangle location
  fill(255);        //white text
  textFont(font, 22);  //font size 22
  text(int(frameRate), 5, 20);  //display framerate in the top
  text(miniSpawns.size(), 5, 50);    //display the number of live miniSpawns below that
  //BACKGROUND
  if (frameCount % 2 == 0) {              //redraw the "background" every two frames
    fill(255, 10);                        // a white translucent rectangle is the background
    rect(0, 0, width, height);
  }
  boolean drawBrock = true;    //Dr. Brockman!!!
  //SIZING VARIABLES
  int unit = 100;          //unit size for triangles
  int scale = 1;          //scale the miniSpawns! (DOES NOT WORK AS INTENDED)
  //MOVEMENT VARIABLES
  float gravity = 0.03;    //what is gravity
  float wind = 0;          //sideways "wind"
  float initMoveSize = 10;  //initial spawn move speed limit
  int shakeWeight = int(unit);      //how hard to shake the tangrams
  //COLOR of the MAIN tangram shape
  int mainTangR = 0;
  int mainTangG = 0;
  int mainTangB = 0;
  int mainTangA = 1;
  boolean mainFlashA = true; //flash the tiles alpha color
  //three MAIN tangrams!
  boolean gIsHovered = drawTangramG((unit*2.5), (unit * 2.0/3.0) + unit * (-sqrt(2) + 2.5), shakeWeight, unit, scale, false, 0, mainFlashA, mainTangR, mainTangG, mainTangB, mainTangA);
  boolean sIsHovered = drawTangramS((unit*2.0)+unit*(4.0-sqrt(2)), (unit * 2.0/3.0), shakeWeight, unit, scale, false, 0, mainFlashA, mainTangR, mainTangG, mainTangB, mainTangA);
  sIsHovered = drawTangramS((unit*2.0)+unit*(6.0-sqrt(2)), (unit * 2.0/3.0), shakeWeight, unit, scale, false, 0, mainFlashA, mainTangR, mainTangG, mainTangB, mainTangA) || sIsHovered;
  boolean mIsHovered = drawTangramM((unit*2.0)+unit*(10.0-sqrt(2)), (unit * 5.0/3.0), shakeWeight, unit, scale, false, 0, mainFlashA, mainTangR, mainTangG, mainTangB, mainTangA);

  //MINISPAWNS SPAWNS
  int firstSpawnSize = 14;  //size of spawns
  float rotationDiff = 4;    //rotation speed in degrees per frame of spawns
  if (int(random(2))==1) rotationDiff = -rotationDiff;  //make rotation speed either direction
  int spawnShakeWeight = 20;    //how hard to shake the spawns
  //COLOR OF SPAWNS
  int spawnTangR = 30;
  int spawnTangG = 30;
  int spawnTangB = 30;
  int spawnTangA = 30;
  boolean spawnFlashAOn = false; //flash the spawn alpha color

  //IF HOVERED AND EVERY THIRD FRAME COUNT
  if ((gIsHovered || sIsHovered || mIsHovered) && frameCount % 3 == 0) {
    //create a new spawn at the mouse location
    if (!drawBrock) {
      if (gIsHovered) {
        TangLetterG temp = new TangLetterG(mouseX, mouseY, spawnShakeWeight, firstSpawnSize, scale, random(initMoveSize)-(initMoveSize/2.0), random(initMoveSize)-(initMoveSize/2.0), true, rotationDiff, spawnFlashAOn, spawnTangR, spawnTangG, spawnTangB, spawnTangA);
        miniSpawns.add(temp);  //add the miniSpawn to the arraylist of miniSpawns
      }
      if (sIsHovered) {
        TangLetterS temp = new TangLetterS(mouseX, mouseY, spawnShakeWeight, firstSpawnSize, scale, random(initMoveSize)-(initMoveSize/2.0), random(initMoveSize)-(initMoveSize/2.0), true, rotationDiff, spawnFlashAOn, spawnTangR, spawnTangG, spawnTangB, spawnTangA);
        miniSpawns.add(temp);  //add the miniSpawn to the arraylist of miniSpawns
      }
      if (mIsHovered) {
        TangLetterM temp = new TangLetterM(mouseX, mouseY, spawnShakeWeight, firstSpawnSize, scale, random(initMoveSize)-(initMoveSize/2.0), random(initMoveSize)-(initMoveSize/2.0), true, rotationDiff, spawnFlashAOn, spawnTangR, spawnTangG, spawnTangB, spawnTangA);
        miniSpawns.add(temp);  //add the miniSpawn to the arraylist of miniSpawns
      }
    } else if (drawBrock) {
      TangPicBrock temp = new TangPicBrock(mouseX, mouseY, spawnShakeWeight, firstSpawnSize, scale, random(initMoveSize)-(initMoveSize/2.0), random(initMoveSize)-(initMoveSize/2.0), true, rotationDiff, spawnFlashAOn, spawnTangR, spawnTangG, spawnTangB, spawnTangA);
      miniSpawns.add(temp);  //add the miniSpawn to the arraylist of miniSpawns
    }
  }
  //DRAW EACH MINISPAWN IN THE ARRAYLIST
  for (int index = 0; index < miniSpawns.size(); index++) {
    TangShape aMiniTang = miniSpawns.get(index);
    //if the tangram is hovered over, is bigger that 1 unit large, and on every THIRD frame
    if (aMiniTang.isHovered() && aMiniTang.getUnitSize() >= 1 && frameCount % 3 == 0) {
      //if the miniSpawn is moving downwards, reverse the y direction
      //if (aMiniTang.getYDiff() > 0) aMiniTang.reverseYDiff(); 
      //create a new miniSpawn at the mouse location
      if (!drawBrock) {
        if (aMiniTang instanceof TangLetterG) {
          TangLetterG temp = new TangLetterG(mouseX, mouseY, spawnShakeWeight, int(aMiniTang.getUnitSize()/1.5), scale, random(initMoveSize)-(initMoveSize/2.0), random(initMoveSize)-(initMoveSize/2.0), true, rotationDiff, spawnFlashAOn, spawnTangR, spawnTangG, spawnTangB, spawnTangA);
          miniSpawns.add(temp);  //add the miniSpawn to the arraylist
        }
        if (aMiniTang instanceof TangLetterS) {
          TangLetterS temp = new TangLetterS(mouseX, mouseY, spawnShakeWeight, int(aMiniTang.getUnitSize()/1.5), scale, random(initMoveSize)-(initMoveSize/2.0), random(initMoveSize)-(initMoveSize/2.0), true, rotationDiff, spawnFlashAOn, spawnTangR, spawnTangG, spawnTangB, spawnTangA);
          miniSpawns.add(temp);  //add the miniSpawn to the arraylist
        }
        if (aMiniTang instanceof TangLetterM) {
          TangLetterM temp = new TangLetterM(mouseX, mouseY, spawnShakeWeight, int(aMiniTang.getUnitSize()/1.5), scale, random(initMoveSize)-(initMoveSize/2.0), random(initMoveSize)-(initMoveSize/2.0), true, rotationDiff, spawnFlashAOn, spawnTangR, spawnTangG, spawnTangB, spawnTangA);
          miniSpawns.add(temp);  //add the miniSpawn to the arraylist
        }
      } else if (drawBrock  && frameCount % 4 == 0) {
        TangPicBrock temp = new TangPicBrock(mouseX, mouseY, spawnShakeWeight, int(aMiniTang.getUnitSize()/1.5), scale, random(initMoveSize)-(initMoveSize/2.0), random(initMoveSize)-(initMoveSize/2.0), true, rotationDiff, spawnFlashAOn, spawnTangR, spawnTangG, spawnTangB, spawnTangA);
        miniSpawns.add(temp);  //add the miniSpawn to the arraylist of miniSpawns
      }
    }
    if (aMiniTang.getX() <=0 || aMiniTang.getX() >= width) aMiniTang.reverseXDiff();
    aMiniTang.updateDiff(wind, gravity); //update this miniSpawn speed with a delta for gravity and wind
    aMiniTang.drawThisTangram();  //draw the miniSpawn on the screen
    //if the miniSpawn is off the screen, remove it from the arraylist. Java's garbage collection should take care of it
    if (aMiniTang.getY()>height) miniSpawns.remove(index);
  }
  frameCount++;  //iterate framecount each draw
  if (frameCount >= 101) frameCount = 0;    //to prevent frameCount from overflowing
  color mouseColor = get(mouseX, mouseY);    //get the color under the mouse cursor
  stroke(255-red(mouseColor), 255-green(mouseColor), 255-blue(mouseColor));  //"reverse" the color
  strokeWeight(8);    //big strokes!
  line(pmouseX, pmouseY, mouseX, mouseY);    //create a line from the previous mouse location to the current
  noStroke();    //reset to no strokes for shapes!
}