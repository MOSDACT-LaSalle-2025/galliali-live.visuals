import ddf.minim.*;
Minim minim; 
AudioPlayer player; 


PImage imgBike, imgStairs, imgWall,  imgPlayground, imgSea,imgMetro, imgMoon;
PImage fixedBackground = null;
PImage overlayImage = null;
PImage tempBackground = null;
boolean seeEllipse1 = false;
boolean seeEllipse2 = false;
boolean seeApollonius = false;
boolean seeText = false;

float angle = 0;

circle[] cs;

DanceFloor floor;
int N = 100;


void setup() {
  //size(600, 600, P2D);
  smooth(8);
  fullScreen(P3D);
  noCursor();
  
  textAlign(CENTER, CENTER);

  colorMode(RGB, 255);
  
  cs = new circle[3];
  init_cs_fit(new circle(width/2, height/2, min(width, height)/2));

  floor = new DanceFloor(N);

  imgBike = loadImage("bike.png");
  imgStairs = loadImage("window.png");
  imgWall = loadImage("wall.png");
  imgPlayground = loadImage("playground.png");
  imgSea = loadImage("sea.png");
  imgMetro = loadImage("metro.png");
  imgMoon = loadImage("moon.png");
 
  imageMode(CENTER);
 
  minim = new Minim(this);
  player = minim.loadFile("Gary Numan - Trois Gymnopedies.mp3"); 
  player.play();

}

void draw() {
  background(8, 8, 8);
 
  //pum = player.left.get(1)*800;
  
if(seeApollonius){
  if (mousePressed) {
      if (mouseButton == LEFT) {
        cs[0].x = mouseX;
        cs[0].y = mouseY;
      } else if (mouseButton == CENTER) {
        cs[1].x = mouseX;
        cs[1].y = mouseY;
      } else if (mouseButton == RIGHT) {
        cs[2].x = mouseX;
        cs[2].y = mouseY;
      }
      balance_cs(cs[0], cs[1], cs[2]);
    }
  
    circle s0 = new circle();
    updateApoloniusCircle(s0, cs[0], cs[1], cs[2], false);
    circle s1 = new circle();
    updateApoloniusCircle(s1, cs[0], cs[1], cs[2], true);
  
  
    noFill(); 
    strokeWeight(0);
    s0.display();
    s1.display();
    
    
    fill(240, 10, 30); 
    stroke(30, 30, 30);
    strokeWeight(0);
    for (int i = 0; i < 3; i++) {
      cs[i].display();
    }
}

//////////

  pushMatrix();
    if (seeEllipse1){
    noStroke();
    translate(width / 2, height / 2);

    float c = map(sin(radians(frameCount/2)), -1, 1, 0, 240);
  
    float r = c;   
    float g = 10;   
    float b = 30;   
  
  
    fill(r, g, b);
    circle(mouseX, mouseY, height*0.5);
    }  
  popMatrix();
  
  pushMatrix();
    if (seeEllipse2){
      noStroke();
      translate(width / 2, height / 2);
  
      float c = map(sin(radians(frameCount/2)), -1, 1, 0, 240);
    
      float r = c;   
      float g = c;   
      float b = c;   
    
    
      fill(r, g, b);
      circle(mouseX, mouseY, height*0.5);
      }  
  popMatrix();
  
 
   pushMatrix();
     if(seeText){
     textSize(200);
     textAlign(CENTER, CENTER);
     text("THEM IS US", width/2, height/2);
 }
   popMatrix();

  pushMatrix();
  if (fixedBackground != null) {
    tint(255, 250, 250, 210);
    image(fixedBackground, width/2, height/2, 70, 70);
  } else if (tempBackground != null) {
    tint(255, 250, 250, 210);
    image(tempBackground, width/2, height/2, 700, 700);
  }
  popMatrix();


  pushMatrix();
  translate(width / 2f, height / 2f);
  floor.update();
  floor.display();
  popMatrix();


  pushMatrix();
    if (overlayImage != null) {
     image(overlayImage, width/2, height/2, 700, 700);
    }
   popMatrix();
}


void keyPressed() {
  //Reset
  if (key == '0') {
    fixedBackground = null;
    tempBackground = null;
    overlayImage = null;
    seeEllipse1 = false;
    seeEllipse2 = false;
    seeApollonius = false;
    seeText = false;
  }

    if (key == 'z') {  
     seeText = true;
  }

  //Temporal
  if (key == '1') {
   //tint(250, 250, 250, 200);
   tempBackground = imgBike;
  }
  
    if (key == '2') {
    //tint(250, 250, 250, 200);
    tempBackground = imgStairs; 
  }
  
    if (key == '3') {
   // tint(250, 250, 250, 200);
    tempBackground = imgWall;  
  }
  
   if (key == '4') {
   tint(250, 250, 250, 80);
   tempBackground = imgPlayground;  
  }
  
   if (key == '5') {
   //tint(250, 250, 250, 80);
   tempBackground = imgSea;  
  }
   
   if (key == '6') {
    tint(250, 250, 250, 180);
     tempBackground = imgMetro;  
  }
   
   if (key == '7') {
    tint(250, 250, 250, 180);
     tempBackground = imgMoon;  
  }
   
 
    if (key == 'z') {
    tint(250, 250, 250, 200);
    seeText = true;
  }
 
  if (key == 'a') {
    seeEllipse1 = true;
  }
  
   if (key == 's') {  
     seeEllipse2 = true;
  }
   
   if (key == 'd') {  
     seeApollonius = true;
  }
    
}

  

void keyReleased() {
  // Al soltar la tecla, quitar temporal
  if (key == 'a' || key == 's') {
    seeEllipse1 = false;
    seeEllipse2 = false;
  }
}
