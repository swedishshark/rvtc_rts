class Coordinate2 {
  
  int x = 0;
  int y = 0;
  
  Coordinate2(int x_val, int y_val) {
  
      x = x_val;
      y = y_val;
    
  }
  
  String dump() {
    return ("(" + str(x) + ", " + str(y) + ")");
  }
}
