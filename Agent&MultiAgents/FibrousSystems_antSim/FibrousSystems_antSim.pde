/*
* @Author: bit2atom | SJTU-ChinaGold DesignIntelligence
 * @Email:  zhanglliqun@gmail.com
 * @Date:   2021-12-15 22:54:53
 * @brief
 * @Last Modified by:   bit2atommac2019
 * @Last Modified time: 2021-12-15 23:05:08
 * @detail
 //--------------------------------------------------FIBROUS SYSTEM----------------------------------------------------//
 
 Starting from standard flocking algorithm , every agent perform cohesion towards tail points, instead towards other agents.
 You can use this to approximate stuff like fibrous system, stigmergy , path finding etc..
 Optimized Tail point search thanks to toxi PointOctree. 
 In the sketch : 2 attractors and 1 repeller ( mouse location )
 Some example created with this code : http://vimeo.com/45254456.
 More info at : http://radical-reaction-ad.blogspot.it/
 
 W : apply wander
 N : stop looping
 F : Hide / display future location
 P : repellerProcess;
 A : attractorProcess;
 B : showBody;
 T : showTail;
 
 References : 
 -Flocking algorithm from Jose Sanchez ( Plethora project ) .
 -Agent angle of vision form Daniel Shiffman.
 
 code by Paolo Alborghetti 2013 (cc)Attribution-ShareAlike
 
 ENJOY! :)
 */

import processing.opengl.*;
import toxi.geom.*;
import toxi.geom.mesh.*;

//------------------------------------------------DECLARE
ArrayList <Agent> agents;
ArrayList <Vec3D> totTail;

//---------------------------------------
PointOctree octree;

// octree dimensions
float DIM = 800;
float DIM2 = DIM/2;

// sphere clip radius
float clipRadius = 4;

//-----------------------attractor + repell 
Vec3D repeller, seekTarget, seekTarget2;

//-----------------------behaviour variables
int population = 1000;   // Bigger the party , Slower the fun!

float maxVel = 2;
float wandertheta = 1;

float futLocMag = 10;

float tailViewAngle = 60;

float tailCohMag = 0.5;
float tailCohViewRange = 20;
float tailSepMag = 3;
float tailSepViewRange = 5;

float att = 1;
float rep = 5;
float maxAttract = 0.05;
float maxRepel = 10;

//-------------------------------------------boolean switch
boolean appWander;
boolean futPrev;
boolean NL=true;

boolean repellerProcess;
boolean attractorProcess;

boolean showBody;
boolean showTail;

//--------------------------------------------SETUPZZZZZ
void setup() {
  background(220);
  size(800, 800, P2D);
  initiate();
}

//--------------------------------------------INITIALIZE
void initiate() {
  seekTarget = new Vec3D(random (width/6, width*5/6), random(height/6, height*5/6), 0);
  seekTarget2 = new Vec3D(random (width/6, width*5/6), random(height/6, height*5/6), 0);

  agents = new ArrayList();
  totTail = new ArrayList <Vec3D>();

  for (int i=0; i < population; i++) {
    Vec3D origin = new Vec3D (random (width), random(height), 0);
    Agent myAgent = new Agent (origin);   
    agents.add(myAgent);
  }
}

//-----------------------------------------let it draw
void draw() {
  background(220);//, 254);
  smooth();

  repeller = new Vec3D(mouseX, mouseY, 0);

  //----------------CALL FUNCTIONALITY 
  for (Agent Ag : agents) {
    Ag.run();
    totTail.addAll(Ag.tail);
    Ag.tailSeek(totTail);
  }
  totTail.clear();

  // -------------- draw repeller
  if (repellerProcess) {
    float ampR = 20;
    pushStyle();
    for (int i = 0; i < ampR; i++) {
      noFill();
      strokeWeight(1);
      stroke(0, 200, 200, map(i, 0, ampR, 255, 0));
      ellipse(repeller.x, repeller.y, i*10, i*10);
    }
    popStyle();
  }

  // -------------- draw attractor
  if (attractorProcess) {
    float ampA = 36.0;
    float ang = TWO_PI/ampA;
    float lineLength = 50.0;
    PVector st1 = new PVector(seekTarget.x, seekTarget.y);
    PVector st2 = new PVector(seekTarget2.x, seekTarget2.y);

    pushStyle();
    for (int i = 0; i < ampA; i++) {
      noFill();
      strokeWeight(1);
      stroke(153);
      //ellipse(seekTarget.x, seekTarget.y, i*10, i*10);
      //ellipse(seekTarget2.x, seekTarget2.y, i*10, i*10);

      PVector start = new PVector(lineLength/2*cos(ang*i), lineLength/2*sin(ang*i));
      PVector st1Start = PVector.add(st1, start);
      PVector st2Start = PVector.add(st2, start);

      PVector end = new PVector(lineLength*cos(ang*i), lineLength*sin(ang*i));
      PVector st1End = PVector.add(st1, end);
      PVector st2End = PVector.add(st2, end);

      line(st1Start.x, st1Start.y, st1End.x, st1End.y);
      line(st2Start.x, st2Start.y, st2End.x, st2End.y);
    }
    popStyle();
  }

  println(int(frameRate));
}

//-----------------PREVIEW MODE OPTIONS
void keyPressed() { 
  if (key == 'w'|| key == 'W') {
    appWander=!appWander;
  }
  if (key == 'f'|| key == 'F') {
    futPrev=!futPrev;
  }
  if (key == 'a'|| key == 'A') {
    attractorProcess=!attractorProcess;
  }
  if (key == 'p'|| key == 'P') {
    repellerProcess=!repellerProcess;
  }
  if (key == 'b'|| key == 'B') {
    showBody=!showBody;
  }
  if (key == 't'|| key == 'T') {
    showTail=!showTail;
  }
  if (key == 'n'|| key == 'N') {
    NL=!NL;
    if (!NL)noLoop();
    if (NL)loop();
  }
  if (key == 'r') {
    initiate();
  }
}
