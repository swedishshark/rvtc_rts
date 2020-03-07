class Controller{

  int selectedDrone = -1;

  Controller(){
  
  
  
  }
  
  void update(){
    
    grid.resetCells();
  
    for(int i=0; i<globs.droneCount; i++){
      
      //update drone state
      playerDrones[i].update();
      enemyDrones[i].update();
      
      //give enemy drone new pos
      //if (!enemyDrones[i].is_moving)    
      //  enemyDrones[i].move(randomPos()); 
        
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
    
    //Iterate each cell in the array
    for(int i=0; i<grid.cellArray.length; i++){
      
      Cell cell = grid.cellArray[i];

      //iterate each drone in the cell
      for(int j=0; j<cell.droneList.size() - 1; j++){
      
        Drone sourceDrone = cell.droneList.get(j);

        //iterate every other drone in the list
        for(int k=j+1; k<cell.droneList.size(); k++){
          
            Drone targetDrone = cell.droneList.get(k);

            //test for collision, ;adding each drone to the other's list
            if(sourceDrone.sightBox.collide(targetDrone.sightBox)){

              targetDrone.droneList.add(sourceDrone);
              sourceDrone.droneList.add(targetDrone);
            
            }

        }

      }
      
      updateHud();
      
      //debug output
      /*
      for(int j=0; j<cell.droneList.size(); j++) {
        
        Drone s = cell.droneList.get(j);
        
        print("\n",s.name);
        
        for(int k=0; k<s.droneList.size(); k++) {
          print("\n\t",s.droneList.get(k).name);
        }
      }
    */
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
    
   }
   
   selectedDrone = id;
   print("selected drone=",selectedDrone);
   return drone_selected;
  }

  void updateHud() {
    if (selectedDrone == -1)
      return;
     
    Drone drone = playerDrones[selectedDrone];
    panels[1].data.set("ID", str(selectedDrone));
    panels[1].data.set("Speed", str(drone.speed));
    panels[1].data.set("Orders", "Move");
    panels[1].data.set("HP", str(drone.health));
    panels[2].data.set("Targets", drone.getDroneIDs());
  
  }
  
  void moveOrder(){
    
     for (int i=0; i<globs.droneCount; i++){
       
       if (playerDrones[i].is_active)
         playerDrones[i].move(mouseX, mouseY);
     }
     
  
  }

}
