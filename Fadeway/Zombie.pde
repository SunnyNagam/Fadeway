class Zombie extends Charecter{
  
  Zombie(int x, int y){
    pos = new PVector(x, y);
    size = 20;
    speed = 2;
    col =  color(255,40,40);
  }
  
  void drawZombie(){
    fill(col);
    ellipse(pos.x,pos.y,size,size);
  }
  void runAi(PVector play){
    PVector c = play.copy();
    pos.add(c.sub(pos).normalize().mult(speed));
  }
  void move(int x, int y){
    pos.add(speed*x,-speed*y);
  }
  void move(PVector v){
    v.normalize();
    pos.add(v.mult(speed));
  }
  
}