class Globals {
  
  int droneCount = 10;
  int frame_rate = 20;

  Coordinate2 screen = new Coordinate2(1280, 720);
  Coordinate2 zone = new Coordinate2(int(float(screen.x) * 0.1), screen.y);
  Coordinate2[] zoneCenter = new Coordinate2[2];
  Coordinate2[] playField = new Coordinate2[2];

  int playerX = int(screen.x) - int(zone.x) - 30;
  int enemyX = int(zone.x) + 30;
  int droneSize = 10;

  Globals(){
    
    this.zoneCenter[0] = new Coordinate2(this.zone.x/2, this.screen.y/2); //<>//
    this.zoneCenter[1] = new Coordinate2(this.screen.x - this.zone.x/2, this.screen.y/2);
    this.playField[0] = new Coordinate2(this.zone.x, 0);
    this.playField[1] = new Coordinate2(this.screen.x - this.zone.x, this.screen.y);
    
  } //<>//
  
  void my_fn(float x) {
    println("passed float", x);
  }
  
  void my_fn(int x) {
    println("passed int", x);
  }
}
