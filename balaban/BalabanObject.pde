public class BalabanObject {
  //TODO deal with x collisions
  private int screenSize;
  private int mode;
  private int step;
  private VectorList segments = new VectorList();
  
  public BalabanObject(int screenSize, int mode) {
    this.screenSize = screenSize;
    this.mode = mode;
    this.step = 0;
  }
  
  public void addSegment(PVector v1, PVector v2) {
    segments.add(new Vector(v1, v2));
  }
  
  public void drawSegments() {
    noFill();
    strokeWeight(1.0);
    stroke(0,255,0);
    int numSegs = segments.len();
    for (int i = 0; i < numSegs; i++) {
      Vector v = (Vector) segments.get(i);
      line(v.x1(), v.y1(), v.x2(), v.y2());
    }
  }
  
  private void normalize() {
    segments.normalizeX();
  }
  
  public void nextMode() {
    mode++;
    switch (mode) {
      case 1:
        normalize();
      default:
        background(0);
    }
  }

  /*
   * @param set     IntList of segment ids
   * @param b       int beginning index ends[b] is the correct x coord
   * @param e       int end index i.e. ends[e] is the correct x coord
   */
  public IntList TreeSearch(set, b, e) {
    IntList left;
    IntList right;
    if (e - b == 1) {
      left = sortByY(set, b);
      right = SerachInStrip(left, b, e);
      return;
    }
    IntList Q = Split(set, b, e);
    //find intersections with Q
    int c = (b + e) / 2;
    
    IntList s_l = crossing(set, b, c);
    IntList s_r = crossing(set, c, e);
    
    TreeSearch(s_l, b, c);
    TreeSearch(s_r, c, e);
  }
  
  public int mode() {
    return mode;
  }
}

