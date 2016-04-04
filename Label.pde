class Label {
  
  Label(String txt, float x, float y, int numRows, color c) {
    
    // get text width
    float labelW = textWidth(txt);
    float labelH = textAscent();
    
    // check if label would go beyond screen dims
    if (x + labelW + 20 > width) {
      x -= labelW + 20;
    }
    
    // draw bg
    fill(c);
    noStroke();
    rectMode(CORNER); // note: this is the default mode. confusing b/c similar to CORNERS (plural)
    rect(x+10, y-30, labelW+10, labelH * numRows * 2); 
    
    // draw text
    fill(0);
    text(txt, x+15, y-15);
  }
}