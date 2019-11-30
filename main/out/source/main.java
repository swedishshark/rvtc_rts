import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main extends PApplet {

Drone[] playerDrones;
Drone[] enemyDrones;
Controller controller;

Colors colors = new Colors();
Globals globs = new Globals();
HUD hud = new HUD();
Panel[] panels = new Panel[2];


public void settings () {

  size(PApplet.parseInt(globs.screen.x), PApplet.parseInt(globs.screen.y));
}

public void setup() {
  
  frameRate(globs.frame_rate);
  setup_map();
  setup_drones();
  setup_panels();
  controller = new Controller();
  
}

public void setup_drones() {
  
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
    int y = ((i + 1) * gapSize) + ((i) * globs.droneSize) + PApplet.parseInt(PApplet.parseFloat(globs.droneSize) / 2.0f);

    playerDrones[i]=new Drone(playerX, y, globs.droneSize, colors.player, i + 1);
    enemyDrones[i]=new Drone(enemyX, y, globs.droneSize, colors.enemy, i + 1);
  
  }

}

public void setup_map() {

  //set screen size and color
  background(colors.background);
  stroke(0, 0, 0);
  
  // end zones
  rectMode(CENTER);
  fill (colors.endZone);
  rect(globs.zoneCenter[0].x, globs.zoneCenter[0].y, PApplet.parseInt(globs.zone.x), PApplet.parseInt(globs.screen.y));
  rect(globs.zoneCenter[1].x - 1, globs.zoneCenter[1].y, globs.zone.x, globs.screen.y);
  
  //towers
  fill(colors.enemy);
  rect(globs.zone.x/2, globs.screen.y/2, 50, 50);
  fill(colors.player);
  rect(globs.screen.x - globs.zone.x/2, globs.screen.y/2, 50, 50);
  
} //<>//

public void setup_panels() {
  
  panels[0] = hud.createPanel("Game Info");
  panels[1] = hud.createPanel("Unit Info");
  
  //panels[0].data.set("Framerate", str(globs.frame_rate));
  panels[0].data.set("Game Speed", str(globs.frame_rate));
  
  panels[1].data.set("ID", "None");
  panels[1].data.set("Position", "()");
  panels[1].data.set("Speed", "None");
  panels[1].data.set("Direction", "()");
  panels[1].data.set("Destination", "()");
  panels[1].data.set("Orders", "None");
  panels[1].data.set("HP", "None");
  
  int a = 10;
  int b = a;
  
  Coordinate2 c = new Coordinate2(20, 30);
  Coordinate2 d = c;
  
  a = 20;
  c.x = 57;

  println(a);
  println(b);
  println(c.dump());
  println(d.dump());
  
}

//////////////////////////////////////////////////////////////
////        DRAW ROUTINES
//////////////////////////////////////////////////////////////
public void draw(){
  setup_map();
  
  controller.update();
  
  for(int i=0; i<globs.droneCount; i++){
  
    enemyDrones[i].refresh();
    playerDrones[i].refresh();
  
  }
  
  
  pushMatrix();
    translate(globs.screen.x - hud.width - 1, globs.screen.y - hud.height - 1);
    hud.refresh(panels);
  popMatrix();
  
}

///////////////////////////////////////////////////////////////
////      INPUT PROCESSING
///////////////////////////////////////////////////////////////

public void mouseClicked(){

  controller.mouseClick();
  
}

