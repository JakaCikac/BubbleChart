class Point2D {
  float x, y;
  
  // point2D constructor
  Point2D(float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  // setter methods
  void setx(float x_) {
    x = x_;
  }
  
  void sety(float y_) {
    y = y_;
  }
  
  // getter methods
  float x() {
    return x;
  }
  
  float y() {
    return y;
  }
}