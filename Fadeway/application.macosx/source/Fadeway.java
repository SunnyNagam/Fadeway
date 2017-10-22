import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Fadeway extends PApplet {


Minim minim;
AudioPlayer lightSound, rain, simplegun;

boolean mainMenu, game, pause, dead;
Button sButton;

int mainFade =0, fade=0;
Player player;

ArrayList<Zombie> zom;
ArrayList<Bullet> bul;
ArrayList<Item> item;

int round = 1, score;
boolean lighting = false, sunMode = false, itemActive=false;
double lightTime = 5, lightTimer=0;
double itemChance = 0.6f, itemTimer;
boolean keys[] = new boolean[128];
PImage grass,zomImg,playerImg;
public void setup(){
  
  
  minim = new Minim(this);
  lightSound = minim.loadFile("thunder.mp3");
  rain = minim.loadFile("rain.mov");
  simplegun = minim.loadFile("simplegun.mp3");
  grass = loadImage("grass.jpg");
  grass.resize(1400,0);
  zomImg = loadImage("zombie.png");
  playerImg = loadImage("player.png");
  zomImg.resize(60,60);
  playerImg.resize(60,60);
  
  loadGame();
}

public void loadGame(){
  itemActive = false;
  itemTimer = millis();
  round =1;
  score = 0;
  lightTimer = millis();
  mainFade =0;
  mainMenu = true;
  game = false;
  sButton = new Button(width/2-50,height/2+100,100,40,"START");
  player = new Player(width/2, height/2);
  zom = new ArrayList<Zombie>();
  bul = new ArrayList<Bullet>();
  item = new ArrayList<Item>();
  background(255);
  textAlign(CENTER);
}

public void draw(){
  update();
  if(mainMenu){
    image(grass,0,0);
    fill(255);
    textSize(60);
    textAlign(CENTER);
    text("FADEWAY",width/2, height/4);
    textSize(30);
    text("DEFEND AGAINST THE WAVES OF ZOMBIES!",width/2, height/3+50);
    text("You can only see when there's lighting, so remember where ",width/2, height/3+100);
    text("the zombies and powerups are if you don't wanna die in the dark!",width/2,height/3+130);
    text("MOVE: W-A-S-D              SHOOT: CLICK",width/2, height/3+200);
    sButton.drawButton();
    fill(0,0,0,mainFade);
    rect(0,0,width,height);
  }
  
  else if(game || dead){
    fill(255);
    rect(0,0,width,height);
    image(grass,0,0);
    
    player.drawPlayer(playerImg);
    
    for(int x=0; x<zom.size(); x++)
      zom.get(x).drawZombie(zomImg,player.pos);
    for(int x=0; x<bul.size(); x++)
      bul.get(x).drawBullet();
    for(int x=0; x<item.size(); x++)
      item.get(x).drawItem();
    
    if(!sunMode && !dead){
      fill(0,0,0,fade);
      rect(0,0,width,height);
    }
    
    //HUD STUFF
    fill(255,255,255);
    textSize(20);
    text(new String("Score: "+score),100,height-20);
    text(new String("Round: "+round),600,height-20);
  }
  
  else if(pause){
  }
  
  if(dead){
    
    fill(255);
    textSize(40);
    textAlign(CENTER);
    text("FADEWAY",width/2, height/6);
    text("FINAL SCORE: "+score+" (Round "+round+")",width/2, height/4);
    sButton.drawButton();
    
  }
}
public void update(){
  checkKeys();
  
  if(mainMenu){
    
    if(sButton.clicked){
      
      if(mainFade<255)
        mainFade+=6;
        
      else{
        mainMenu=false;
        game = true;
        rain.rewind();
        rain.play();
        startRound();
        mainFade = 0;
        sButton.clicked = false;
      }
      
    }
  }
  else if(dead){
    if(sButton.clicked){
        dead = false;
        loadGame();
        mainMenu=false;
        game = true;
        startRound();
        fade = 0;
        sButton.clicked = false;
      
    }
    
    if(!rain.isPlaying()){
      rain.rewind();
      rain.play();
    }
    // Update Zombies
    
    //Ai movement (zombie)
    for(int x=0; x<zom.size(); x++){
      zom.get(x).runAi(player.pos, zom);
    }
  }
  else if(game){
    
    if(mousePressed){
    player.shoot(bul, simplegun);
    }
  
    if(!rain.isPlaying()){
      rain.rewind();
      rain.play();
    }
    // Update Zombies
    
    //Ai movement (zombie)
    for(int x=0; x<zom.size(); x++){
      zom.get(x).runAi(player.pos, zom);
      if(player.checkColl(zom.get(x))){
        dead = true;
      }
    }
    if(itemActive && millis() - itemTimer >= 5000){
      itemActive = false;
      player.fireRate *=5;
    }
    // item update
    for(int x=0; x<item.size(); x++){
      if(player.checkColl(item.get(x))){
        item.remove(x);
        x--;
        if(!itemActive){
          itemActive = true;
          // ITEM DOES THINGS HERE
          player.fireRate /= 5;
        }
        itemTimer = millis();
      }
    }
    
    //Bullet update
    for(int x=0; x<bul.size(); x++){
      bul.get(x).update(bul,zom,player);
      if(bul.get(x).del){
        bul.remove(x);
        x--;
        continue;
      }
      for(int y=0; y<zom.size(); y++){
        zom.get(y).checkColl(bul.get(x));
        if(zom.get(y).dead){
          score++;
          zom.remove(y);
          y--;
          bul.remove(x);
          x--;
          break;
        }
      }
    }
      
    //ROUND CLEAR
    if(zom.size()==0){
      round++;
      player.fireRate*=0.9f;
      //put up a message or soemthing TODO
      lightFlash();
      startRound();
    }
    
    // Update Lighting
    if(fade!=255){
      fade+=3.5f;
      if(lighting){
        if(fade<125)
          fade+=5;
        else{
          fade = 0;
          lighting = false;
        }
      }
    }
    
    if(millis()-lightTimer>lightTime*1000){
      lightFlash();
    }
    
  }
  else if(pause){
  }
}
public void startRound(){
  zom.clear();
  for(int x=0; x<round*3; x++){
    if(random(1)<0.5f){  //top or bott
      zom.add(new Zombie((int)random(width),(random(1)<0.5f?-20:height+20)));
    }
    else{
      zom.add(new Zombie((random(1)<0.5f?-20:width+20),(int)random(height)));
    }
  }
  if(random(1)<itemChance){
    item.add(new Item((int)random(0,width),(int)random(0,height)));
  }
}
public void lightFlash(){
  fade = 0;
  lightTimer = millis();
  lighting = true;
  lightSound.rewind();
  lightSound.play();
}

public void checkKeys(){
  
  if(game && !dead){
    if(keys['w'])
      player.move(0,1);
    if(keys['a'])
      player.move(-1,0);
    if(keys['s'])
      player.move(0,-1);
    if(keys['d'])
      player.move(1,0);
  }
  else if(pause){
  }
}
public void keyTyped(){
  if(game){
    if(keys['f']){    // disable! only for testing
    //  sunMode = !sunMode;
     // round = 30;
     // startRound();
    }
  }
  else if(pause){
  }
}
public void mousePressed(){
  if(mainMenu){
    if(sButton.contains(mouseX,mouseY)){
      sButton.clicked = true;
    }
  }
  else if(dead){
    if(sButton.contains(mouseX,mouseY)){
      sButton.clicked = true;
    }
  }
}
public void keyPressed(){
  keys[key] = true;
}
public void keyReleased(){
  keys[key] = false;
}
class Bullet{
  PVector pos, dir;
  int size,speed;
  int col;
  boolean del = false;
  
  Bullet(float x, float y, float dx, float dy){
    pos = new PVector(x, y);
    size = 10;
    speed = 10;
    dir = new PVector(dx,dy);
    dir.normalize().mult(speed);
    col =  color(255,255,255);
  }
  Bullet(PVector p, PVector d){
    pos = p;
    size = 5;
    speed = 10;
    dir = d;
    dir.normalize().mult(speed);
    col =  color(255,255,255);
  }
  
  public void drawBullet(){
    fill(col);
    ellipse(pos.x,pos.y,size,size);
  }
  public void update(ArrayList<Bullet> buls, ArrayList<Zombie> zoms, Player p){
    if(pos.x<0||pos.x>width||pos.y<0||pos.y>height){
      del = true;
      return;
    }
    pos.add(dir);
    
    
      
  }
}
class Button{
  PVector pos, dim;
  String text;
  boolean clicked = false;
  Button(int x, int y, int wid, int hei, String tex){
    pos = new PVector(x,y);
    dim = new PVector(wid, hei);
    text = tex;
    clicked = false;
  }
  
  public void drawButton(){
    fill(255);
    rect(pos.x,pos.y,dim.x,dim.y);
    fill(0);
    textSize(22);
    text(text,pos.x+dim.x/2,pos.y+dim.y/2+10);
  }
  
  public boolean contains(int x, int y){
    return x>pos.x && x<pos.x+dim.x && y>pos.y && y<pos.y+dim.y;
  }
}
class Charecter{
  PVector pos, dim, imgUnit = new PVector(1,0);
  float speed;
  int size;
  boolean dead = false;
  int col;
  
  public boolean checkColl(Bullet b){
    double rad = size/2;
    
    double dist = pos.copy().sub(b.pos).magSq();
    
    if(dist < (rad+b.size/2)*(rad+b.size/2)){
      dead = true;
      return true;
    }
    
    return false;
    
  }
  
  public boolean checkColl(Charecter c){
    double rad = size/2;
    
    double dist = pos.copy().sub(c.pos).magSq();
    
    if(dist < (rad+c.size/2)*(rad+c.size/2)){
      return true;
    }
    
    return false;
    
  }
}
class Item extends Charecter{
  
  Item(int x, int y){
    pos = new PVector(x, y);
    size = 40;
    speed = 4;
    col =  color(255,255,0);
  }
  
  public void drawItem(){
    fill(col);
    ellipse(pos.x,pos.y,size,size);
    /*
    pushMatrix();
    translate(pos.x,pos.y);
    float ang = PVector.angleBetween(play.copy().sub(pos),imgUnit);
    if(play.y<pos.y) ang*=-1;
    rotate(ang);
    image(img,-30,0-30);
    popMatrix();
    */
  } 
  
}
class Player extends Charecter{
  double fireRate = 0.6f, lastShot=0;
  Player(int x, int y){
    pos = new PVector(x, y);
    size = 30;
    speed = 4.1f;
    col =  color(0,0,255);
  }
  
  public void drawPlayer(PImage img){
    //fill(col);
    //ellipse(pos.x,pos.y,size,size);
    pushMatrix();
    translate(pos.x,pos.y);
    float ang = PVector.angleBetween(new PVector(mouseX,mouseY).copy().sub(pos),imgUnit);
    if(mouseY<pos.y) ang*=-1;
    rotate(ang);
    image(img,-30,0-30);
    popMatrix();
  }
  
  public void move(int x, int y){
    pos.add(speed*x,-speed*y);
    if(pos.x<0 || pos.x>width || pos.y<0 || pos.y>height)
      pos.sub(speed*x,-speed*y);
  }
  
  public void move(PVector v){
    v.normalize();
    pos.add(v.mult(speed));
  }
  
  public void shoot(ArrayList<Bullet> bul, AudioPlayer gunshot){
    if(millis()-lastShot >fireRate*1000){
      lastShot = millis();
      gunshot.rewind();
      gunshot.play();
      bul.add(new Bullet(pos.x, pos.y, mouseX-pos.x,mouseY-pos.y));
    }
  }
}
class Zombie extends Charecter{
  
  Zombie(int x, int y){
    pos = new PVector(x, y);
    size = 30;
    speed = 4;
    col =  color(255,40,40);
  }
  
  public void drawZombie(PImage img, PVector play){
    //fill(col);
    //ellipse(pos.x,pos.y,size,size);
    pushMatrix();
    translate(pos.x,pos.y);
    float ang = PVector.angleBetween(play.copy().sub(pos),imgUnit);
    if(play.y<pos.y) ang*=-1;
    rotate(ang);
    image(img,-30,0-30);
    popMatrix();
  }
  public void runAi(PVector play, ArrayList<Zombie> zs){
    PVector c = play.copy();
    pos.add(c.sub(pos).normalize().mult(speed));
    for(int x=0; x<zs.size(); x++)
      if(zs.get(x).pos != pos && checkColl(zs.get(x)))
        pos.sub(zs.get(x).pos.copy().sub(pos).normalize().mult(speed*1.2f));
    
  }
  public void move(int x, int y){
    pos.add(speed*x,-speed*y);
  }
  public void move(PVector v){
    v.normalize();
    pos.add(v.mult(speed));
  }
  
}
  public void settings() {  size(1400,1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Fadeway" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
