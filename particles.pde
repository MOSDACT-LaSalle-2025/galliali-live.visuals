class Dancer {
  PVector pos;
  int friendIdx, enemyIdx;
  float intimacy; // minimum personal space
  
  Dancer() {
    pos = new PVector(random(-20, 20), random(-20, 20));
    intimacy = random(0.005, 0.05); // assign unique intimacy radius
    rewire();
  }
  
  void rewire() {
    friendIdx = int(random(N));
    enemyIdx  = int(random(N));
  }
  
  void update(PVector[] oldPositions) {
    PVector me = oldPositions[thisIndex()];
    PVector f  = oldPositions[friendIdx];
    PVector e  = oldPositions[enemyIdx];
    
    // --- Step 1: contract towards center
    pos.mult(0.992f);
    
    // --- Step 2: attraction to friend
    PVector toF = PVector.sub(f, me);
    float dF = toF.mag();
    toF.div(0.01f + dF);
    pos.add(toF.mult(0.02f));
    
    // --- Step 3: repulsion from enemy
    PVector toE = PVector.sub(e, me);
    float dE = toE.mag();
    toE.div(0.01f + dE);
    pos.sub(toE.mult(0.01f));
    
    // --- Step 4: intimacy (avoidance of ALL dancers)
    for (int i = 0; i < oldPositions.length; i++) {
      if (i == thisIndex()) continue;
      PVector other = oldPositions[i];
      float d = PVector.dist(me, other);
      if (d < intimacy) {
        // push away with strength depending on closeness
        PVector away = PVector.sub(me, other);
        away.normalize();
        float strength = (intimacy - d) * 0.05; 
        pos.add(away.mult(strength));
      }
    }
  }
  
void display(float scaleFactor) {
  float d = pos.mag(); // distancia desde el centro
  float t = constrain(map(d, 0, 1.5, 0, 1), 0, 1); // interpolador entre 0 y 1

  // Interpolar entre azul y blanco
  float r = lerp(0, 255, t);    // rojo de 0 a 255
  float g = lerp(0, 255, t);  // verde de 100 a 255
  float b = lerp(255, 255, t);  // azul se mantiene en 255
  
  float alpha = random(t,250); //lerp(255, 120, t); // más lejos = más translúcido

  stroke(r, g, b, alpha);
  strokeWeight(11);
  point(pos.x * scaleFactor, -pos.y * scaleFactor);
}


  int thisIndex() {
    for (int i = 0; i < floor.dancers.length; i++) {
      if (floor.dancers[i] == this) return i;
    }
    return -1;
  }
}



////////////

class DanceFloor {
  Dancer[] dancers;
  float S; // scale factor
  
  DanceFloor(int n) {
    dancers = new Dancer[n];
    for (int i = 0; i < n; i++) {
      dancers[i] = new Dancer();
    }
    S = min(width, height) / 4f;
  }
  
  void update() {
    // occasionally rewire one dancer
    if (random(10) < 100.0 / dancers.length) {
      int r = int(random(dancers.length));
      dancers[r].rewire();
    }
    
    // snapshot of old positions
    PVector[] old = new PVector[dancers.length];
    for (int i = 0; i < dancers.length; i++) {
      old[i] = dancers[i].pos.copy();
    }
    
    // update all dancers
    for (int i = 0; i < dancers.length; i++) {
      dancers[i].update(old);
    }
  }
  
  void display() {
    for (Dancer d : dancers) {
      d.display(S);
    }
  }
}
