public class Penguin {
  private int _team; //0 = red; 1 = blue;
  private double _weight = 1; //0 = no momentum; 0 < --> _weight * magnitude momentum
  private PVector _position;
  private PVector _velocity;
  private float _radius, m;
  private boolean _sunken;
  private boolean _thawed = true;
  private double _distanceToDeath;
  private PVector[] _neighbors;
  private PVector _tempVec;
  private PShape _peng;
  
  public Penguin(int team) {
    // default peng given a team to assign to
    _radius = 30; // arbitrary choice for penguin's radius
    _velocity = new PVector(0, 0); // new PVector((float) (Math.random() * 10), (float) (Math.random() * 10)); // start at rest
    _position = new PVector((float) ((600-_radius)*(Math.random()) + 100 + _radius), (float) ((600-_radius)*(Math.random()) + 100 + _radius));
    //_sunken = false;
    _team = team % 2;
    m = _radius*.1;
    /*
    // more non-functional color assignments
    if ( _team == 0 ){
     _peng = loadShape("BluePeng.svg"); 
    } else {
     _peng = loadShape("RedPeng.svg"); 
    }*/
  }
  
  public int getTeam() {
    return _team;
  }

  public double getWeight() {
    return _weight;
  }

  public PVector getPos() {
    return _position;
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
  
  public boolean setTempV(PVector newTemp) {
     //tempV = newTemp;
     return true;
  }
  
  public boolean setPeng(PShape pengShape) {
    _peng = pengShape;
    return true;
  }
  /*
  void checkBoundaryCollision() {
    if (_position.x > width - 100 - _radius) {
      _position.x = width - 100 - _radius;
      _velocity.x *= -1;
    } else if (_position.x < 100 + _radius) {
      _position.x = 100 + _radius;
      _velocity.x *= -1;
    } else if (_position.y > height - 100 - _radius) {
      _position.y = height - 100 - _radius;
      _velocity.y *= -1;
    } else if (_position.y < 100 + _radius) {
      _position.y = 100 + _radius;
      _velocity.y *= -1;
    }
  }*/
  
  void checkCollision(Penguin other) {

    // Get distances between the balls components
    PVector distanceVect = PVector.sub(other._position, _position);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = _radius + other._radius;

    if (distanceVectMag < minDistance) {
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      other._position.add(correctionVector);
      _position.sub(correctionVector);

      // get angle of distanceVect
      float theta  = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      /* this ball's position is relative to the other
       so you can use the vector between them (bVect) as the 
       reference point in the rotation expressions.
       bTemp[0].position.x and bTemp[0].position.y will initialize
       automatically to 0.0, which is what you want
       since b[1] will rotate around b[0] */
      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * _velocity.x + sine * _velocity.y;
      vTemp[0].y  = cosine * _velocity.y - sine * _velocity.x;
      vTemp[1].x  = cosine * other._velocity.x + sine * other._velocity.y;
      vTemp[1].y  = cosine * other._velocity.y - sine * other._velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      other._position.x = _position.x + bFinal[1].x;
      other._position.y = _position.y + bFinal[1].y;

      _position.add(bFinal[0]);

      // update velocities
      _velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      _velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other._velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other._velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    }
  }
  
  void update() {
    _position.add(_velocity);
    if (_sunken) {
      _velocity.set(0, 0);
      _radius = 0;
    }
  }
  
  void display() {
    if(_team == 0) {
      fill(150, 50, 50);
    } else {
      fill(50, 50, 150);
    }
    translate(_position.x, _position.y);
    shape(_peng);
  }
  
  private boolean updateDistance(){
    double xDist;
    double yDist;
    if (_position.x < 500) {
      xDist = _position.x - 150;
    }
    else {
      xDist = 850 - _position.x;
    }
    if (_position.y < 500) {
      yDist = _position.y - 150;
    }
    else {
      yDist = 850 - _position.y;
    }
    if (xDist < 0 || yDist < 0) {
      _sunken = true;
    }
    return false;
  }
}
