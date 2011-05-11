class Stick {
  float x, y;
  
  int head = 6;
  int body = 6;
  int neck = 1;
  int arm = 3;
  int leg = 2;
  
  Stick(float _x, float _y) {
    x = _x;
    y = _y;
  }
  
  void draw() {
//    noFill();
    line(x, y+head/2, x, y+head/2+body);
    line(x, y+head/2+neck, x+arm, y+head/2+neck+arm);
    line(x, y+head/2+neck, x-arm, y+head/2+neck+arm);
    line(x, y+head/2+body, x+leg, y+head/2+body+leg);
    line(x, y+head/2+body, x-leg, y+head/2+body+leg);
    ellipse(x, y, head, head);
  }
}
