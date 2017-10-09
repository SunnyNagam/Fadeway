boolean mainMenu, game, pause, dead;
Button sButton;
int mainFade =0, fade=0;
Player player;
ArrayList<Zombie> zom;
ArrayList<Bullet> bul;
int round = 1, score;
boolean lighting = false;
double lightTime = 5, lightTimer=0;
boolean keys[] = new boolean[128];

void setup(){
  size(1400,1000);
  mainMenu = true;
  game = false;
  sButton = new Button(width/2-50,height/2+100,100,40,"START");
  player = new Player(width/2, height/2);
  zom = new ArrayList<Zombie>();
  bul = new ArrayList<Bullet>();
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
  
  else if(game){
    fill(255);
    rect(0,0,width,height);
    
    player.drawPlayer();
    
    for(int x=0; x<zom.size(); x++)
      zom.get(x).drawZombie();
    for(int x=0; x<bul.size(); x++)
      bul.get(x).drawBullet();
    
    fill(0,0,0,fade);
    rect(0,0,width,height);
    
    //HUD STUFF
    fill(100,0,200);
    textSize(20);
    text(new String("Score: "+score),100,height-20);
  }
  
  else if(pause){
  }
  
  else if(dead){
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
        startRound();
        mainFade = 0;
        sButton.clicked = false;
      }
      
    }
  }
  else if(game){
    // Update Zombies
    
    //Ai movement (zombie)
    for(int x=0; x<zom.size(); x++)
      zom.get(x).runAi(player.pos);
      
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
      lightTimer = millis();
      lightFlash();
    }
    
  }
  else if(pause){
  }
  else if(dead){
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
}
void lightFlash(){
  fade = 0;
  lighting = true;
}

void checkKeys(){
  
  if(game){
    //kprintln("yo "+keys['a']+", "+keys['d']+", "+(char)key);
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
      println("Wow");
      lightFlash();
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
    return;
  }
  else if(game){
    player.shoot(bul);
  }
}
void keyPressed(){
  keys[key] = true;
}
void keyReleased(){
  keys[key] = false;
}