//keypressed test
public void keyPressed(){
    

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
  
  public Coordinate2 randomPos(){
    
    int xval = PApplet.parseInt(random(globs.playField[0].x, globs.playField[1].x));
    int yval = PApplet.parseInt(random(globs.playField[0].y, globs.playField[1].y));
    return new Coordinate2(xval, yval);
    
  }
class HUD {
  

  boolean is_visible = false;

  int width = 1279;
  int height = 150;

  int leftMargin = 5;
  int topMargin = 5;
  
  int textSz = 15;
  
  HUD(){

  }
  
  public void refresh(Panel[] panels){
   
   if (!is_visible)
     return;
     
   rectMode(CORNER);
   
   //hud background
    stroke (0, 0, 0);
    fill(0, 0, 0, 100);
    rect(0, 0, width, height);
    int x = 0;
    
    // hud panels
    fill(0, 0, 0, 255);
    translate(leftMargin, topMargin);
    
    for (Panel panel : panels) {
      translate(x, 0);
      panel.update();
      x += textSz * 13 * 2 + 5;
    }
  }
  
  public Panel createPanel(String header){
    
    Panel p = new Panel();
    p.header = header;
    return p;
    
    
    
  }
  
}
class BoundingBox{

  int left;
  int right;
  int top;
  int bottom;
  int halfx;
  int halfy;
  int sizeX;
  int sizeY;
  
  BoundingBox(int x1, int y1, int x2, int y2){
  
    left = x1;
    right = x2;
    top = y1;
    bottom = y2;
    sizeX = x2 - x1;
    sizeY = y2 -y1;
    halfx = sizeX/2;
    halfy = sizeY/2;
  }
  
  BoundingBox(int x, int y, int size){
  
    left = x - size/2;
    right = x + size/2;
    top = y + size/2;
    bottom = y - size/2;
    sizeX = size;
    sizeY = size;
    halfx = sizeX/2;
    halfy = sizeY/2;
  }
  
  public boolean collide(BoundingBox box){
  
    if (box.left > this.right)
      return false;
    if (box.right < this.left)
      return false;
    if (box.top < this.bottom)
      return false;
    if (box.bottom > this.top)
      return false;  
    return true;
  }
  
  public void update(PVector center){
  
    update(PApplet.parseInt(center.x), PApplet.parseInt (center.y));
    
  }
  
  public void update(int x, int y){
  
    left = x - halfx;
    right = x + halfx;
    top = y + halfy;
    bottom = y - halfy;
    
  }
  
  public void refresh(){

    rectMode(CORNERS);

    stroke(0, 0, 0);
    fill(0, 0, 0, 100);
    rect(this.left, this.top, this.right, this.bottom);

  }

}

  class Colors {
    int background = color(50, 150, 50);
    int endZone = color(100, 100, 100);
    int player = color(0, 0, 255);
    int enemy = color(255, 0, 0);
  }
class Controller{

  Controller(){
  
  
  
  }
  
  public void update(){
    
    for(int i=0; i<globs.droneCount; i++){
      playerDrones[i].update();
      enemyDrones[i].update();
    
      if (!enemyDrones[i].is_moving)    
        enemyDrones[i].move(randomPos());  
    }
  }
  
  public void mouseClick(){
  
    if (droneSelected())
      return;
    
    moveOrder();
  }

  public boolean droneSelected(){
  
    boolean drone_selected = false;
    
    int picked_id = -1;
    
  //test to see if drone is hit
   for (int i=0; i<globs.droneCount; i++){
   
     if (playerDrones[i].is_hit(mouseX, mouseY)){
       
       Drone drone = playerDrones[i];
       drone.is_active = !drone.is_active;
       
       if (drone.is_active){
         picked_id = i;     
       }
    
       drone_selected = true;
       break;  
     }
   }
   
   int id = -1;
   int hudID = PApplet.parseInt(panels[1].data.get("ID"));
   println(hudID);
   if (picked_id > -1)
     id = picked_id;
   
   else if (playerDrones[hudID].is_active){
    
     id = hudID;
     
   }
     
   else {
     
     for (int i=0; i<globs.droneCount; i++){
      
       if (playerDrones[i].is_active){
         
         id = i;
         
       }
       
     } 
   }
   if (id == -1) {
     
    panels[1].data.set("ID", "-1");
    panels[1].data.set("Position", "()");
    panels[1].data.set("Speed", "None");
    panels[1].data.set("Direction", "()");
    panels[1].data.set("Destination", "()"); 
    panels[1].data.set("Orders", "None"); 
    panels[1].data.set("HP", "None");
    
   } else {
     
    Drone drone = playerDrones[id];
    panels[1].data.set("ID", str(id));
    panels[1].data.set("Position", "(" + str(drone.position.x) + "," + str(drone.position.y)  + ")");
    panels[1].data.set("Speed", str(drone.speed));
    panels[1].data.set("Direction", "(" + str(drone.direction.x) + "," + str(drone.direction.y)  + ")");
    panels[1].data.set("Destination", "(" + str(drone.destination.x) + "," + str(drone.destination.y)  + ")");
    panels[1].data.set("Orders", "Move");
    panels[1].data.set("HP", str(drone.health));
   }
   
   return drone_selected;
  
  }
  
  public void moveOrder(){
    
     for (int i=0; i<globs.droneCount; i++){
       
       if (playerDrones[i].is_active)
         playerDrones[i].move(mouseX, mouseY);
     }
     
  
  }

}
class Coordinate2 {
  
  int x = 0;
  int y = 0;
  
  Coordinate2(int x_val, int y_val) {
  
      x = x_val;
      y = y_val;
    
  }
  
  public String dump() {
    return ("(" + str(x) + ", " + str(y) + ")");
  }
}

boolean droneHudUp = false;

class Drone {

  //Metadata
  //--------------------
  int team;
  int size;
  int halfsize;
  int idNumber;
  BoundingBox hitBox;
  BoundingBox sightBox;
  BoundingBox shootingBox;

  //Vectors
  //----------------------
  PVector position;
  PVector destination = new PVector();
  PVector direction = new PVector();
 
  //Action
  //--------------------
  boolean is_active = false;
  boolean is_moving = false;
  
  //Stats
  //-------------------
  int health = 0;
  float sightRange = 80.5f;
  float shootingRange = 50.5f;
  int fireRate = 2;
  float bulletSpeed = 16;
  float bulletDamage = 5;
  //feet per second
  float speed = 4;
  
  //frame-feet per second
  float delta = speed / PApplet.parseFloat(globs.frame_rate);


  
  Drone(int x, int y, int s, int c, int id){
    position = new PVector(x, y);
    team = c;
    size = s;
    halfsize = size/2;
    idNumber = id;
    this.update();
    hitBox = new BoundingBox(x, y, size);
    sightBox = new BoundingBox(x, y, PApplet.parseInt(sightRange));
    shootingBox = new BoundingBox(x, y, PApplet.parseInt(shootingRange));
  }
  
  public void update(){
    
    if(!is_moving)
      return;
      
    position = PVector.add(direction, position);
    float d = position.dist(destination); 
    is_moving = (d > 2.0f*delta); //<>//
    hitBox.update(position);
    sightBox.update(position);
    shootingBox.update(position);
  }
  
  public void refresh(){
  
    rectMode (CENTER);
    fill(team);
    stroke(team);
    
    if (is_active)
      stroke(255, 255, 0);
    
    square(position.x, position.y, PApplet.parseFloat(size));
    if (droneHudUp){
      hitBox.refresh(); 
      sightBox.refresh(); 
      shootingBox.refresh(); 
  }
  }
  
  public void move(Coordinate2 pos) {
    
    this.move(pos.x, pos.y);
 
  }
  
  public void move(int x, int y) {
    
    destination = new PVector(x, y);
    direction = PVector.sub(destination, position);
    direction.normalize();
    direction.mult(delta);
    
    is_moving = true;
  }
  
  public boolean is_hit(int x, int y) {
    
    //left side
    if (x < position.x - halfsize)
      return false;
    
    //right side
    if (x > position.x + halfsize)
      return false;
    
    //top side
    if (y > position.y + halfsize)
      return false;
    
    //bottom side
    if (y < position.y - halfsize)
      return false;
      
    return true;
  }
   
}
class Globals {
  
  int droneCount = 10;
  int frame_rate = 20;

  Coordinate2 screen = new Coordinate2(1280, 720);
  Coordinate2 zone = new Coordinate2(PApplet.parseInt(PApplet.parseFloat(screen.x) * 0.1f), screen.y);
  Coordinate2[] zoneCenter = new Coordinate2[2];
  Coordinate2[] playField = new Coordinate2[2];

  int playerX = PApplet.parseInt(screen.x) - PApplet.parseInt(zone.x) - 30;
  int enemyX = PApplet.parseInt(zone.x) + 30;
  int droneSize = 10;

  Globals(){
    
    this.zoneCenter[0] = new Coordinate2(this.zone.x/2, this.screen.y/2); //<>//
    this.zoneCenter[1] = new Coordinate2(this.screen.x - this.zone.x/2, this.screen.y/2);
    this.playField[0] = new Coordinate2(this.zone.x, 0);
    this.playField[1] = new Coordinate2(this.screen.x - this.zone.x, this.screen.y);
    
  } //<>//
  
  public void my_fn(float x) {
    println("passed float", x);
  }
  
  public void my_fn(int x) {
    println("passed int", x);
  }
}

class Panel {
  
  String header;
  StringDict data = new StringDict();
  int textSz = 20;
  int columnSpace = textSz * 2;

  int lineSpacing = 2;

  Panel() {
 
  }
  
  public void update() {
    
    float x = 0;
    float y = textSz + 5;
    
    String[] keys = data.keyArray();
    int columnSpace = textSz * 13;
    
    if (this.header != "") {
      textSize(textSz * 1.3f);
      text(this.header, x, y);
      y += textSz * 1.3f + lineSpacing;
      textSize(textSz);
    }
    
    for (String k : keys) {
      
      String v = data.get(k);
      
      text(k, x, y);
      text(v, x + columnSpace, y);
      y += textSz + lineSpacing;
    }
    
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
