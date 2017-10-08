boolean mainMenu, game, pause, dead;
Button sButton;
int mainFade =0, fade=0;
Player player;
boolean lighting = false;
boolean keys[] = new boolean[128];

void setup(){
  size(1400,1000);
  mainMenu = true;
  game = false;
  sButton = new Button(width/2-50,height/2+100,100,40,"START");
  player = new Player(width/2, height/2);
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
    fill(0,0,0,fade);
    rect(0,0,width,height);
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
        mainFade = 0;
        sButton.clicked = false;
      }
      
    }
  }
  else if(game){
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
  }
  else if(pause){
  }
  else if(dead){
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
    if(keys['f']){
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
}
void keyPressed(){
  keys[key] = true;
}
void keyReleased(){
  keys[key] = false;
}