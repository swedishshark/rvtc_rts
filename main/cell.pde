class Cell{
  
  int ID;
  BoundingBox boundingbox;
  ArrayList<Drone> droneList = new ArrayList<Drone>();
  
  Cell(int x, int y, int cellWidth, int cellHeight){
    
    boundingbox = new BoundingBox(x, y + cellHeight, x + cellWidth, y);
    boundingbox.boxStroke = color(255, 255, 0);
    boundingbox.boxFill = color(255, 255, 255, 0);
    
  }  
  
  void refresh(){
  
    boundingbox.refresh();
    
  }
}
