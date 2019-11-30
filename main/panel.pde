class Panel {
  
  String header;
  StringDict data = new StringDict();
  int textSz = 10;
  int columnSpace = textSz * 2;
  int span = 20 * textSz;
  int lineSpacing = 2;

  Panel() {
 
  }
  
  void update() {
    
    float x = 0;
    float y = textSz + 5;
    
    String[] keys = data.keyArray();
    int columnSpace = textSz * 13;
    
    if (this.header != "") {
      textSize(textSz * 1.3);
      text(this.header, x, y);
      y += textSz * 1.3 + lineSpacing;
      textSize(textSz);
    }
    
    for (String k : keys) {
      
      String v = data.get(k);
      
      text(k, x, y);
      text(v, x + columnSpace, y);
      y += textSz + lineSpacing;
    }
    
  }
}
