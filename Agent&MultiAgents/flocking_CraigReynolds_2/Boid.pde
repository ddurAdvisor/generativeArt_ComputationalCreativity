/*
* @Author: bit2atom | SJTU-ChinaGold DesignIntelligence
* @Email:  zhanglliqun@gmail.com
* @Date:   2021-12-15 22:12:54
* @brief
* @Last Modified by:   bit2atommac2019
* @Last Modified time: 2021-12-15 22:20:43
* @detail
*/

/**
 * The Boid class
 */
class Boid {

  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  color cc;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  /**
   * [Boid description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:17:27+0800
   * @param    {[type]}                 PVector l  [description]
   * @param    {[type]}                 float   ms [description]
   * @param    {[type]}                 float   mf [description]
   */
  Boid(PVector l, float ms, float mf) {
    acc = new PVector(0,0);
    vel = new PVector(random(-1,1),random(-1,1));
    loc = l.get();
    r = 2.0;
    cc = color(255);
    maxspeed = ms;
    maxforce = mf;
  }

  /**
   * [run description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:17:36+0800
   * @param    {[type]}                 ArrayList boids         [description]
   * @return   {[type]}                           [description]
   */
  void run(ArrayList boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  /**
   * [flock description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:17:42+0800
   * @param    {[type]}                 ArrayList boids         [description]
   * @return   {[type]}                           [description]
   * We accumulate a new acceleration each time based on three rules
   */
  void flock(ArrayList boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    acc.add(sep);
    acc.add(ali);
    acc.add(coh);
  }

  /**
   * [update description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:18:08+0800
   * @return   {[type]}                 [description]
   * Method to update location
   */
  void update() {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    loc.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  /**
   * [seek description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:20:25+0800
   * @param    {[type]}                 PVector target        [description]
   * @return   {[type]}                         [description]
   */
  void seek(PVector target) {
    acc.add(steer(target,false));
  }

  /**
   * [arrive description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:20:31+0800
   * @param    {[type]}                 PVector target        [description]
   * @return   {[type]}                         [description]
   */
  void arrive(PVector target) {
    acc.add(steer(target,true));
  }

  /**
   * [steer description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:18:26+0800
   * @param    {[type]}                 PVector target        [description]
   * @param    {[type]}                 boolean slowdown      [description]
   * @return   {[type]}                         [description]
   * A method that calculates a steering vector towards a target
   * Takes a second argument, if true, it slows down as it approaches the target
   */
  PVector steer(PVector target, boolean slowdown) {
    PVector steer;  // The steering vector
    PVector desired = target.sub(target,loc);  // A vector pointing from the location to the target
    float d = desired.mag(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d < 100.0)) desired.mult(maxspeed*(d/100.0)); // This damping is somewhat arbitrary
      else desired.mult(maxspeed);
      // Steering = Desired minus Velocity
      steer = target.sub(desired,vel);
      steer.limit(maxforce);  // Limit to maximum steering force
    } 
    else {
      steer = new PVector(0,0);
    }
    return steer;
  }

  /**
   * [render description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:18:52+0800
   * @return   {[type]}                 [description]
   */
  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = vel.heading2D() + PI/2;
    fill(cc);
    stroke(cc);
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(theta);
    beginShape(QUAD);
    vertex(0, -r);
    vertex(r, 0);
    vertex(0, r*6);
    vertex(-r, 0);
    //vertex(0, -r*2);
    endShape();
    //line(0,-r*2,0,-r*10);
    popMatrix();
  }

  /**
   * [borders description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:18:58+0800
   * @return   {[type]}                 [description]
   * Wraparound
   */
  void borders() {
    if (loc.x < -r) loc.x = width+r;
    if (loc.y < -r) loc.y = height+r;
    if (loc.x > width+r) loc.x = -r;
    if (loc.y > height+r) loc.y = -r;
  }

  /**
   * [separate description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:19:11+0800
   * @param    {[type]}                 ArrayList boids         [description]
   * @return   {[type]}                           [description]
   * Separation
   * Method checks for nearby boids and steers away
   */
  PVector separate (ArrayList boids) {
    float desiredseparation = 40.0;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = PVector.dist(loc,other.loc);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(loc,other.loc);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  /**
   * [align description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:19:34+0800
   * @param    {[type]}                 ArrayList boids         [description]
   * @return   {[type]}                           [description]
   * Alignment
   * For every nearby boid in the system, calculate the average velocity
   */
  PVector align (ArrayList boids) {
    float neighbordist = 25.0;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = PVector.dist(loc,other.loc);
      if ((d > 0) && (d < neighbordist)) {
        steer.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  /**
   * [cohesion description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:19:52+0800
   * @param    {[type]}                 ArrayList boids         [description]
   * @return   {[type]}                           [description]
   * Cohesion
   * For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
   */
  PVector cohesion (ArrayList boids) {
    float neighbordist = 25.0;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = loc.dist(other.loc);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.loc); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return steer(sum,false);  // Steer towards the location
    }
    return sum;
  }
}


