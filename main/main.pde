Drone[] playerDrones;
Drone[] enemyDrones;
int droneCount = 10;
int frame_rate = 20;

void setup() {
  int screenWidth = 1280;
  int screenHeight = 720;
  int zoneWidth = int(float(screenWidth) * 0.1);
  int playerX = screenWidth - zoneWidth - 30;
  int enemyX = zoneWidth + 30;
  int droneSize = 10;
  color playerColor = color(0, 0, 255);
  color enemyColor = color(255, 0, 0);
  
  frameRate(frame_rate);

  size(1280, 720);
  background(50, 150, 50);
  fill (100, 100, 100);
  //endzones
  rect(0, 0, zoneWidth, screenHeight);
  rect(screenWidth - zoneWidth, 0 , zoneWidth, screenHeight);
  //towers
  rectMode(CENTER);
  fill(enemyColor);
  rect(zoneWidth/2, screenHeight/2, 50, 50);
  fill(playerColor);
  rect(screenWidth - zoneWidth/2, screenHeight/2, 50, 50);
  playerDrones = new Drone[droneCount];
  enemyDrones = new Drone[droneCount];
  int gapSize = (screenHeight - (droneCount * droneSize))/(droneCount + 1);
  //complicated crap
  for (int i=1; i<=droneCount; i++){
    int y = (i*gapSize) + ((i - 1) * droneSize) + int(float(droneSize) / 2.0);
    print(i, gapSize, droneSize, y);
    print("\n");
    playerDrones[i-1]=new Drone(playerX, y, droneSize, playerColor, i);
    enemyDrones[i-1]=new Drone(enemyX, y, droneSize, enemyColor, i);
  }
}

void draw(){
  
  
  
  
}

void mouseClicked(){
  
  if (droneSelected())
    return;
    
  moveOrder();
  
}

boolean droneSelected(){
  
//test to see if drone is hit
 for (int i=0; i<droneCount; i++){
 
   if (playerDrones[i].is_hit(mouseX, mouseY)){
     playerDrones[i].is_active = !playerDrones[i].is_active;
     playerDrones[i].update();
     return true;
    
   }
 }  
 return false;

}

void moveOrder(){
  
   for (int i=0; i<droneCount; i++){
     
     if (playerDrones[i].is_active)
       playerDrones[i].move(mouseX, mouseY);
   }
  
}
