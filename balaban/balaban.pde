
private final int SCREEN_SIZE = 800;
final int MAX_SEGS = 100;

PVector temp;
int mode = 0;
int step = 0;
private BalabanObject balabanObject = new BalabanObject(SCREEN_SIZE, mode);

void setup()
{
  size(SCREEN_SIZE, SCREEN_SIZE);
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
  if (mode == 1) {
    balabanObject.drawVerticals();
  }
}

void mouseClicked() {
  if (mode == 0) {
    if (mouseButton == LEFT) {
      if (temp != null) {
        balabanObject.addSegment(temp, new PVector(mouseX, mouseY));
        temp = null;
      } else {
        temp = new PVector(mouseX, mouseY);
      }
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      mode++; //TODO is this necessary
      balabanObject.nextMode();
    }
    if (keyCode == DOWN) {
      step++;
      balbanObject.nextStep();
    }
  }
}
