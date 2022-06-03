/**
 * Circle Collision with Swapping Velocities
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 */
 
Penguin[] pengs =  { 
  new Penguin(0), 
  new Penguin(1) 
};

Platoon[] platoons = {
  new Platoon(0),
  new Platoon(1)
};

Iceberg berg = new Iceberg(600, 600);

boolean moveComplete = false;

void setup() {
  size(800, 800);
}

void draw() {
  background(255);
  berg.update();
  berg.display();
  move();
  for (Penguin p : pengs) {
    p.update();
    p.display();
    //p.checkBoundaryCollision();
  }
  
  for (int i = 0; i < pengs.length; i++) {
    for (int j = i + 1; j < pengs.length; j++) {
      pengs[i].checkCollision(pengs[j]);
    }
  }
}

void move() {
  while (! moveComplete) {
    
    for (Platoon t : platoons) {
      for (Penguin p : t) {
        if(! p.getThaw()) { //if the penguin is available this turn
          while(mouseReleased()) {
          }
          PVector launchVec = new PVector(mouseX, mouseY);
          p.setTempV(launchVec);
        }
      }
    }
  }
  moveComplete = false;
}
