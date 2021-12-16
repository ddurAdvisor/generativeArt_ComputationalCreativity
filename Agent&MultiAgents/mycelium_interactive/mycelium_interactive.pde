/*
* @Author: bit2atom | SJTU-ChinaGold DesignIntelligence
* @Email:  zhanglliqun@gmail.com
* @Date:   2021-12-15 22:33:17
* @brief
* @Last Modified by:   bit2atommac2019
* @Last Modified time: 2021-12-15 22:37:50
* @detail
*/

ArrayList<Particle> pts;
boolean onPressed, showInstruction;
PFont f;

void setup() {
  size(1200, 720, P2D);
  smooth();
  frameRate(100);
  colorMode(HSB);
  rectMode(CENTER);

  pts = new ArrayList<Particle>();

  showInstruction = true;
  f = createFont("arial", 24, true);

  background(255);
}

void draw() {
  if (showInstruction) {
    background(255);
    fill(128);
    textAlign(CENTER, CENTER);
    textFont(f);
    textLeading(36);
    text("Drag and fabricate mycelium." + "\n" + "Press 'h' to harvest mycelium." + "\n", width*0.5, height*0.5);
  }

  if (onPressed) {
    for (int i=0; i<20; i++) {
      Particle newP = new Particle(mouseX, mouseY, i+pts.size(), i+pts.size());
      pts.add(newP);
    }
  }

  for (int i=0; i<pts.size(); i++) {
    Particle p = pts.get(i);
    p.update();
    p.display();
  }

  for (int i=pts.size()-1; i>-1; i--) {
    Particle p = pts.get(i);
    if (p.dead) {
      pts.remove(i);
    }
  }
}

/**
 * [mousePressed description]
 * @Author   bit2atom
 * @DateTime 2021-12-15T22:36:42+0800
 * @return   {[type]}                 [description]
 */
void mousePressed() {
  onPressed = true;
  if (showInstruction) {
    background(#212A2E);
    showInstruction = false;
  }
}

/**
 * [mouseReleased description]
 * @Author   bit2atom
 * @DateTime 2021-12-15T22:36:38+0800
 * @return   {[type]}                 [description]
 */
void mouseReleased() {
  onPressed = false;
}

/**
 * [keyPressed description]
 * @Author   bit2atom
 * @DateTime 2021-12-15T22:36:31+0800
 * @return   {[type]}                 [description]
 */
void keyPressed() {
  if (key == 'c') {
    for (int i=pts.size()-1; i>-1; i--) {
      Particle p = pts.get(i);
      pts.remove(i);
    }
    background(#212A2E);
  }
}

/**
 * class Particle
 */
class Particle {
  PVector loc, vel, acc;
  int lifeSpan, passedLife;
  boolean dead;
  float alpha, weight, weightRange, decay, xOffset, yOffset;
  color c;

  /**
   * [Particle description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:35:35+0800
   * @param    {[type]}                 float x       [description]
   * @param    {[type]}                 float y       [description]
   * @param    {[type]}                 float xOffset [description]
   * @param    {[type]}                 float yOffset [description]
   */
  Particle(float x, float y, float xOffset, float yOffset) {
    loc = new PVector(x, y);

    float randDegrees = random(360);
    vel = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    vel.mult(random(5));

    acc = new PVector(0, 0);
    lifeSpan = int(random(30, 90));
    decay = random(0.75, 0.9);
    c = color(#FFFFFF);
    weightRange = random(3, 50);

    this.xOffset = xOffset;
    this.yOffset = yOffset;
  }

  /**
   * [update description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:35:41+0800
   * @return   {[type]}                 [description]
   */
  void update() {
    if (passedLife>=lifeSpan) {
      dead = true;
    } else {
      passedLife++;
    }

    alpha = float(lifeSpan-passedLife)/lifeSpan * 70+50;
    weight = float(lifeSpan-passedLife)/lifeSpan * weightRange;

    acc.set(0, 0);

    float rn = (noise((loc.x+frameCount+xOffset)*0.01, (loc.y+frameCount+yOffset)*0.01)-0.5)*4*PI;
    float mag = noise((loc.y+frameCount)*0.01, (loc.x+frameCount)*0.01);
    PVector dir = new PVector(cos(rn), sin(rn));
    acc.add(dir);
    acc.mult(mag);

    float randDegrees = random(360);
    PVector randV = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    randV.mult(0.5);
    acc.add(randV);

    vel.add(acc);
    vel.mult(decay);
    vel.limit(3);
    loc.add(vel);
  }

  /**
   * [display description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:35:47+0800
   * @return   {[type]}                 [description]
   */
  void display() {
    strokeWeight(weight+1.5);
    stroke(0, alpha);
    point(loc.x, loc.y);

    strokeWeight(weight);
    stroke(map(passedLife, 0, lifeSpan, 0, 255));
    point(loc.x, loc.y);
  }
}
