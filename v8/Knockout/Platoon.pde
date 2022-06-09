import java.util.PriorityQueue;

public class Platoon {
  private int _team; 
  private PriorityQueue<Penguin> _squadron; // active team members
  private ArrayList<Penguin> _drowned; // drowned/out penguins
  
  public Platoon(int team) {
   _team = team;
   _squadron = new  PriorityQueue<Penguin>();
  }
   
  public boolean addPeng(Penguin newbie) {
    if(newbie.getTeam() == _team) {
      _squadron.add(newbie); 
      return true;
    } 
    return false;
  }
  
  public Penguin getNext() {
    if( _squadron.size() > 0) {
       Penguin next = _squadron.poll();
       _squadron.add(next); // add to end
       return next;
    } 
    return null;
  }
  
  public Penguin peek() {
    if( _squadron.size() > 0) {
       Penguin next = _squadron.peek();
       return next;
    } 
    return null;
  }
   
  public PriorityQueue<Penguin> getPlatoon() {
     return _squadron; 
  }
  
  public Penguin drown(Penguin p) {
     for(Penguin potentialP : _squadron) {
      if (potentialP.equals(p)) {
       _drowned.add(p);
       _squadron.remove(p);
       p.sink();
      }
     }
     return p;
  }
  
  public Penguin whichPeng(float cX, float cY) {
    for(Penguin p : _squadron) {
      if (abs(cX - (p.getPos()).x) < p.getRadius() && abs(cY - (p.getPos()).y) < p.getRadius()) {
        return p;
      }
    }
    return null;
  }
  
  public boolean isAlive(Penguin p) {
    //redundant
     return p.isSunken(); 
  }
}
