class Zombie extends Charecter{
  
  Zombie(int x, int y){
    pos = new PVector(x, y);
    size = 30;
    speed = 3.5;
    col =  color(255,40,40);
  }
  
  void drawZombie(PImage img, PVector play){
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
  void runAi(PVector play, ArrayList<Zombie> zs){
    PVector c = play.copy();
    pos.add(c.sub(pos).normalize().mult(speed));
    for(int x=0; x<zs.size(); x++)
      if(zs.get(x).pos != pos && checkColl(zs.get(x)))
        pos.sub(zs.get(x).pos.copy().sub(pos).normalize().mult(speed*1.2));
    
  }
  void move(int x, int y){
    pos.add(speed*x,-speed*y);
  }
  void move(PVector v){
    v.normalize();
    pos.add(v.mult(speed));
  }
  
}