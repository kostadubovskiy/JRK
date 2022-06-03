public class Iceberg {
  private float _iWidth, _iHeight;
  
  public Iceberg(float iWid, float iHei) {
   _iWidth = iWid;
   _iHeight = iHei;
  }
  
  void update() {
    
  }
  
  void display() {
    fill(100, 100, 230);
    rect((width - _iWidth)/2, (height - _iHeight)/2, _iWidth, _iHeight);
  }
}
