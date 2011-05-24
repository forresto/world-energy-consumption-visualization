/* 
 * (c) 2011 Forrest Oliphant, http://sembiki.com/
 *
 * Drawing stick figures with increasing density, 
 * hexagonally packed, exporting tilable images 
 * 
 
 */

int density = 100;

void setup(){
  size(500,500);
  background(255);
  
}

void draw (){
  background(255);
  
  int y = 0;
  while (y < (height+density)/density) {
    int x = 0;
    int add_x = y%2 == 0 ? 0 : density/2;
    while (x < (width+density)/density) {
      Stick stick = new Stick(x*density+add_x, y*density, density);
      stick.draw();
      x++;
    }
    y++;
  }
  
  if (density >= 2) {
    saveTile();
    density--;
  }
  
}

void saveTile() {
  loadPixels();
  
  int w = density*2;
  int h = density*2;
  PGraphics out = createGraphics(w, h, P2D);
  out.beginDraw();
  out.loadPixels();
  for (int y = 0; y < h; y++){
    for (int x = 0; x < w; x++) {
      int pixel = pixels[y*width+x];
      if (pixel < -1) //Why are they negative?
        out.pixels[y*w+x] = pixel;
    }
  }
  out.updatePixels();
  out.endDraw();
  
  out.save("stick_"+density+".png");
}



