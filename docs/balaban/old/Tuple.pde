public final class Tuple {
  int a;
  int b;
  
  public Tuple(int a, int b) {
    this.a = a;
    this.b = b;
  }
 
  public boolean isLessThan(Triplet rhs) {
    if (a < rhs.a) {
      return true;
    }
    return false;
  }
}
