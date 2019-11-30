class Controller{

  Controller(){
  
  
  
  }
  
  void update(){
    
    grid.resetCells();
  
    for(int i=0; i<globs.droneCount; i++){
      
      //update drone state
      playerDrones[i].update();
      enemyDrones[i].update();
      
      //give enemy drone new pos
      if (!enemyDrones[i].is_moving)    
        enemyDrones[i].move(randomPos()); 
        
      //test for drone collision detec.  
      playerDrones[i].cellsList.clear();
      enemyDrones[i].cellsList.clear();
      grid.assignCells(playerDrones[i]);
      grid.assignCells(enemyDrones[i]);
      
      if (playerDrones[i].is_active){
          
       panels[1].data.set("Cells", playerDrones[i].getCellIDs());
       panels[1].data.set("Position", "(" + str(playerDrones[i].position.x) + "," + str(playerDrones[i].position.y)  + ")");
       panels[1].data.set("Direction", "(" + str(playerDrones[i].direction.x) + "," + str(playerDrones[i].direction.y)  + ")");
       panels[1].data.set("Destination", "(" + str(playerDrones[i].destination.x) + "," + str(playerDrones[i].destination.y)  + ")");
        
      }
      
      playerDrones[i].droneList.clear();
      enemyDrones[i].droneList.clear();
      
    }
    
    for(int i=0; i<grid.cellArray.length; i++){
      
      Cell cell = grid.cellArray[i];

      for(int j=0; j<cell.droneList.size() - 1; j++){
      
        Drone sourceDrone = cell.droneList.get(j);

       
        for(int k=j+1; k<cell.droneList.size(); k++){
          
            Drone targetDrone = cell.droneList.get(k);

            
            if(sourceDrone.sightBox.collide(targetDrone.sightBox)){

              targetDrone.droneList.add(sourceDrone);
              sourceDrone.droneList.add(targetDrone);
              
            
            }
          
        }
      
      }
    
    }
    
  }
  
  void mouseClick(){
  
    if (droneSelected())
      return;
    
    moveOrder();
  }

  boolean droneSelected(){
  
    boolean drone_selected = false;
    
    int picked_id = -1;
    
  //test to see if drone is hit
   for (int i=0; i<globs.droneCount; i++){
   
     if (playerDrones[i].is_hit(mouseX, mouseY)){
       
       Drone drone = playerDrones[i];
       drone.is_active = !drone.is_active;
       
       if (drone.is_active){
         picked_id = i;     
       }
    
       drone_selected = true;
       break;  
     }
   }
   
   int id = -1;
   int hudID = int(panels[1].data.get("ID"));
   //println(hudID);
   if (picked_id > -1)
     id = picked_id;
   
   else if (hudID > -1) {
     if (playerDrones[hudID].is_active){
    
     id = hudID;
     }
   }
     
   else {
     
     for (int i=0; i<globs.droneCount; i++){
      
       if (playerDrones[i].is_active){
         
         id = i;
         
       }
       
     } 
   }
   if (id == -1) {
     
    panels[1].data.set("ID", "-1");
    panels[1].data.set("Position", "()");
    panels[1].data.set("Speed", "None");
    panels[1].data.set("Direction", "()");
    panels[1].data.set("Destination", "()"); 
    panels[1].data.set("Orders", "None"); 
    panels[1].data.set("HP", "None");
    
   } else {
     
    Drone drone = playerDrones[id];
    panels[1].data.set("ID", str(id));
    panels[1].data.set("Speed", str(drone.speed));
    panels[1].data.set("Orders", "Move");
    panels[1].data.set("HP", str(drone.health));
    panels[2].data.set("Targets", drone.getTargetIDs());
    
   }
   
   return drone_selected;
  
  }
  
  void moveOrder(){
    
     for (int i=0; i<globs.droneCount; i++){
       
       if (playerDrones[i].is_active)
         playerDrones[i].move(mouseX, mouseY);
     }
     
  
  }

}
