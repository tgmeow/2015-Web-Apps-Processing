/* * *
 * Tiger Mou
 * 3/17/2016
 * Dr. DeGennaro
 * /* * *
 * Tiger Mou
 * 3/17/2016
 * Dr. DeGennaro
 * THis program draws a color wheel and spins it. Use the keys 1 and 2 to change the spin speed
 * * */
float spinSpeed = 0.05;
float currAngle = 0;
final float numSections = 13;

float strokeWeight = 5; 

void setup(){
  size(800, 800);
  background(255);
  
}

void draw(){
  pushMatrix();
  background(255);
  
  translate(width/2.0, height/2.0);
  rotate(currAngle);
  currAngle+=spinSpeed;
  strokeWeight(strokeWeight);
  colorMode(RGB);
  
  fill(0);
  stroke(0);
  arc(0, 0, height, height, 0, PI);
  fill(255);
  //for(int sectNum = 12; sectNum > 0; sectNum--){
  //  float  arcNum = abs((12.0-sectNum)%4.0);
  //    arc(0, 0, height*sectNum/numSections, height*sectNum/numSections,  PI + PI*(arcNum-1),PI + PI*(arcNum)); 
  //}
  arc(0, 0, height*12.0/numSections, height*12.0/numSections, PI, PI + PI*1.0/4.0);
  arc(0, 0, height*11.0/numSections, height*11.0/numSections, PI, PI + PI*1.0/4.0);
  arc(0, 0, height*10.0/numSections, height*10.0/numSections, PI, PI + PI*1.0/4.0);
  
  arc(0, 0, height*9.0/numSections, height*9.0/numSections, PI + PI*1.0/4.0, PI + PI*2.0/4.0);
  arc(0, 0, height*8.0/numSections, height*8.0/numSections, PI + PI*1.0/4.0, PI + PI*2.0/4.0);
  arc(0, 0, height*7.0/numSections, height*7.0/numSections, PI + PI*1.0/4.0, PI + PI*2.0/4.0);
  
  arc(0, 0, height*6.0/numSections, height*6.0/numSections, PI + PI*2.0/4.0, PI + PI*3.0/4.0);
  arc(0, 0, height*5.0/numSections, height*5.0/numSections, PI + PI*2.0/4.0, PI + PI*3.0/4.0);
  arc(0, 0, height*4.0/numSections, height*4.0/numSections, PI + PI*2.0/4.0, PI + PI*3.0/4.0);
  
  arc(0, 0, height*3.0/numSections, height*3.0/numSections, PI + PI*3.0/4.0, TWO_PI);
  arc(0, 0, height*2.0/numSections, height*2.0/numSections, PI + PI*3.0/4.0, TWO_PI);
  arc(0, 0, height*1.0/numSections, height*1.0/numSections, PI + PI*3.0/4.0, TWO_PI);

  
  popMatrix();
  fill(0);
  text("Benham's Disk", 10, 10);
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
   strokeWeight -= 0.5;
  }
  if(key == '4'){
   strokeWeight += 0.5;
  }
}