public class Penguin {
  private int _team; //0 = red; 1 = blue;
  private double _weight = 1; //0 = no momentum; 0 < --> _weight * magnitude momentum
  private double _xPos;
  private double _yPos;
  private double _girth;
  private boolean _sunken = false;
  private boolean _thawed = true;
  private double _distanceToDeath;

  public Penguin(int team) {
    //default peng
    _girth = 10;
    _xPos = (700-_girth)*(Math.random()) + 150 + _girth;
    _yPos = (700-_girth)*(Math.random()) + 150 + _girth;
    updateDistance();
    _team = team;
  }

  private boolean updateDistance(){
    double xDist;
    double yDist;
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

  public double getWeight() {
    return _weight;
  }

  public double[] getPos() {
    double[] pos = new double[2];
    pos[0] = _xPos;
    pos[1] = _yPos;
    return pos;
  }

  public boolean sink() {
    _sunken = true;
    _weight = 0;
    return true;
  }

  // public blah launch() { scawy }

  public double addWeight(double munch) {
    _weight += munch;
    return _weight;
  }

  public boolean getThaw() {
    return _thawed;
  }

  public boolean setThaw(boolean iceyStatus) {
    _thawed = iceyStatus;
    return true;
  }

  public double getDist() {
    return _distanceToDeath;
  }
}
