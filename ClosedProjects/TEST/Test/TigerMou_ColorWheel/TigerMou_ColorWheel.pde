/* * *
 * Tiger Mou
 * 3/17/2016
 * Dr. DeGennaro
 * THis program draws a color wheel and spins it. Use the keys 1 and 2 to change the spin speed
 * * */
float spinSpeed = 0;
float currAngle = 0;
float numSections = 500;
void setup(){
  size(800, 800);
  background(0);
  
}

void draw(){
  pushMatrix();
  background(0);
  translate(width/2.0, height/2.0);
  rotate(currAngle);
  currAngle+=spinSpeed;
  noStroke();
  colorMode(RGB);
  
  //for(int pieChunk = 1; pieChunk <= numSections; pieChunk++){
  //    fill(((float)pieChunk/numSections) * 255.0, 255, 255);
  //    if(pieChunk == 1) fill(125,255,0);
  //    if(pieChunk == 2) fill(0,255,0);
  //    if(pieChunk == 3) fill(0,255,125);
  //    if(pieChunk == 4) fill(0,255,255);
  //    if(pieChunk == 5) fill(0,125,255);
  //    if(pieChunk == 6) fill(0,0,255);
  //    if(pieChunk == 7) fill(125,0,255);
  //    if(pieChunk == 8) fill(255,0,255);
  //    if(pieChunk == 9) fill(255,0,125);
  //    if(pieChunk == 10) fill(255,0,0);
  //    if(pieChunk == 11) fill(255,125,0);
  //    if(pieChunk == 12) fill(255,255,0);
  //    arc(0, 0, height, height, (pieChunk-1)/numSections * TWO_PI, pieChunk/numSections*TWO_PI);
    
  //}
  colorMode(HSB);
  for(float pieChunk = 1; pieChunk <= numSections; pieChunk++){
    fill((float)pieChunk/numSections * 255.0,255,255);
    arc(0, 0, height, height, ((float)pieChunk-1.0)/numSections * TWO_PI, (float)pieChunk/numSections*TWO_PI);
  }
  
  popMatrix();
  fill(255);
  text("NEWTON'S COLOR WHEEL", 10, 10);
  text("Tiger Mou", 10, 25);
}

void keyPressed(){
  if(key == '1'){
   spinSpeed -= 0.01;
  }
  if(key == '2'){
   spinSpeed += 0.01;
  }
  if(key == '3'){
    if(numSections >=0) numSections -= 5;
  }
  if(key == '4'){
   numSections += 5;
  }
}