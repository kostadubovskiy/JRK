public class pengArrow {
  private float _posX, _posY;
  private float _targX, _targY;
  private boolean _hidden;
  
  pengArrow(float posX, float posY) {
    _posX = posX;
    _posY = posY;
    _hidden = true;
  }
  
  void update(float posX, float posY, float targX, float targY) {
    _posX = posX;
    _posY = posY;
    _targX = targX;
    _targY = targY;
  }
  
  void display() {
    if(!_hidden) {
      drawArrow(_posX, _posY, _targX, _targY);
    }
  }
  
  void drawArrow(float x1, float y1, float x2, float y2) {
    float a = dist(x1, y1, x2, y2) / 50;
    pushMatrix();
    translate(x2, y2);
    rotate(atan2(y2 - y1, x2 - x1));
    triangle(- a * 2 , - a, 0, 0, - a * 2, a);
    popMatrix();
    line(x1, y1, x2, y2);  
  }
  
  void hide() {
    _hidden = true;
  }
  
  void show() {
    _hidden = false; 
  }
}
