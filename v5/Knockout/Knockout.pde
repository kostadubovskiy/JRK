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

void setup() {
  size(800, 800);
}

void draw() {
  background(255);
  
  for (Penguin p : pengs) {
    p.update();
    p.display();
    p.checkBoundaryCollision();
  }
  
  for (int i = 0; i < pengs.length; i++) {
    for (int j = i + 1; j < pengs.length; j++) {
      pengs[i].checkCollision(pengs[j]);
    }
  }
}
