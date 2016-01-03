public class Vector {
  private PVector a;
  private PVector b;
  private PVector v;
  
  public Vector(PVector a, PVector b) {
    this.a = a;
    this.b = b;
    v = new PVector(b.x - a.x, b.y - a.y);
  }

  public float x1() {
    return a.x;
  }
  
  public float x2() {
    return b.x;
  }
  
  public float y1() {
    return a.y;
  }
  
  public float y2() {
    return b.y;
  }
}
