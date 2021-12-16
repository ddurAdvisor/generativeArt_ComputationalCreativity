int numOfElements = 400;
Agent[] agents;
boolean catchNeighbor;
boolean crossSpace;
boolean align;

//gloabl parameters
float alignmentScale = 2;
float separation = 1000;
float neighborDist = 30;

void setup() {
  size(800, 800);
  background(0);
  agents = new Agent[numOfElements];
  initiate();
}

void initiate() {
  //PVector pos = new PVector(random(width), random(height));
  //float radiu = random(20, 100);
  //agents = new Agent(pos, radiu);
  for (int i = 0; i < agents.length; i ++) {
    float radiu = random(2, 10);
    PVector pos = new PVector(random(radiu, width - radiu), random(radiu, height - radiu));
    agents[i] = new Agent(pos, radiu);
  }
}

void draw() {
  background(0);
  //fill(0, 5);
  //noStroke();
  //rect(0,0, width, height);
  for (int i = 0; i < agents.length; i ++) {
    agents[i].update();
  }
  
  textSize(36);
  fill(255);
  text("alignmentScale: " + alignmentScale, 50, 50);
  text("separation: " + separation, 50, 90);
}

void keyPressed() {
  if (key == 'r') initiate();
  if (key == 'l') catchNeighbor = !catchNeighbor;
  if (key == 'c') crossSpace = !crossSpace;
  if (key == 'g') align = !align;

  if (key == 'a') alignmentScale += 0.1;
  if (key == 'z') {
    if (alignmentScale >= 0.1) {
      alignmentScale -= 0.1;
    }
  }
  
  if (key == 's')separation += 100;
  if (key == 'x') {
    if (separation >= 100) {
      separation -= 100;
    }
  }
}
