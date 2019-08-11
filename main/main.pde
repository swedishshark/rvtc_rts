Drone[] playerDrones;
Drone[] enemyDrones;

Colors colors = new Colors();
Globals globs = new Globals();

void settings () {

  size(int(globs.screen.x), int(globs.screen.y));
}

void setup() {

  frameRate(globs.frame_rate);
  setup_map();
  setup_drones();
  
}

void setup_drones() {
  
  //initial drone positions
  int playerX = globs.screen.x - globs.zone.x - 30;
  int enemyX = globs.zone.x + 30;

  //create drone units
  playerDrones = new Drone[globs.droneCount];
  enemyDrones = new Drone[globs.droneCount];

  //gaps between drones
  int gapSize = (globs.screen.y - (globs.droneCount * globs.droneSize))/(globs.droneCount + 1);

  //generate drone geometry
  for (int i=1; i<=globs.droneCount; i++){
    int y = (i*gapSize) + ((i - 1) * globs.droneSize) + int(float(globs.droneSize) / 2.0);

    playerDrones[i-1]=new Drone(playerX, y, globs.droneSize, colors.player, i);
    enemyDrones[i-1]=new Drone(enemyX, y, globs.droneSize, colors.enemy, i);
  }

}

void setup_map() {

  //set screen size and color
  background(colors.background);
  
  // end zones
  fill (colors.endZone);
  rect(0, 0, int(globs.zone.x), int(globs.screen.y));
  rect(globs.screen.x - globs.zone.x, 0 , globs.zone.x, globs.screen.y);
  
  //towers
  rectMode(CENTER);
  fill(colors.enemy);
  rect(globs.zone.x/2, globs.screen.y/2, 50, 50);
  fill(colors.player);
  rect(globs.screen.x - globs.zone.x/2, globs.screen.y/2, 50, 50);
  
}

//////////////////////////////////////////////////////////////
////        DRAW ROUTINES
//////////////////////////////////////////////////////////////
void draw(){
  
  
  
  
}

///////////////////////////////////////////////////////////////
////      INPUT PROCESSING
///////////////////////////////////////////////////////////////

void mouseClicked(){
  
  if (droneSelected())
    return;
    
  moveOrder();
  
}

boolean droneSelected(){
  
//test to see if drone is hit
 for (int i=0; i<globs.droneCount; i++){
 
   if (playerDrones[i].is_hit(mouseX, mouseY)){
     playerDrones[i].is_active = !playerDrones[i].is_active;
     playerDrones[i].update();
     return true;
    
   }
 }  
 return false;

}

void moveOrder(){
  
   for (int i=0; i<globs.droneCount; i++){
     
     if (playerDrones[i].is_active)
       playerDrones[i].move(mouseX, mouseY);
   }
  
}
