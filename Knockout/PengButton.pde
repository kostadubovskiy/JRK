class PengButton{
  float _x,_y;
  float _w,_h;
  boolean _selected;
  color _selectedColor;
  color _defaultColor;
  color _currentColor;

  PengButton(float x, float y, float w, float h, color dC, color sC){
    _x = x;
    _y = y;
    _w = w;
    _h = h;
    _selected = false;
    _selectedColor = sC;
    _defaultColor = dC;
    _currentColor = _defaultColor;
  }

  void display(float currX, float currY){
    fill( _currentColor);
    ellipse( currX, currY, _w, _h);
  }

  void clicked(int mx, int my){
    if( dist(_x, _y, mx, my) < dist(0, 0, _h,_w) ){
      _selected = !_selected;  
      if( _selected){
          _currentColor = _selectedColor;
      } else{
          _currentColor = _defaultColor;
      }
    }
  }
  
  boolean isSelected() {
    return _selected;
  }
  
  void select() {
   _selected = !_selected; 
   if(_selected){
        _currentColor = _selectedColor;
    } else{
        _currentColor = _defaultColor;
    }
  }
  
  void shootColor() {
   _currentColor = color(255, 255, 255);
  }
} 
