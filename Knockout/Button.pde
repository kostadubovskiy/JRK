class Button{
  float _x,_y;
  float _w,_h;
  float _curve;
  boolean _selected;
  color _selectedColor;
  color _defaultColor;
  color _currentColor;
  String _label; 

  Button(float x, float y, float w, float h, float curve, String label, color dC, color sC){
    _x = x;
    _y = y;
    _w = w;
    _h = h;
    _curve = curve;
    _label = label;
    _selected = false;
    _selectedColor = sC;
    _defaultColor = dC;
    _currentColor = _defaultColor;
  }

  void display(){
    fill( _currentColor);
    rect( _x, _y, _w, _h, _curve);
    fill( 0);//black for text
    textAlign(CENTER);
    text( _label, _x + _w/2, _y + (_h/2));
  }

  void clicked( int mx, int my){
    if( mx > _x && mx < _x + _w  && my > _y && my < _y + _h){
      _selected = !_selected;  
      if( _selected){
          _currentColor = _selectedColor;
      }else{
          _currentColor = _defaultColor;
      }
    }
  }
  
  boolean isSelected() {
    return _selected;
  }
} 
