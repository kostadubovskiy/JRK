import java.util.*;

Penguin[] pengs =  { 
  new Penguin(0), 
  new Penguin(1),
  new Penguin(2),
  new Penguin(3)
};

Platoon[] platoons = {
  new Platoon(0),
  new Platoon(1)
};

Iceberg berg = new Iceberg(600, 600);

boolean _click = false;
boolean _clickStart = false;
boolean _clickSelect = false;
boolean _clickL = false;
boolean _clickC = false;
boolean _started = false;

Penguin _selected = platoons[0].getNext();

int cursor;

Button start;
Button _moveComplete;

HashSet<Penguin> _currSelec = new HashSet<Penguin>();

int _activePlatoon = 0; // number of the platoon who can currently make choices
boolean _zeroDone = false; // is team zero done with their move
boolean _oneDone = false; // """"" one """""

void setup() {
  size(800, 800);
  frameRate(480);
  
  // svgs:
  //pengs[0].setPeng(loadShape("RedPeng.svg"));
  //pengs[1].setPeng(loadShape("BluePeng.svg"));
  // non-functional penguin color assignments below :/ will do later
  /*for(int i = 0; i < pengs.length; i++) {
    if (pengs[i].getTeam() % 2 == 0) {
      pengs[i].setPeng(loadShape("RedPeng.svg"));
    }
    else {
      pengs[i].setPeng(loadShape("BluePeng.svg"));
    }
  }*/
  background(80, 100, 110);
  start = new Button(width/2 - 150, height/2 - 60, 300, 120, 15, "Click to Start", color(85, 120, 130), color(100, 140, 155), 30);
  _moveComplete = new Button(width / 2 - 50, height - 75, 100, 50, 10, "Finish move", color(85, 120, 130), color(100, 140, 155), 20);
  start.display();
  platoons[0].addPeng(pengs[0]);
  platoons[1].addPeng(pengs[1]);
  platoons[0].addPeng(pengs[2]);
  platoons[1].addPeng(pengs[3]);
}

void draw() {
  if (!_started) { // if not past the start screen
    if(_clickStart == true) { // if mouseClicked registers a click and changes _click to true
      start.clicked(mouseX, mouseY); // check if the click was on the start button
      if(start.isSelected()) {
         _started = true; // if it was, change global started var to true. Never come back here
      }
       _clickStart = false; // change click back to true
       _clickL = false;
       _click = false;
       _clickC = false;
       _clickSelect = false;
    }
  } else {
    background(100, 165, 200);
    berg.update();
    berg.display(); // update and display iceberg and background
    
    if(_click) { // if a click is registered at all
       for(Penguin p : platoons[_activePlatoon].getPlatoon()) {
          boolean pre = p.getInd().isSelected();
          (p.getInd()).clicked(mouseX, mouseY); // check to see if it was a penguin that was clicked
          boolean post = p.getInd().isSelected();
          if (pre != post) { // if cond changed, then it was a selection click
           _clickL = false; // it was a sClick so reset launch click
           _clickC = false; // it was a sClick so reset complete-turn click
        } else {
           _clickSelect = false;  // if it wasn't a selection click, rule that out and reset it
        }
       }
       
       //if(!_moveComplete.isSelected()) { // if still moving
      
      //}
      
       if(_clickC && !_clickSelect) { // if the type of click has been narrowed down to a complete or a launch click 
          boolean pre = _moveComplete.isSelected(); 
          _moveComplete.clicked(mouseX, mouseY); 
          boolean post = _moveComplete.isSelected();
          if(pre != post) {
             _clickL = false;
             _clickSelect = false;
          } else {
            _clickC = false; 
          }
      }
      
      if(_clickL && !_clickC && !_clickSelect) { // if it could still be a luaunch click but definitely not a complete-turn click
        for(Penguin launching : _currSelec) {
          launching.getInd().shootColor();
          launching.setTarget(new PVector(mouseX, mouseY));
        }
        _clickL = false;
      }
      
      _clickSelect = false;
      _clickC = false;
      _clickL = false;
      _click = false; // reset general click
    } else {
      _click = false;
      _clickStart = false;
      _clickSelect = false;
      _clickL = false;
      _clickC = false;
    }
    
    _moveComplete.display(); //<>//
    if(_moveComplete.isSelected()) {
     if(_activePlatoon == 0) {
      _zeroDone = true; 
      _activePlatoon += 1;
      _moveComplete.select();
     } else {
       _oneDone = true;
       _activePlatoon -= 1;
       _moveComplete.select();
     }
    }

    move();
    
    for (Penguin p : pengs) {
      if(onBerg(p.getPos())) {
        p.sink();
      }
      if(!p.isSunken()) {
        p.update();
        p.display();
        //p.checkBoundaryCollision();
      }
    }
    
    for (int i = 0; i < pengs.length; i++) {
      for (int j = i + 1; j < pengs.length; j++) {
        pengs[i].checkCollision(pengs[j]);
      }
    }
    
  }
  //cursor(cursor);
}


void move() {
  if (!_moveComplete.isSelected()){
    Platoon currTeam = platoons[_activePlatoon];
    currTeam.getPeng(0).setThaw(false);
    currTeam.getPeng(1).setThaw(false);
    for (Penguin p : currTeam.getPlatoon()) {
      if (!p.getThaw()) {
        if (p.getInd().isSelected()) {
          _currSelec.add(p);
        }
        if (!p.getInd().isSelected() && _currSelec.contains(p)) {
          _currSelec.remove(p);
        }
      }
    }
  } 
  else {
    _currSelec.clear();
    _moveComplete.select();
    _activePlatoon += 1;
    _activePlatoon = _activePlatoon % 2;
  }
  if (_zeroDone && _oneDone) {
   for (Platoon t : platoons) {
    for (Penguin p : t.getPlatoon()) {
     if(p.getTarget() != null) {
      p.setVelocity(p.getTarget());
      p.setTarget(null);
     }
    }
   }
   _zeroDone = false;
   _oneDone = false;
  }
}

void mouseClicked() {
  _click = true;
  _clickStart = true;
  _clickSelect = true;
  _clickL = true;
  _clickC = true;
  
}

boolean onBerg(PVector position) {
   if ((100 + berg.getDimensions()[0] - position.x) < 0 || (position.x - 100) < 0 || (100 + berg.getDimensions()[1] - position.y) < 0 || (position.y - 100) < 0) {
     return true;
   }
   return false;
}
