class PengButton{
  float _x,_y;
  float _targX, _targY;
  float _r;
  boolean _selected;
  boolean _launching;
  color _selectedColor;
  color _defaultColor;
  color _currentColor;
  color _launchingColor;
  pengArrow _indArrow;

  PengButton(float x, float y, float r, color dC, color sC, color lC){
    _x = x;
    _y = y;
    _r = r;
    _selected = false;
    _launching = false;
    _selectedColor = sC;
    _defaultColor = dC;
    _launchingColor = lC;
    _currentColor = _defaultColor;
    _indArrow = new pengArrow(x, y);
    _indArrow.hide();
  }

  void display(float currX, float currY){
    fill( _currentColor);
    ellipse( currX, currY, 2 * _r, 2 * _r);
    _indArrow.update(_x, _y, _targX, _targY);
    _indArrow.display();
    _x = currX; // update pos variables
    _y = currY; // update pos variables
  }

  void clicked(int mx, int my){
    if( dist(_x, _y, mx, my) < dist(0, 0, _r / 2, _r / 2) ){ // if the inputted coords(they'll be the mouseXY of a registered click
      _selected = !_selected; // flip _selected state
      if( _selected) { // if we just selected
          _currentColor = _selectedColor; // make it black(indicate that it has been selected)
          if(_launching) { // if we are launching, given that we are selecting
            _currentColor = _launchingColor;
            _indArrow.show();
            _targX = mx;
            _targY = my;
          }
      } else { // if we just deselected
          _currentColor = _defaultColor; // reset color
          _launching = false; // ensure we are not launching
          _targX = _x;
          _targY = _y;
          _indArrow.hide();
      }
    }
  }
  
  boolean isSelected() {
    return _selected;
  }
  
  boolean isLaunching() {
    return _launching;
  }
  
  void launch(float posX, float posY, float targX, float targY) {
    if(_selected) {
       _currentColor = _launchingColor;
       _launching = true;
       
    }
  }
  
  void maskColor() {
    _currentColor = _defaultColor;
    _indArrow.hide();
  }
  
  void reset() {
   _currentColor = _defaultColor;
   _selected = false;
   _launching = false;
  }
}
