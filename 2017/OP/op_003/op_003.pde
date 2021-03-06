
void setup() {
  size(960, 960);
  smooth(8);
  generate();
}

void draw() {
  //if (frameCount%40 == 0) generate();
}

void keyPressed() {
  if (key == 's') saveImage();
  else generate();
}

void saveImage() {
  String name = nf(day(), 2)+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2);
  saveFrame(name+".png");
}

void generate() {
  background(colors[0]);
  noFill();
  stroke(255, 100);

  float diag = dist(0, 0, width, height);
  float md = diag*0.6;
  translate(width/2, height/2);
  rotate(random(TWO_PI));
  float ss = random(10, 220);
  float sy = (ss*sqrt(3))/2;
  boolean inv = false;

  float det = random(0.01*random(1));
  float des = random(ss*30);
  //des = 0;
  for (float j = -md; j < md; j+=sy) {
    inv = !inv;
    float dx = (inv)? 0 : ss*0.5;
    for (float i = -md; i < md; i+=ss) {
      float x = i+dx;
      float y = j;
      //ellipse(x, y, 4, 4);
      float r = ss*0.577;
      float da = TWO_PI/6;


      int rot = 0;//int(random(3));
      int sub = 10;
      float dc = 160./sub;
      for (int k = 0; k < 3; k++) {
        for (int d = 0; d < sub; d++) {
          if (d == 0) stroke(255);
          else noStroke();
          float sca = map(d, 0, sub, 1, 0);
          float ang = (k+0.25+rot)*da*2;
          PVector aux;
          float col = colors[k+1];
          if (col > 127) col -= d*dc;
          else col += d*dc;
          PVector center = new PVector(x+cos(ang+da)*r*0.5, y+sin(ang+da)*r*0.5);
          fill(col);
          beginShape();
          aux = center.copy().sub(new PVector(x, y)).mult(sca);
          aux.add(center);
          aux = des(aux, det, des);
          vertex(aux.x, aux.y);
          aux = center.copy().sub(new PVector(x+cos(ang)*r, y+sin(ang)*r)).mult(sca);
          aux.add(center);
          aux = des(aux, det, des);
          vertex(aux.x, aux.y);
          aux = center.copy().sub(new PVector(x+cos(ang+da)*r, y+sin(ang+da)*r)).mult(sca);
          aux.add(center);
          aux = des(aux, det, des);
          fill(lerpColor(color(col), color(0), 0.2));
          vertex(aux.x, aux.y);
          aux = center.copy().sub(new PVector(x+cos(ang+da*2)*r, y+sin(ang+da*2)*r)).mult(sca);
          aux.add(center);
          aux = des(aux, det, des);
          fill(col);
          vertex(aux.x, aux.y);
          endShape(CLOSE);
        }
      }
    }
  }
}

void circle(float x, float y, float s, float det, float des) {

  float r = s*0.5;
  int res = max(8, int(PI*r*0.5));
  float da = TWO_PI/res;

  beginShape();
  for (int i = 0; i < res; i++) {
    PVector aux = new PVector(x+cos(da*i)*r, y+sin(da*i)*r);
    aux = des(aux, det, des);
    vertex(aux.x, aux.y);
  }
  endShape(CLOSE);
}

PVector des(PVector v, float det, float des) {
  float a = noise(v.x*det, v.y*det)*TWO_PI*2;
  float d = pow(noise(v.x*det, v.y*det, 100.2), 5);
  float x = v.x+cos(a)*des*d;
  float y = v.y+sin(a)*des*d;
  return new PVector(x, y);
}

int colors[] = {0, 50, 180, 255};
int rcol() {
  return colors[int(random(colors.length))];
}