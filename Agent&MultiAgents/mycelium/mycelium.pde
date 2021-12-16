/*
* @Author: bit2atom | SJTU-ChinaGold DesignIntelligence
 * @Email:  zhanglliqun@gmail.com
 * @Date:   2021-12-14 16:07:51
 * @brief
 * @Last Modified by:   bit2atommac2019
 * @Last Modified time: 2021-12-15 22:25:04
 * @detail
 */

import java.util.Iterator;

ArrayList cells;
ArrayList newcells;
PImage img;
float food[][];

int seedNum = 10;

String filename = "einstain2.jpg";
boolean inverted = false; // true -> white background

void setup() {
  size(800, 1002); // Width and Height of the base image
  img = loadImage(filename);
  food = new float[width][height];

  /**
   * [x description]
   * @type {Number}
   */
  for (int x = 0; x < width; ++x)
    for (int y = 0; y < height; ++y) {
      food[x][y] = ((img.pixels[(x+y*width)] >> 8) & 0xFF)/255.0;
      if (inverted) food[x][y] = 1-food[x][y];
    }
  if (inverted) {
    background(255);
  } else {
    background(0);
  }

  cells = new ArrayList();
  newcells = new ArrayList();
  for (int i = 0; i < seedNum; i ++) {
    Cell c = new Cell();
    c.xpos = random(width/5, width*4/5);
    c.ypos = random(height/5, height*4/5);
    cells.add(c);
  }
}

void keyPressed() {
  saveFrame("export/" + filename+"/e-#####.png");
}

void draw() {
  loadPixels();
  newcells.clear();
  Iterator<Cell> itr = cells.iterator();
  while (itr.hasNext ()) {
    Cell c = itr.next();
    c.draw();
    c.update();
  }

  cells.addAll(newcells);
  updatePixels();
}

/**
 * [feed description]
 * @Author   bit2atom
 * @DateTime 2021-12-15T22:22:33+0800
 * @param    {[type]}                 int   x             [description]
 * @param    {[type]}                 int   y             [description]
 * @param    {[type]}                 float thresh        [description]
 * @return   {[type]}                       [description]
 */
float feed(int x, int y, float thresh) {
  float r = 0.0;
  if (x >= 0 && x < width && y >= 0 && y < height) {
    if (food[x][y] > thresh) {
      r = thresh;
      food[x][y] -= thresh;
    } else {
      r = food[x][y];
      food[x][y] = 0.0;
    }
  }
  return r;
}








/**
 * class Cell
 */
class Cell {
  float xpos, ypos;
  float dir;
  float state;

  /**
   * [Cell description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:24:01+0800
   */
  Cell() {
    xpos = random(width);
    ypos = random(height);
    dir = random(2*PI);
    state = 0;
  }

  /**
   * [Cell description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:24:07+0800
   * @param    {[type]}                 Cell c [description]
   */
  Cell(Cell c) {
    xpos = c.xpos;
    ypos = c.ypos;
    dir = c.dir;
    state = c.state;
  }

  /**
   * [draw description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:24:15+0800
   * @return   {[type]}                 [description]
   */
  void draw() {
    if (state > 0.001 && xpos >= 0 && xpos < width && ypos >= 0 && ypos < height) {
      if (inverted) {
        pixels[ int(xpos) + int(ypos) * width ] = color(0, 0, 0);
      } else {
        pixels[ int(xpos) + int(ypos) * width ] = color(255, 255, 255);
      }
    }
  }

  /**
   * [update description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:24:22+0800
   * @return   {[type]}                 [description]
   */
  void update() {
    state += feed(int(xpos), int(ypos), 0.3) - 0.295;
    xpos += cos(dir);
    ypos += sin(dir);
    dir += random(-PI/4, PI/4);
    if (state > 0.15 && cells.size() < 100) {
      divide();
    } else
      if (state < 0) {
        xpos += random(-15, +15);
        ypos += random(-15, +15);
        state = 0.001;
      }
  }

  /**
   * [divide description]
   * @Author   bit2atom
   * @DateTime 2021-12-15T22:24:28+0800
   * @return   {[type]}                 [description]
   */
  void divide() {
    state /= 2;
    Cell c = new Cell(this);
    float dd = random(PI/4);
    dir += dd;
    c.dir -= dd;
    newcells.add(c);
  }
}
