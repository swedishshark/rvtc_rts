class Grid{

  Cell[] cellArray;
  
  Grid(int size){
    
    int i = 0;
    int cellWidth = globs.screen.x / size;
    int cellHeight = globs.screen.y / size;
    cellArray = new Cell[size * size];
    int lastx = cellWidth * (size - 1);
    int lasty = cellHeight * (size - 1);
    
    for(int x = 0; x <= lastx; x += cellWidth){
    
      for(int y = 0; y <= lasty; y += cellHeight){
          
          cellArray[i] = new Cell(x, y, cellWidth, cellHeight);
          cellArray[i].ID = i;
          i++;
      
      }
    
    }
  
  }
  
  
  void assignCells(Drone drone){
  
    for(int i = 0; i < cellArray.length; i++){
    
      Cell cell = cellArray[i];
      
      if (cell.boundingbox.collide(drone.sightBox)){
        
        drone.cellsList.add(cell);
        cell.droneList.add(drone);
      
      }
      
    }
  
  }
  
  void refresh(){
    
    if(!droneHudUp)
      return;
    
    for(int i = 0; i < cellArray.length; i++)
      cellArray[i].refresh();
  }  
  
  void resetCells(){
  
    for(int i = 0; i < cellArray.length; i++){
      
      cellArray[i].droneList.clear();
    
    }
  
  }
  
}
