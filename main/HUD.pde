class HUD {
  

  boolean is_visible = false;

  int width = 1279;
  int height = 150;

  int leftMargin = 5;
  int topMargin = 5;
  
  int textSz = 15;
  
  HUD(){

  }
  
  void refresh(Panel[] panels){
   
   if (!is_visible)
     return;
     
   rectMode(CORNER);
   
   //hud background
    stroke (0, 0, 0);
    fill(0, 0, 0, 100);
    rect(0, 0, width, height);
    
    // hud panels
    fill(0, 0, 0, 255);
    translate(leftMargin, topMargin);
    
    for (Panel panel : panels) {
      panel.update();
      translate(panel.span + 5, 0);
    }
  }
  
  Panel createPanel(String header){
    
    Panel p = new Panel();
    p.header = header;
    return p;
    
    
    
  }
  
}
