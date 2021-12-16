class Agent {
  PVector loc;// = new PVector();
  float r;
  PVector speed;
  color agentColor = color(random(255), random(255), random(255));
  float speedLimit = 2;
  
  //boolean catchNeighbor = true;

  void update() {
    move();

    if (crossSpace) {
      squareSpace();
    } else {
      edge();
    }

    show();
    if (catchNeighbor) {
      neighbor();
    }
    collision();
    if (align) {
      alignment();
    }
  }

  Agent(PVector loc_, float r_) {
    loc = loc_;
    r = r_;
    speed = new PVector(random(-1, 1), random(-1, 1));
    speed.mult(5);
  }

  void show() {
    //agentColor = color(random(255), random(255), random(255));
    fill(agentColor);
    noStroke();
    ellipse(loc.x, loc.y, r*2, r*2);
  }

  void move() {
    speed.limit(speedLimit);
    loc.add(speed);
    //speed = new PVector(0, 0);
  }

  void edge() {
    if (loc.x+r >= width) {
      loc.x = width - r;
      speed.x = speed.x * -1;
    }
    if (loc.x-r <= 0) {
      loc.x = r;
      speed.x = speed.x * -1;
    }
    if (loc.y+r >= height) {
      loc.y = height - r;
      speed.y = speed.y * -1;
    }
    if (loc.y-r <= 0) {
      loc.y = r;
      speed.y = speed.y * -1;
    }
  }

  void squareSpace() {
    if (loc.x > width + r) {
      loc.x = - r;
    }
    if (loc.x < -r) {
      loc.x = width + r;
    }
    if (loc.y > height + r) {
      loc.y = - r;
    }
    if (loc.y < -r) {
      loc.y = height + r;
    }
  }

  void neighbor() {
    for (Agent a : agents) {
      PVector dd = PVector.sub(loc, a.loc);
      float ccdd = dd.mag();

      if (ccdd > 0 && dd.mag() < neighborDist) {
        stroke(255);
        float w = map(ccdd, 0, neighborDist, 10, 1);
        strokeWeight(w);
        line(loc.x, loc.y, a.loc.x, a.loc.y);
      }
    }
  }

  void collision() {
    for (Agent a : agents) {
      PVector dd = PVector.sub(loc, a.loc);
      float ccdd = dd.mag();
      if (ccdd <= r + a.r) {
        PVector acc = PVector.sub(loc, a.loc);
        acc.normalize();
        acc.mult(separation/(r*r));//加速度与半径平方成反比
        speed.add(acc);
      }
    }
  }

  void alignment() {
    for (Agent a : agents) {
      PVector dd = PVector.sub(loc, a.loc);
      float ccdd = dd.mag();
      PVector meanSpeed = new PVector();
      int count = 1;
      if (ccdd > 0 && dd.mag() < neighborDist) {
        meanSpeed.add(a.speed);
        count ++;
      }
      meanSpeed.div(count);
      meanSpeed.normalize();
      meanSpeed.mult(alignmentScale);
      speed.add(meanSpeed);
    }
  }
}
