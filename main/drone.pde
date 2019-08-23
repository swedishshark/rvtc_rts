class Drone {

  PVector position;
  PVector destination;
  PVector direction;
  color team;
  int size;
  int halfsize;
  int idNumber;
  boolean is_active = false;
  boolean is_moving = false;

  int j = 0;
  //speed in feet per second
  float speed = 4;
  float delta = speed / float(globs.frame_rate);
  
  Drone(int x, int y, int s, color c, int id){
    position = new PVector(x, y);
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
      

    if (is_moving){
      position = PVector.add(direction, position);
      float d = position.dist(destination); 
      is_moving = (d > 2.0*delta); //<>//
    }

    square(position.x, position.y, size);
    j++;
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
