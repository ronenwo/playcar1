import gifAnimation.*;import processing.video.*;import gab.opencv.*;

Movie myMovie;
OpenCV opencv;

static final int ELEC_POLE = 0;
static final int ELEC_LINE = 1;
static final int LIGHT_POLE = 2;
static final int BIRD = 3;
static final int TREE = 4;
static final int SHARE = 5;
static final int IN = 6;
static final int FAN = 7;




PGraphics pg, gameLayer, animLayer, controlLayer;
PGraphics pglines[] = new PGraphics[3];
PImage  imgLast, elecpole, elecpole1, tree, realtree;
boolean mouseClicked = false;
boolean mouseDragged = false;

boolean gameLayerOn= false;
boolean animLayerOn= false;

float releasedX, releasedY;
float lastReleasedX, lastReleasedY;
float targetBirdX, targetBirdY;

int objType = ELEC_POLE;



Animation birdAnim;



ArrayList<Animation> birdsPool = new ArrayList<Animation>(); 
ArrayList<Animation> greenBirdsPool = new ArrayList<Animation>(); 
ArrayList<Animation> birds = new ArrayList<Animation>(); 

float xpos;
float ypos;
float drag = 30.0;

void setup() {

  size(1320, 800);
  
  noStroke();
  
  prepareLinesGraphics();
  
  animLayer = createGraphics(width, height);
  
  for(int i=0; i<10; i++){
    Animation birdAnim = new Animation(animLayer,"golub0",2,0,0);
    birdsPool.add(birdAnim);  
    birdAnim = new Animation(animLayer,"bird_color_red",2,0,0);
    birdsPool.add(birdAnim);  
    birdAnim = new Animation(animLayer,"bird_color_green",2,0,0);
    greenBirdsPool.add(birdAnim);  
  }
  
  myMovie = new Movie(this, "car1.mp4");
  myMovie.loop();
//  imgLast = createImage(myMovie.width,myMovie.height,RGB);
  elecpole = loadImage("pole1.png");
  elecpole1 = loadImage("real-pole2.png");
  tree = loadImage("tree1.png");
  realtree = loadImage("realtree.png");
//  realtree = loadImage("real-pole2.png");
//  elecpole = loadImage("dove1.gif");
  
//  doveGif1.play();
  frameRate(30);
  gameLayer = createGraphics(width, height);
  
  controlLayer = createGraphics(width, height);
  pg = createGraphics(400, 500);  
}


void prepareLinesGraphics() {
  PImage[] ls = new PImage[3];
  ls[0] = loadImage("dpower_lines1.png");
  ls[1]  = loadImage("dpower_lines2.png");
  ls[2]  = loadImage("dpower_lines3.png");
  for (int i=0; i<3; i++) {
    pglines[i] = createGraphics(200, 100);
    pglines[i].beginDraw();
    pglines[i].background(255,0);
    pglines[i].image(ls[i],0,0);
    pglines[i].endDraw();
  }
}

