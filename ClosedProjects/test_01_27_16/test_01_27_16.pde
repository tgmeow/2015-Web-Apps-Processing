void setup() {
  //size(500, 500);
  //surface.setResizable(true);
  fullScreen();
  // framerate() tells processing how many times per second
  // it should execute draw()
  //frameRate(60);
//  background(0, 0, 0);
}
int y1 = 0;
int y2 = 1;
int diff = 5;
void draw() {
  // background(random(155)+100, random(155)+100, random(155)+100);
  // background() erases the screen with a color
  //background(0, 0, 0);
  //stroke(0, 0, random(255));
  //line(0, 0, random(width), random(height) );
  //stroke(0, random(255), 0);
  //line(width, 0, random(width), random(height) );
  //stroke(random(255), 0, 0);
  //line(width, height, random(width), random(height) );
  //stroke(random(255), random(255), random(255));
  //line(0, height, random(width), random(height) );
  //color ellipseColor = color(random(255), random(255), random(255));
  //color ellipseColor = color(int(random(2))*255, int(random(2))*255, int(random(2))*255);
  //stroke(ellipseColor);
  //strokeWeight(0);
  //fill(ellipseColor, 100);
  //ellipse(random(width), random(height), random(height/4)+height/30, random(height/4)+height/30);
  //line(   random(width),random(height),   random(width),random(height)   );
    background(0);
  stroke(255);
  line(0, y1, width, y2);
  if(y1 >= height || y2 >= height) {
    y1 = 0;
    y2 = 0;
  }
  if(y1 % 2 == 1 && y2 % 2 == 1){
    y1+= diff;
  } if(y1 % 2 != 1 && y2 % 2 != 1){
    y1+= diff;
  }else{
    y2+= diff;
  }
}