Drone[] playerDrones;
Drone[] enemyDrones;

Colors colors = new Colors();
Globals globs = new Globals();

void settings () {

  size(int(globs.screen.x), int(globs.screen.y));
}

void setup() {
  
  rectMode(CENTER);
  
  globs.my_fn(1.0);
  globs.my_fn(10);
 
  return
  
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
  for (int i=0; i<globs.droneCount; i++){
    int y = (i*gapSize) + ((i) * globs.droneSize) + int(float(globs.droneSize) / 2.0);

    playerDrones[i]=new Drone(playerX, y, globs.droneSize, colors.player, i + 1);
    enemyDrones[i]=new Drone(enemyX, y, globs.droneSize, colors.enemy, i + 1);
    
    Coordinate2 pos = randomPos();
    enemyDrones[i].move(pos.x, pos.y);
    
  
  }

}

void setup_map() {

  //set screen size and color
  background(colors.background);
  stroke(0, 0, 0);
  
  // end zones
  fill (colors.endZone);
  rect(globs.zoneCenter[0].x, globs.zoneCenter[0].y, int(globs.zone.x), int(globs.screen.y));
  rect(globs.zoneCenter[1].x, globs.zoneCenter[1].y, globs.zone.x, globs.screen.y);
  
  //towers
  fill(colors.enemy);
  rect(globs.zone.x/2, globs.screen.y/2, 50, 50);
  fill(colors.player);
  rect(globs.screen.x - globs.zone.x/2, globs.screen.y/2, 50, 50);
  
} //<>//

//////////////////////////////////////////////////////////////
////        DRAW ROUTINES
//////////////////////////////////////////////////////////////
void draw(){
  setup_map();
  for(int i=0; i<globs.droneCount; i++){
    playerDrones[i].update();
    enemyDrones[i].update();
  }
  
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
//keypressed test
void keyPressed(){
    
    println(key);
    
    if (key == '=')
      globs.frame_rate = globs.frame_rate + 1;
      
    if (key == '-')
      globs.frame_rate = globs.frame_rate - 1;
    
    frameRate(globs.frame_rate);
    }   
  
  //////////////////////////////////////////////
  //// Misc
  /////////////////////////////////////////////
  
  Coordinate2 randomPos(){
    
    int xval = int(random(globs.playField[0].x, globs.playField[1].x));
    int yval = int(random(globs.playField[0].y, globs.playField[1].y));
    return new Coordinate2(xval, yval);
    
  }
