class Stick {
  float x, y, density;
  
  int head = 2;
  int body = 4;
  int neck = 1;
  int arm = 1;
  int leg = 1;
  
  Stick(float _x, float _y, float _density) {
    x = _x;
    y = _y;
    density = _density;
  }
  
  void draw() {
//    noFill();
    if (density > 5) {
      // body, arms
      line(x, y+head/2, x, y+head/2+body);
      line(x, y+head/2+neck, x+arm, y+head/2+neck+arm);
      line(x, y+head/2+neck, x-arm, y+head/2+neck+arm);
    } else if (density > 4) {
      // neck only
      line(x, y+head/2, x, y+head/2+neck);
    }
    if (density > 7) {
      line(x, y+head/2+body, x+leg, y+head/2+body+leg);
      line(x, y+head/2+body, x-leg, y+head/2+body+leg);
    }
    ellipse(x, y, head, head);
  }
}
