
boolean droneHudUp = false;

class Drone {

  int s = 0;
  //Metadata
  //--------------------
  color team;
  int size;
  int halfsize;
  int idNumber;
  BoundingBox hitBox;
  BoundingBox sightBox;
  BoundingBox shootingBox;
  String name;

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
  float sightRange = 80.5;
  float shootingRange = 50.5;
  int fireRate = 2;
  float bulletSpeed = 16;
  float bulletDamage = 5;
  //feet per second
  float speed = 4;
  
  //frame-feet per second
  float delta = speed / float(globs.frame_rate);

  ArrayList<Cell> cellsList = new ArrayList<Cell>();
  ArrayList<Drone> droneList = new ArrayList<Drone>();
  ArrayList<Drone>  targetList = new ArrayList<Drone>();
  
  Drone(int x, int y, int s, color c, int id){
    position = new PVector(x, y);
    team = c;
    size = s;
    halfsize = size/2;
    idNumber = id;
    this.update();
    hitBox = new BoundingBox(x, y, size);
    sightBox = new BoundingBox(x, y, int(sightRange));
    shootingBox = new BoundingBox(x, y, int(shootingRange));
    if(team == colors.player)
      name = "player.";
    else //<>//
      name = "enemy.";
      
    name += str(id);
    
  }
  String getTargetIDs(){
  
    String result = "";
    
    for(Drone target : targetList){
    
      if(result == "")
        result = target.name;
      else
        result += ", " + target.name;
    
    }
    
    return result;
  
  }
  String getCellIDs(){
  
    String result = "";
    
    for(int i = 0; i < cellsList.size(); i++){
      
      if(result == "")
        result = str(cellsList.get(i).ID);
      else
        result += ", " + str(cellsList.get(i).ID);
    
    }
    return result;
  }
  
  void update(){
    
    s++;
    
    if(!is_moving)
      return;
      
    position = PVector.add(direction, position);
    float d = position.dist(destination); 
    is_moving = (d > 2.0*delta); //<>//
    hitBox.update(position);
    sightBox.update(position);
    shootingBox.update(position);
    update_targets();
  }
  
  void update_targets(){
  
    for(Cell currentCell: cellsList){
      
      for(Drone d: currentCell.droneList){
        
        if(is_active && match(name, "enemy") == null)
          println('\t',currentCell.ID, d.name);
          if(sightBox.collide(d.sightBox))
            if(d.name != name)
              //println("\tcollide", s);
        
        if(sightBox.collide(d.sightBox))
          
          if(!targetList.contains(d))
             targetList.add(d);
        
        else
        
          if(targetList.contains(d.sightBox))
            targetList.remove(d);
      }
    
    }
  
  }
  
  void refresh(){
  
    rectMode (CENTER);
    fill(team);
    stroke(team);
    
    if (is_active)
      stroke(255, 255, 0);
    
    square(position.x, position.y, float(size));
    if (droneHudUp){
      hitBox.refresh(); 
      sightBox.refresh(); 
      shootingBox.refresh(); 
  }
  }
  
  void move(Coordinate2 pos) {
    
    this.move(pos.x, pos.y);
 
  }
  
  void move(int x, int y) {
    
    destination = new PVector(x, y);
    direction = PVector.sub(destination, position);
    direction.normalize();
    direction.mult(delta);
    
    is_moving = true;
  }
  
  boolean is_hit(int x, int y) {
    
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
