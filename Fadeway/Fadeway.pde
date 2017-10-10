import ddf.minim.*;
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
double itemChance = 0.99, itemTimer;
boolean keys[] = new boolean[128];
PImage grass,zomImg,playerImg;
void setup(){
  size(1400,1000);
  
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

void loadGame(){
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

void draw(){
  update();
  if(mainMenu){
    fill(0);
    textSize(40);
    textAlign(CENTER);
    text("FADEWAY",width/2, height/2);
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
void update(){
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
      player.fireRate*=0.9;
      //put up a message or soemthing TODO
      lightFlash();
      startRound();
    }
    
    // Update Lighting
    if(fade!=255){
      fade+=2;
      if(lighting){
        if(fade<125)
          fade+=3;
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
void startRound(){
  zom.clear();
  for(int x=0; x<round*3; x++){
    if(random(1)<0.5){  //top or bott
      zom.add(new Zombie((int)random(width),(random(1)<0.5?-20:height+20)));
    }
    else{
      zom.add(new Zombie((random(1)<0.5?-20:width+20),(int)random(height)));
    }
  }
  if(random(1)<itemChance){
    item.add(new Item((int)random(0,width),(int)random(0,height)));
  }
}
void lightFlash(){
  fade = 0;
  lightTimer = millis();
  lighting = true;
  lightSound.rewind();
  lightSound.play();
}

void checkKeys(){
  
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
void keyTyped(){
  if(game){
    if(keys['f']){    // disable! only for testing
      sunMode = !sunMode;
      round = 30;
      startRound();
    }
  }
  else if(pause){
  }
}
void mousePressed(){
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
void keyPressed(){
  keys[key] = true;
}
void keyReleased(){
  keys[key] = false;
}