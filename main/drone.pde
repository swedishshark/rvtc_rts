class Drone {

  Vec2 pos = new Vec2();
  Vec2 dest = new Vec2();
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
      
    if (is_moving)
      delta = Vec2f(speed / frame_rate, speed / frame_rate);

    pos = pos.add(delta);

    square(pos.x, pos.y, size);
  
  }
  
  void move(int x, int y) {
    
    dest = Vec2(x, y);
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