void draw() {
  image(myMovie, 0, 0,width,height);

  if (mouseClicked || mouseDragged){
    if (mouseDragged){
      switch (objType){
         case ELEC_POLE:{
            PImage pole = elecpole;
            if (mouseY<(height/2)){
               pole = elecpole1; 
            }
              pg.beginDraw();
              pg.background(255,0);
              pg.image(pole,0,0);
              pg.endDraw();
            
            break;
         } 
         case TREE:{
            PImage tr = tree;
            if (mouseY<(height/2)){
               tr = realtree; 
            }
              pg.beginDraw();
              pg.background(255,0);
              pg.image(tr,0,0);
              pg.endDraw();
            
            break;
         } 
         case ELEC_LINE:{
           int currFrame = frameCount % 3;
           int count = frameCount % Math.round(frameRate);
           count = Math.round(count / 3) + 1;
           count = count % 3; 
           if (mousePressed) {
              image(pglines[count], mouseX, mouseY);
           }
          
            
            break;
         } 
      }
    }
    image(pg,mouseX,mouseY);
  }
  if (gameLayerOn){
    image(gameLayer,0,0);
  }
  controlLayer.beginDraw();
  controlLayer.background(255,0);
  controlLayer.fill(255);    
  controlLayer.rect(0,0,50,50);
  controlLayer.rect(width-50,0,width,50);
  controlLayer.rect(0,height-50,50,height);
  controlLayer.rect(width-50,height-50,width,height);  
  controlLayer.endDraw();
  image(controlLayer,0,0);
  
  if (animLayerOn){
    if (objType == FAN){
        targetBirdX = mouseX;
        targetBirdY = mouseY;
    }
    float dx = targetBirdX - xpos;
    xpos = xpos + dx/drag;
    float dy = targetBirdY - ypos;
    ypos = ypos + dy/drag;
    println("xpos="+xpos);
    println("ypos="+ypos);
    animLayer.beginDraw();
    animLayer.background(255,0);
      Animation lastBird = !birds.isEmpty() ? birds.get(0) : null;
      if (lastBird != null){
        boolean first = true;
        for(Animation bird : birds){
            if (first){
              if (Math.abs(targetBirdX-xpos)<10 && Math.abs(targetBirdY-ypos)<10){
                bird.displayTarget(50,35);
                if (objType == IN){
                   objType = FAN; 
                } else if (objType == FAN){
                   objType = BIRD; 
                }
              }
              else{
                bird.display(xpos,ypos,50,35);
              }
              first = false;
            }
            else{
                bird.displayTarget(50,35);
            }
        }
      }
    
    //ec7f14
    
//   animLayer.image(doveGif1,width/2,height/2);
    animLayer.endDraw();
    image(animLayer,0,0);
  }
}


void drawLines(){
//    noFill();
    
    if (mousePressed){
      pg.background(255,0);
      pg.stroke(255,127,0);
      for(int i=0; i<3; i++){
        pg.beginShape();
        int y = i * 13 ;
        float dx0 = random(15,17);
        float dy0 = random(20,22);
        pg.curveVertex(mouseX-dx0,y + mouseY-dy0);
        pg.curveVertex(mouseX-dx0,y + mouseY-dy0);
        pg.curveVertex(mouseX-random(25,27),y + mouseY-random(20,22));
        pg.curveVertex(mouseX-random(30,33),y + mouseY-random(23,25));
        pg.curveVertex(mouseX-random(70,72),y + mouseY-random(25,27));
        float dx = random(90,92) + y / 2;
        float dy = random(30 + y,35+ y) + y / 2;
        pg.curveVertex(mouseX-dx,y + mouseY-dy);
        pg.curveVertex(mouseX-dx,y + mouseY-dy);
        pg.endShape();
      }
    }
}

void movieEvent(Movie movie) {
  myMovie.read();
}


void playBirdOut(){
   Animation birdAnim = birds.get(0);
   if (birdAnim!=null){
     targetBirdX = width/2;
     targetBirdY = -100;
     xpos = birdAnim.getX();
     ypos = birdAnim.getY();      
     birdAnim.update(targetBirdX,targetBirdY);
     animLayerOn = true;
   }

  }


void playBirdIn(){
  
  if (birdsPool.isEmpty()){
     return;
  }  
  animLayerOn = true;
   Animation birdAnim = birdsPool.remove(0);
   birdAnim.update(targetBirdX,targetBirdY);
   birds.add(0,birdAnim);
   
   println("play bird in");
   println("last x="+lastReleasedX);
   println("last y="+lastReleasedY);  
   xpos = random(width);
   ypos = 0;

}

