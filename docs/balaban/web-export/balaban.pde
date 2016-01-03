
private final int SCREEN_SIZE = 800;
final int MAX_SEGS = 100;
private BalabanObject balabanObject = new BalabanObject(SCREEN_SIZE);
PVector temp;
int mode = 0;


void setup()
{
  size(SCREEN_SIZE, SCREEN_SIZE);
  drawing_line = false;
  temp = null;
}

void draw()
{
  background(255);
  balabanObject.drawSegments();
  stroke(0);
  if (temp != null) {
    line(temp.x, temp.y, mouseX, mouseY);
  }
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    if (temp != null) {
      balabanObject.addSegment(temp, new PVector(mouseX, mouseY));
      temp = null;
    } else {
      temp = new PVector(mouseX, mouseY);
    }
  }
}
public class BalabanObject {
  private ArrayList segments = new ArrayList();
  private int numSegs = 0;
  
  public BalabanObject(int screenSize) {
    
  }
  
  public void addSegment(PVector v1, PVector v2) {
    segments.add(new Vector(v1, v2));
    numSegs++;
  }
  
  public void drawSegments() {
    noFill();
    strokeWeight(1.0);
    stroke(0,255,0);
    
    for (int i = 0; i < numSegs; i++) {
      Vector v = segments.get(i);
      line(v.x1(), v.y1(), v.x2(), v.y2());
    }
  }
}
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

