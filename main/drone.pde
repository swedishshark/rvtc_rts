class Drone {

  PVector pos = new PVector();
  PVector dest;
  color team;
  int size;
  int halfsize;
  int idNumber;
  boolean is_active = false;
  boolean is_moving = false;
  int speed = 4;
  
  Drone(int x, int y, int s, color c, int id){
    pos.x = x;
    pos.y = y;
    team = c;
    size = s;
    halfsize = size/2;
    idNumber = id;
    this.update();

  }
  
  void update(){
    
    rectMode (CENTER);
    fill(team);
    stroke(team);
    
    if (is_active)
      stroke(255, 255, 0);
      
    PVector delta = new PVector();

    if (is_moving)
      delta = new PVector(float(speed) / float(globs.frame_rate), float(speed) / float(globs.frame_rate));

    pos = pos.add(delta);

    square(pos.x, pos.y, size);
  
  }
  
  void move(int x, int y) {
    
    dest = new PVector(x, y);
    is_moving = true;
  }
  
  boolean is_hit(int x, int y) {
    
    //left side
    if (x < pos.x - halfsize)
      return false;
    
    //right side
    if (x > pos.x + halfsize)
      return false;
    
    //top side
    if (y > pos.y + halfsize)
      return false;
    
    //bottom side
    if (y < pos.y - halfsize)
      return false;
      
    return true;
  }
   
}
