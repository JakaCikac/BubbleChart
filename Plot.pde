class Plot {
  
  // TODO: create a class for all offsets used and pass it through from main class
  // TODO: xtext offset, ytextoffset, ...

  Point2D topLeft, bottomRight;
  Point2D xstart, xend;
  Point2D ystart, yend;
  
  float xspace, yspace;
  int xaxislen, yaxislen;

  color c;

  // x1_ = leftMargin
  // y1_ = topMargin
  // x2_ = rightMargin
  // y2_ = bottomMargin

  Plot(int x1_, int y1_, int x2_, int y2_, int width_, int height_, color c_) {

    // coordinates for the rectangle (plot area)
    topLeft = new Point2D(x1_, y1_);
    bottomRight = new Point2D(width_- x2_, height_- y2_);

    // coordinates for the plot axes
    xstart = new Point2D(x1_, height_-y2_);
    xend = new Point2D(width_ - x2_, height_ - y2_);
    ystart = new Point2D(x1_, height_ - y2_);
    yend = new Point2D(x1_, y1_);

    // color of the plot area background
    c = c_;
  }

  void drawAxes(int minx, int maxx, int numticksx, int miny, int maxy, int numticksy, String unitx, String unity) {

    fill(1);
    stroke(1);
    strokeWeight(2);
    // draw the x axis
    line(xstart.x, xstart.y, xend.x, xend.y);
    // draw the y axis
    line(ystart.x, ystart.y, yend.x, yend.y);
    
    computeTickSpace(numticksx, numticksy);

    // draw the ticks for x axis
    Point2D currentSpaceX = new Point2D(xstart.x, xstart.y);
    Point2D currentSpaceY = new Point2D(ystart.x, ystart.y);
    // display text for first tick

    fill(120);
    strokeWeight(1);
    for (int i = minx + maxx/numticksx; i < maxx; i += maxx/numticksx) {
      // compute the new spacing for ticks
      float tickX = currentSpaceX.x + xspace;
      // update point
      currentSpaceX.setx(tickX);
      // draw tick
      line(tickX, ystart.y + 5, tickX, ystart.y - 5);
      // print text value
      text(i, tickX - 10, ystart.y + 20);
    } 

    // display x axis text
    float xTextWidth = textWidth(unitx);
    pushMatrix();
      fill(50);
      strokeWeight(2);
      translate(xstart.x + xaxislen/2 - xTextWidth/2, xstart.y + 45);
      text(unitx, 0, 0);
    popMatrix(); 
    
    fill(120);
    strokeWeight(1);
    // draw the ticks for y axis
    for (int i = miny + maxy/numticksy; i < maxy; i += maxy/numticksy) {
      // compute the new spacing for ticks
      float tickY = currentSpaceY.y - yspace;
      // update point
      currentSpaceY.sety(tickY);
      // draw tick
      line(ystart.x + 5, tickY, ystart.x -5, tickY);
      // print text value
      text(i, ystart.x - 45, tickY + 5);
    } 

    // display y axis text
    float yTextWidth = textWidth(unity);
    pushMatrix();
      fill(50);
      strokeWeight(2);
      translate(ystart.x - 55, ystart.y - yaxislen/2 + yTextWidth/2);
      rotate(3*HALF_PI);
      text(unity, 0, 0);
    popMatrix();
  }

  void display() {

    fill(c);
    noStroke();
    rectMode(CORNERS);
    rect(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y);
  }

  Point2D topLeft() {
    return topLeft;
  }

  Point2D bottomRight() {
    return bottomRight;
  }
  
  void computeTickSpace(int numticksx, int numticksy) {
    // compute axis length
    xaxislen = int(xend.x - xstart.x);
    yaxislen = int(ystart.y - yend.y);
    // compute spacing between ticks
    xspace = xaxislen / numticksx;
    yspace = yaxislen / numticksy;
  }

  float w() {
    return bottomRight.x - topLeft.x;
  }

  float h() {
    return bottomRight.y - topLeft.y;
  }
  
  float xspace() {
    return xspace;
  }
  
  float yspace() {
    return yspace;
  }
  
    float yaxislen() {
    return yaxislen;
  }
}