void mousePressed() {
//   myMovie.pause();
//   objType = ELEC_POLE;
  println("mousePressed objType="+objType);
   
   if (objType == BIRD)  // left button
   {
     targetBirdX = mouseX;
     targetBirdY = mouseY;
     println("target bird x="+targetBirdX);
     println("target bird y="+targetBirdY);
     playBirdIn();
     println("elec line type");
     return;
   }
   else if (isLeftTopCorner()){
      objType = ELEC_LINE;
      println("elec line type"); 
   }
   lastReleasedX = releasedX;
   lastReleasedY = releasedY;
//   println("last x="+lastReleasedX);
//   println("last y="+lastReleasedY);
   releasedX = 0;
   releasedY = 0;
//   imgLast = createImage(100,100,RGB);
//   imgLast.copy(myMovie,mouseX,mouseY,100,100,0,0,100,100); // Before we read the new frame, we always save the previous frame for comparison!
//   imgLast.updatePixels();
   pg.beginDraw();
   pg.background(255,0);
   println("objType="+objType);
   switch (objType){
     case ELEC_POLE:{
       pg.image(elecpole1,0,0);
       break;
     }
     case ELEC_LINE:{
//       drawLines1();   
       break;
     }
   }
 
//   pg.image(imgLast,0,0);
   pg.endDraw();
   image(pg,mouseX,mouseY);
   mouseClicked = true;
}




void mouseDragged(){
  println("mouseDragged objType="+objType);
  mouseDragged = true;
//   image(pg,mouseX,mouseY);    
}  

boolean isLeftTopCorner(){
    if (mouseX<50 && mouseY<50){
       return true; 
    }
    return false;
}

boolean isRightTopCorner(){
    if (mouseX>width-50 && mouseY<50){
       return true; 
    }
    return false;
}

boolean isLeftBottomCorner(){
    if (mouseX<50 && mouseY>height-50){
       return true; 
    }
    return false;
}

boolean isRightBottomCorner(){
    if (mouseX>width-50 && mouseY>height-50){
       return true; 
    }
    return false;
}



void keyPressed() {
  println("keyPressed="+key);
  println("keyPressed="+keyCode);
    if (key == 'e') {
      objType = ELEC_POLE;
    } else if (key == 'l') {
      objType = ELEC_LINE;
    } else if (key == 'b') {
      objType = BIRD;
    } else if (key == 'L') {
      objType = LIGHT_POLE;
    } else if (key == 't') {
      objType = TREE;
    } else if (key == 's') {
      objType = SHARE;
      playBirdOut();
    } else if (key == 'd') {
      objType = IN;
      targetBirdX = mouseX;
      targetBirdY = mouseY;
      playBirdIn();
    }

    println("keyPressed objType="+objType);
  

}

void setObjType(){
    
  
}

void mouseReleased() {
   mouseClicked = false;
   mouseDragged = false;
   println("mouseReleased objType="+objType);
   gameLayer.beginDraw();
//   gameLayer.background(255,0);
   releasedX = mouseX;
   releasedY = mouseY;
   println("released x="+releasedX);
   println("released y="+releasedY);
   switch(objType){
      case ELEC_POLE:{
         gameLayer.image(elecpole,mouseX,mouseY);
         break;    
      } 
      case TREE:{
         gameLayer.image(tree,mouseX,mouseY);
         targetBirdX = mouseX;
         targetBirdY = mouseY;
         playBirdIn();
         break;    
      } 
      case SHARE:{
         playBirdOut();
         break;    
      } 
      case ELEC_LINE:{
         gameLayer.strokeWeight(4); 
         gameLayer.stroke(255,127,0);        
//         gameLayer.curve((float)mouseX,(float)mouseY,(float)mouseX+50,(float)mouseY+10.0,(float)mouseX+100,(float)mouseY,(float)mouseX+200,(float)mouseY+10);
         gameLayer.line((float)mouseX,(float)mouseY,(float)mouseX+500,(float)mouseY);
         break;    
      } 
   }
   
   gameLayer.endDraw();
   gameLayerOn = true;  
//   myMovie.play();
}