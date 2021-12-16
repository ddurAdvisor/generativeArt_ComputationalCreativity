/*
* @Author: bit2atom | SJTU-ChinaGold DesignIntelligence
* @Email:  zhanglliqun@gmail.com
* @Date:   2021-12-14 06:45:28
* @brief
* @Last Modified by:   bit2atommac2019
* @Last Modified time: 2021-12-15 22:20:43
* @detail
*/

/**
 * The Flock (a list of Boid objects)
 */
class Flock {
  ArrayList boids; // An arraylist for all the boids

  Flock() {
    boids = new ArrayList(); // Initialize the arraylist
  }

  /**
   * [run description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:16:35+0800
   * @return   {[type]}                 [description]
   */
  void run() {
    for (int i = 0; i < boids.size(); i++) {
      Boid b = (Boid) boids.get(i);  
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  /**
   * [addBoid description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:16:40+0800
   * @param    {[type]}                 Boid b [description]
   */
  void addBoid(Boid b) {
    boids.add(b);
  }

}

