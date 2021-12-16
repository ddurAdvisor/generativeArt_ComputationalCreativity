/*
* @Author: bit2atom | SJTU-ChinaGold DesignIntelligence
* @Email:  zhanglliqun@gmail.com
* @Date:   2021-12-15 22:14:41
* @brief
* @Last Modified by:   bit2atommac2019
* @Last Modified time: 2021-12-15 22:39:59
* @detail
*/
//press mouse to generate a new brighter boid
Flock flock;

void setup() {
  size(1200, 400);
  frameRate(120);
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 350; i++) {
    flock.addBoid(new Boid(new PVector(width/2,height/2), 3.0, 0.05));
  }
  smooth();
}

void draw() {
  fill(0,20);
  noStroke();
  rect(0,0,1200,400);
  flock.run();
}

// Add a new boid into the System
void mousePressed() {
  Boid b = new Boid(new PVector(mouseX,mouseY),2.0f,0.05f);
  b.r = 4;
  b.cc = color(255, 255, 0);
  flock.addBoid(b);
}
