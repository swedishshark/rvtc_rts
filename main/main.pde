Drone[] playerDrones;
Drone[] enemyDrones;
Controller controller;

Colors colors = new Colors();
Globals globs = new Globals();
HUD hud = new HUD();
Grid grid = new Grid(3);
Panel[] panels = new Panel[3];


void settings () {

  size(int(globs.screen.x), int(globs.screen.y));
}

void setup() {
  
  frameRate(globs.frame_rate);
  setup_map();
  setup_drones();
  setup_panels();
  controller = new Controller();
  
}

void setup_drones() {
  
  rectMode(CENTER);
  
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
    int y = ((i + 1) * gapSize) + ((i) * globs.droneSize) + int(float(globs.droneSize) / 2.0);

    playerDrones[i]=new Drone(playerX, y, globs.droneSize, colors.player, i + 1);
    enemyDrones[i]=new Drone(enemyX, y, globs.droneSize, colors.enemy, i + 1);
    enemyDrones[i].move(randomPos());  
  }

}

void setup_map() {

  //set screen size and color
  background(colors.background);
  stroke(0, 0, 0);
  
  // end zones
  rectMode(CENTER);
  fill (colors.endZone);
  rect(globs.zoneCenter[0].x, globs.zoneCenter[0].y, int(globs.zone.x), int(globs.screen.y));
  rect(globs.zoneCenter[1].x - 1, globs.zoneCenter[1].y, globs.zone.x, globs.screen.y);
  
  //towers
  fill(colors.enemy);
  rect(globs.zone.x/2, globs.screen.y/2, 50, 50);
  fill(colors.player);
  rect(globs.screen.x - globs.zone.x/2, globs.screen.y/2, 50, 50);
  
} //<>//

void setup_panels() {
  
  panels[0] = hud.createPanel("Game Info");
  panels[1] = hud.createPanel("Unit Info");
  panels[2] = hud.createPanel("Targeting Info");
  
  //panels[0].data.set("Framerate", str(globs.frame_rate));
  panels[0].data.set("Game Speed", str(globs.frame_rate));
  
  panels[1].data.set("ID", "None");
  panels[1].data.set("Position", "()");
  panels[1].data.set("Speed", "None");
  panels[1].data.set("Direction", "()");
  panels[1].data.set("Destination", "()");
  panels[1].data.set("Orders", "None");
  panels[1].data.set("HP", "None");
  panels[1].data.set("Cells", "None");
  panels[1].span = 28 * panels[1].textSz;
  
  panels[2].data.set("Targets", "None");
  
}

//////////////////////////////////////////////////////////////
////        DRAW ROUTINES
//////////////////////////////////////////////////////////////
void draw(){
  setup_map();
  
  controller.update();
  
  for(int i=0; i<globs.droneCount; i++){
  
    enemyDrones[i].refresh();
    playerDrones[i].refresh();
  
  }
  
  grid.refresh();
  
  pushMatrix();
    translate(globs.screen.x - hud.width - 1, globs.screen.y - hud.height - 1);
    hud.refresh(panels);
  popMatrix();
  
}

///////////////////////////////////////////////////////////////
////      INPUT PROCESSING
///////////////////////////////////////////////////////////////

void mouseClicked(){

  controller.mouseClick();
  
}

//keypressed test
void keyPressed(){
    

    if (key == '=')
      globs.frame_rate = globs.frame_rate + 2;
        
      
    else if (key == '-')
      globs.frame_rate = globs.frame_rate - 2;
      
    else if (key == 'h') {
      hud.is_visible = !hud.is_visible;
      droneHudUp = hud.is_visible;
    }
    frameRate(globs.frame_rate);
    
    panels[0].data.set("Game Speed", str(globs.frame_rate));
    
    }   
  
  //////////////////////////////////////////////
  //// Misc
  /////////////////////////////////////////////
  
  Coordinate2 randomPos(){
    
    int xval = int(random(globs.playField[0].x, globs.playField[1].x));
    int yval = int(random(globs.playField[0].y, globs.playField[1].y));
    return new Coordinate2(xval, yval);
    
  }
