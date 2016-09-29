PShape horse;
void setup(){
  size(1280,720);
  horse = loadShape("horse.svg");
}

void draw(){
  pushMatrix();
  scale(580);
  shape(horse, 0, 0, 1, 1);
  
  popMatrix();
}