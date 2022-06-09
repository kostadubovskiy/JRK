import java.util.*;

/**
  * fix the selection click so it only selects when inside penguin -- DONE
  * fix the issue that you can only select and fire a penguin once, once it's fired it cannot be selected again. -- DONE 
  * fix the issue when penguins spawn on top of each other
  * 
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
boolean _clickStart = false;
boolean _clickSelect = false;
boolean _clickL = false;
boolean _clickC = false;
boolean _started = false;
boolean _gameOver = false;

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
  
  // Respawn until no intersections
  /*
    This basically fixes the position of a penguin and it respawns any of those intersecting with it until they are no longer intersecting with it
    * issue: if you respawn a penguin onto a penguin who you already covered in the overarching for loop, then it won't be reset. 
  */
  /*for ( Penguin p : pengs ) { // given a penguin
     for (Penguin neighbor : pengs) { // for a given neighbor penguin
       while(true) { // keep respawning until they don't intersect
         if (!neighbor.equals(p)) { // make sure you're not looking at the same penguin, in which case it's always "on top of" itself
           if (dist(p.getPos().x, p.getPos().y, neighbor.getPos().x, neighbor.getPos().y) < 2 * p.getRadius() || dist(p.getPos().x, p.getPos().y, neighbor.getPos().x, neighbor.getPos().y) < 2 * neighbor.getRadius()) { // if they intersect
             PVector newPos = new PVector((float) ((600-neighbor.getRadius())*(Math.random()) + 100 + neighbor.getRadius()), (float) ((600-neighbor.getRadius())*(Math.random()) + 100 + neighbor.getRadius())); // make a new random pos
             neighbor.setPos(newPos); // move the neighbor peng there and check again
           } else {
              break;   
           }
         } else { break; }
       }
     }
  }*/
  ///*
  // DIS THE ONE WE ARE WORKING ON :::::
  for ( Penguin p : pengs ) { // given a penguin
    //int cycles = 0;
    //int minCycles = cycles + 1;
    //boolean enteringLastCycle = false;
    //while(cycles < minCycles) { // keep comparing until p has no intersections
    //  cycles += 1;
    //  if (! enteringLastCycle) {
    //    minCycles += 1;
    //  }
    while(true) {
      boolean toggled = false;
       for (Penguin neighbor : pengs) { // loop through all neighbor penguins
         if (!neighbor.equals(p)) { // make sure you're not looking at the same penguin, in which case it's always "on top of" itself
           if (dist(p.getPos().x, p.getPos().y, neighbor.getPos().x, neighbor.getPos().y) < 2 * p.getRadius() || dist(p.getPos().x, p.getPos().y, neighbor.getPos().x, neighbor.getPos().y) < 2 * neighbor.getRadius()) { // if they intersect
             PVector newPos = new PVector((float) ((600-p.getRadius())*(Math.random()) + 100 + p.getRadius()), (float) ((600-p.getRadius())*(Math.random()) + 100 + p.getRadius())); // make a new random pos
             p.setPos(newPos); // move the neighbor peng there and check again
             toggled = true;
           }
         } else { continue; }
       }
       if ( !toggled ) {
         break;
       }
     }
     //enteringLastCycle = true;
  }//*/
}


