public class Iceberg {
  private float _iWidth, _iHeight;
  
  public Iceberg(float iWid, float iHei) {
   _iWidth = iWid;
   _iHeight = iHei;
  }
  
  void update() {
    
  }
  
  void display() {
    fill(200, 250, 255);
    stroke(200, 240, 245);
    rect((width - _iWidth)/2, (height - _iHeight)/2, _iWidth, _iHeight, 10);
  }
}
