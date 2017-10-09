class Player extends Charecter{
  double fireRate = 0.6, lastShot=0;
  Player(int x, int y){
    pos = new PVector(x, y);
    size = 30;
    speed = 4.1;
    col =  color(0,0,255);
  }
  
  void drawPlayer(PImage img){
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
  
  void move(int x, int y){
    pos.add(speed*x,-speed*y);
    if(pos.x<0 || pos.x>width || pos.y<0 || pos.y>height)
      pos.sub(speed*x,-speed*y);
  }
  
  void move(PVector v){
    v.normalize();
    pos.add(v.mult(speed));
  }
  
  void shoot(ArrayList<Bullet> bul, AudioPlayer gunshot){
    if(millis()-lastShot >fireRate*1000){
      lastShot = millis();
      gunshot.rewind();
      gunshot.play();
      bul.add(new Bullet(pos.x, pos.y, mouseX-pos.x,mouseY-pos.y));
    }
  }
}