void draw() {
  if (!_gameOver) {
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
    } 
    else {
      background(100, 165, 200);
      berg.update();
      berg.display(); // update and display iceberg and background
      
      if(_click) { // if a click is registered at all
         for(Penguin p : platoons[_activePlatoon].getPlatoon()) {
            boolean pre = p.getInd().isSelected();
            p.getInd().clicked(mouseX, mouseY); // check to see if it was a penguin that was clicked
            boolean post = p.getInd().isSelected();
            if (pre != post) { // if cond changed, then it was a selection click
              _clickL = false; // it was a sClick so reset launch click
              _clickC = false; // it was a sClick so reset complete-turn click
            } else {
              _clickSelect = false;  // if it wasn't a selection click, rule that out and reset it
          }
         }
        
         if(_clickC && !_clickSelect) { // if the type of click has been narrowed down to a complete or a launch click 
            boolean pre = _moveComplete.isSelected(); 
            _moveComplete.clicked(mouseX, mouseY); 
            boolean post = _moveComplete.isSelected();
            if(pre != post) {
               _clickL = false;
               _clickSelect = false;
               _currSelec.clear();
            } else {
              _clickC = false; 
            }
        }
        
        if(_clickL && !_clickC && !_clickSelect) { // if it could still be a launch click but definitely not a complete-turn click
          for(Penguin launching : _currSelec) {
            launching.getInd().launch(launching.getPos().x, launching.getPos().y, mouseX, mouseY); // execute launch on those penguins who are in _currSelec, set launching bool in PB to be true, set color white
            launching.setTarget(new PVector(mouseX - launching.getPos().x, mouseY - launching.getPos().y)); // set temp displacement vector
          }
          _currSelec.clear(); // clear currSelec since we've made a launch decision, they'll have to reselect and everything if they choose to change it //<>//
          _clickL = false;
        }
        
        _clickSelect = false;
        _clickC = false;
        _clickL = false;
        _click = false; // reset all clicks
      }
       //<>//
      move(); // execute a move
      
      _moveComplete.display(); // display the "end turn" button
      if(_moveComplete.isSelected()) { // if it has been pressed
       if(_activePlatoon == 0) { // if curr platoon was 0th team
        _zeroDone = true;  // set 0th team to be done w their turn
        for(Penguin p : platoons[_activePlatoon].getPlatoon()) {
          p.getInd().maskColor(); // change appearance, but not internal states/booleans
          //p.getInd().display(p.getPos().x, p.getPos().y);
        }
        _activePlatoon += 1; // increment turn
       } else {// if curr platoon was 1st team
         _oneDone = true; // set 1st team to be done w their turn
         for(Penguin p : platoons[_activePlatoon].getPlatoon()) {
            p.getInd().maskColor(); // change appearance, but not internal states/booleans
            //p.getInd().display(p.getPos().x, p.getPos().y);
          }
         _activePlatoon -= 1; // increment turn
       }
       _moveComplete.change(false); // reset end-turn button
       //_currSelec.clear();
      }
  
      for (Penguin p : pengs) { // update stuff and sink if necessary
        if(onBerg(p.getPos())) {
          p.sink();
        }
        if(!p.isSunken()) {
          p.update();
          p.display();
          //p.checkBoundaryCollision();
        }
      }
      
      for (int i = 0; i < pengs.length; i++) { // check for bounces
        for (int j = i + 1; j < pengs.length; j++) {
          pengs[i].checkCollision(pengs[j]);
        }
      }
      
      for (Platoon t : platoons) {
          int numberLeft = 0;
          for (Penguin p : t.getPlatoon()) {
           if(!p.isSunken()) {
            numberLeft += 1; 
           }
          }
          if(numberLeft == 0) {
           _gameOver = true; 
          }
      }
    }
  } else {
   background(40, 40, 40);
   fill(250, 40, 30);
   textSize(30);
   textAlign(CENTER);
   text("GAME OVER", 385, 385);
  }
}


void move() {
  if (!_moveComplete.isSelected()){
    Platoon currTeam = platoons[_activePlatoon];
    for(Penguin p : currTeam.getPlatoon()) {
       p.setThaw(false);
    }
    for (Penguin p : currTeam.getPlatoon()) { // this whole logic chunk just updates the set of currently selected penguins
      if (!p.getThaw()) { // if peng available
        if (p.getInd().isSelected() && !p.getInd().isLaunching()) {
          _currSelec.add(p);
        }
        if (!p.getInd().isSelected() && _currSelec.contains(p)) {
          p.setTarget(null);
          // p.getInd().reset();
          _currSelec.remove(p);
        }
      }
    }
  } 
  if (_zeroDone && _oneDone) { // if both moves have completed
  // the great reset
    _zeroDone = false;
   _oneDone = false;
   for (Platoon t : platoons) {
    for (Penguin p : t.getPlatoon()) { // for all pengs
     if(p.getTarget() != null) {
      p.setVelocity(0.005 * p.getTarget().x, 0.005 * p.getTarget().y); // set velocity to a scalar * displacement vector
      p.setTarget(null); // reset buffer velocity var
      p.getInd().maskColor(); // mask them
      //p.getInd().display(p.getPos().x, p.getPos().y);
     }
     p.getInd().reset(); // reset pengButton object, then _launching and _selected are false, color becomes default
    }
   }
   //_currSelec.clear();
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
