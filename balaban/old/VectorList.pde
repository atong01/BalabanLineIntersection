public class VectorList {
  private ArrayList V;
  private IntList start; //holds end y coords
  private IntList end;   //holds end x coords
  private IntList x;     //holds both starts and ends
  private IntList isXStart; // holds whether a x coord is start
  private int len;
  
  public VectorList() {
    V = new ArrayList();
    start = new IntList();
    end = new IntList();
    x = null;
    isXStart = null;
    len = 0;
  }
  
  public IntList getEnds() {
    return x;
  }
  
  public void add(Vector v) {
    V.add(v);
    start.append((int)v.x1());
    end.append((int)v.x2());
    len++;
  }
  
  public Vector get(int i) {
    return (Vector) V.get(i);
  }
  
  public int len() {
    return len;
  }
  
  public void normalizeX() {
    if (len == 0) {
      return;
    }
    println ("normalizing x");
    start.sort();
    end.sort();
    x = new IntList();
    isXStart = new IntList();
    int s = 0;
    int e = 0;
    for (int i = 0; i < 2 * len; i++) {
      if ((s < start.size() && start.get(s) < end.get(e)) ) {
        x.append(start.get(s));
        isXStart.append(1);
        s++;
      } else {
        x.append(end.get(e));
        isXStart.append(0);
        e++;
      }
    }
  }
}
