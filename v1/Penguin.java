private int _team; //0 = red; 1 = blue;
private int _weight = 1; //0 = no momentum; 0 < --> _weight * magnitude momentum
private float _xPos;
private float _yPos;
private float _girth;
private boolean _sunken = false;
private boolean _thawed = true;
private float _distanceToDeath;

public Penguin(int team) {
  //default peng
  _girth = 10;
  _xPos = (700-_girth)*(Math.random()) + 150 + _girth;
  _yPos = (700-_girth)*(Math.random()) + 150 + _girth;
  updateDistance();
  _team = team;
}

private boolean updateDistance(){
  int xDist;
  int yDist;
  if (_xPos < 500) {
    xDist = _xPos - 150;
  }
  else {
    xDist = 850 - _xPos;
  }
  if (_yPos < 500) {
    yDist = _yPos - 150;
  }
  else {
    yDist = 850 - _yPos;
  }
  if (xDist < 0 || yDist < 0) {
    _sunken = true;
  }
  return false;
}

public int getTeam() {
  return _team;
}

public int getWeight() {
  return _weight;
}

public float[] getPos() {
  float[] pos = new float[xPos, yPos];
  return pos;
}

public boolean sink() {
  _sunken = true;
  _weight = 0;
  return true;
}

// public blah launch() { scawy }

public float addWeight(float munch) {
  weight += munch;
}

public boolean getThaw() {
  return _thawed;
}

public boolean setThaw(boolean iceyStatus) {
  _thawed = iceyStatus;
}

public float getDist() {
  return _distanceToDeath;
}
