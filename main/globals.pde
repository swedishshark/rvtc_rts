class Globals {
  
  int droneCount = 10;
  int frame_rate = 20;

  Coordinate2 screen = new Coordinate2(1280, 720);
  Coordinate2 zone = new Coordinate2(int(float(screen.x) * 0.1), screen.y);

  int playerX = int(screen.x) - int(zone.x) - 30;
  int enemyX = int(zone.x) + 30;
  int droneSize = 10;

}
