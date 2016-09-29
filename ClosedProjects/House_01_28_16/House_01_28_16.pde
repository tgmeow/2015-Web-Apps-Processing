/* @title:   House_01_28_16
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * @author:  Tiger Mou
 * Description: This program draws a house with two trees, a ground, and a shaking sun.
 *              The house, trees, and ground rotate around the center of the sun.
 */
void setup()
{
  size(700, 400); //size of the window
  smooth(4);      //make sure antialiasing is enabled
}
float x = 0;           //rotation count
int shakeWeight = 10;  //how hard to shake the sun
void draw()
{
  stroke(1);            //shape border
  background(122, 118, 255);  ///the sky is blue
  pushMatrix();          //matrix for spinning everything
  translate(350, 25);      //move the grid to the sun
  rotate(radians(x));    //rotate everything
  translate(-350, -25);    //put the grid "back"

  //draw the sun!
  pushMatrix();    //matrix for shaking the sun
  translate(random(shakeWeight)-(shakeWeight/2.0), random(shakeWeight)-(shakeWeight/2.0)); //translate the sun according to a random value calculated by the shake weight

  drawSun(350, 25, 1);     //draw the sun at x, y, scale
  popMatrix();    //remove sun shaking matrix

  //ground
  fill(6, 156, 0);          //the ground is green
  ellipse(350, 1150, 1850, 1800);    //make a big ellipse to be the ground

  pushMatrix();        //new matrix!

  //House body
  fill(120, 35, 45);        //this is the house color
  rect(200, 150, 300, 150);    //house body is rectangle
  //House roof
  fill(30, 25, 35);          //roof is darker
  triangle(165, 150, 535, 150, 350, 75);  //roof is a triangle
  //window(s)
  drawWindow(225, 175, 1);    //draw windows at x, y, scale
  drawWindow(420, 175, 1);    //draw windows at x, y, scale

  popMatrix();            //pop the matrix!
  int doorWidth = 50;      //door sizing
  int doorHeight = 100;    //door sizing
  fill(100, 15, 25);          //door color!
  rect(350 - (doorWidth/2), 300-doorHeight, doorWidth, doorHeight);  //door is mathed at center of house
  //tree(s)
  drawTree(650, 125, 3);      //trees are centered at x, y, scale
  drawTree(50, 125, 3);      //trees are centered at x, y, scale
  float yass = (mouseX-(width/2.0))/20.0;     //rotation is equal to mouse x squared
  x+=(yass * abs(yass));             //change rotation
  popMatrix();                // pop spinning matrix
}
/* 
 * function to draw the sun centered at x, y, and scales the sun
 * @param x  x location of the center of the sun
 * @param y  y location of the center of the sun
 * @param scale scale size of the sun
 */
void drawSun(int x, int y, int scale) {
  pushMatrix();    //matrix for positioning scaling sun
  translate(x, y);  //move the sun
  scale(scale);    //scale the sun
  //SunCenter
  fill(255, 234, 0);    //sun is color
  ellipse(0, 0, 50, 50);  //draw sun
  //Sun "glow" (I played around with the colors and things until it looked good)
  int colorR = 255;
  int colorG = 234;
  int colorB = 0;
  //gradient colors of circles
  noStroke();
  for (int radius = 500; radius >= 300; radius-=4) {
    //Sun outer ring
    int secondRad = radius - 350;
    fill(179-(((179-122)/25)*(secondRad)/4), 158-(((158-118)/25)*(secondRad)/4), 95-(((95-255)/25)*(secondRad)/4), ((float)(-radius)+400) * 100.0 / 400.0);
    //background(122,118,255);
    ellipse(0, 0, radius, radius);
  }
  //Sun inner portion (gradient colors of circles)
  for (int radius = 300; radius >= 0; radius-=5) {
    noStroke();
    //change the color of the sun each draw
    fill(colorR - (radius * 255 / 1000), colorG - (radius * 255 / 1000), colorB + (radius * 255 / 800), ((float)(-radius)+250) * 255.0 / 300.0);
    ellipse(0, 0, radius, radius);
  }
  popMatrix();
  stroke(1); //reset to 1
}
/**
 * function to draw the window centered at x, y, and scales the window
 * @param x  x location of the top left corner of the window
 * @param y  y location of the top left corner of the window
 * @param scale scale size of the window
 */
void drawWindow(int x, int y, int scale) {
  pushMatrix();    //matrix for positioning, scaling windows
  translate(x, y);  //move window
  scale(scale);    //scale window
  fill(100, 15, 25);  //window color
  //window rectangle
  rect(0, 0, 55, 75);  //window is a rectangle
  popMatrix();
}

/**
 * function to draw the tree centered at x, y, and scales the tree
 * @param x  x location of the center of the tree
 * @param y  y location of the center of the tree
 * @param scale scale size of the tree
 */
void drawTree(int x, int y, int scale) {
  pushMatrix();    //matrix for positioning, scaling trees
  translate(x, y);  //position the tree
  scale(scale);    //scale the tree
  //trunk
  int trunkWidth = 4;  //width of the trunk
  fill(194, 68, 0);      //trunk color
  rect(0-(trunkWidth/2), 0, trunkWidth, 70);    //center the trunk at the x y location

  fill(6, 186, 0);      //leaves are green
  ellipse(0, 0, 20, 60);  //center ellipse at xy, sizing
  popMatrix();
}