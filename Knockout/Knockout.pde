/**
 * Circle Collision with Swapping Velocities
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 */
 
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
boolean _started = false;

Penguin _selected = platoons[0].getNext();

int cursor;

Button start;
Button _moveComplete;

ArrayList<Penguin> _currSelec = new ArrayList<Penguin>();

int _activePlatoon = 0; // number of the platoon who can currently make choices
boolean _zeroDone = false; // is team zero done with their move
boolean _oneDone = false; // """"" one """""

void setup() {
  size(800, 800);
  frameRate(480);
  
  // janky functional colors:
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
  background(80, 100, 110);/*
  fill(85, 120, 130);
  stroke(35, 70, 80);
  rect(width/2 - 150, height/2 - 60, 300, 120, 15);
  fill(200, 230, 250);
  textSize(50);
  text("Click to Start", width/2 - 135, height/2 + 15);*/
  start = new Button(width/2 - 150, height/2 - 60, 300, 120, 15, "Click to Start", color(85, 120, 130), color(100, 140, 155));
  _moveComplete = new Button(width / 2 - 50, height - 75, 100, 50, 10, "Finish move", color(85, 120, 130), color(100, 140, 155));
  start.display();
  platoons[0].addPeng(pengs[0]);
  platoons[1].addPeng(pengs[1]);
  platoons[0].addPeng(pengs[2]);
  platoons[1].addPeng(pengs[3]);
}

void draw() {
  //cursor = ARROW;
  if (!_started) {
    if(_click == true) {
      start.clicked(mouseX, mouseY);
      if(start.isSelected()) {
         _started = true; 
      }
      /* if( abs(mouseX - width/2) < 150 && abs(mouseY - height/2) < 60) {
         //cursor = HAND;
         _started = true;
       }*/
       _click = false;
    }
  } else {
    background(100, 165, 200);
    berg.update();
    berg.display();
    
    if(_click) {
       for(Penguin p : platoons[_activePlatoon].getPlatoon()) {
        (p.getInd()).clicked(mouseX, mouseY); 
       }
       _click = false;
    }
    
    move();
    if(_click) _moveComplete.clicked(mouseX, mouseY); _click = false;
    _moveComplete.display();
    
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
    for (Penguin p : currTeam.getPlatoon()) {
      if (!p.getThaw()) {
        if (p.getInd().isSelected()) {
          _currSelec.add(p);
          if(_click) {
            for(Penguin launching : _currSelec) {
              launching.setTarget(new PVector(mouseX, mouseY));
              launching.getInd().select();
            }
          }
        }
      }
    }
  } else {
    _currSelec.clear();
    _moveComplete.select();
  }
  if (_zeroDone && _oneDone) {
   for (Platoon t : platoons) {
    for (Penguin p : t.getPlatoon()) {
     p.setVelocity(p.getTarget());
    }
   }
  }
}

void mouseClicked() {
  _click = true;
}

void mouseReleased() {
 _click = false; 
}

boolean onBerg(PVector position) {
   if ((100 + berg.getDimensions()[0] - position.x) < 0 || (position.x - 100) < 0 || (100 + berg.getDimensions()[1] - position.y) < 0 || (position.y - 100) < 0) {
     return true;
   }
   return false;
}
