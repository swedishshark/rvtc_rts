class BoundingBox{

  int left;
  int right;
  int top;
  int bottom;
  int halfx;
  int halfy;
  int sizeX;
  int sizeY;
  color boxStroke = color(0, 0, 0); 
  color boxFill = color(0, 0, 0);
  float fillAlpha = 75.0;

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
  
  boolean collide(BoundingBox box){
  
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
  
  void update(PVector center){
  
    update(int(center.x), int (center.y));
    
  }
  
  void update(int x, int y){
  
    left = x - halfx;
    right = x + halfx;
    top = y + halfy;
    bottom = y - halfy;
    
  }
  
  void dump(){
    
    println(str(left), str(right), str(top), str(bottom));
    
  }
  
  void refresh(){

    rectMode(CORNERS);

    stroke(boxStroke);
     fill(boxFill, fillAlpha);


    rect(this.left, this.top, this.right, this.bottom);

  }

}
