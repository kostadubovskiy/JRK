public class Iceberg {
  private float _iWidth, _iHeight;
  
  public Iceberg(float iWid, float iHei) {
   _iWidth = iWid;
   _iHeight = iHei;
  }
  
  void update() {
    
  }
  
  void display() {
    tint(255, 128);
    noStroke();
    fill(0, 0, 0, 50);
    rect((width - _iWidth)/2, (height - _iHeight)/2 , _iWidth + 10, _iHeight + 10, 10);
    fill(200, 250, 255);
    stroke(200, 240, 245);
    rect((width - _iWidth)/2, (height - _iHeight)/2, _iWidth, _iHeight, 10);
  }
  
  public float[] getDimensions() {
   float[] dims = new float[2];
   dims[0] = _iWidth;
   dims[1] = _iHeight;
   return dims;
  }
}
