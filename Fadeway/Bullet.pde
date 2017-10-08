class Bullet{
  PVector pos, dir;
  int size,speed;
  color col;
  boolean del = false;
  
  Bullet(float x, float y, float dx, float dy){
    pos = new PVector(x, y);
    size = 5;
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
  
  void drawBullet(){
    fill(col);
    ellipse(pos.x,pos.y,size,size);
  }
  void update(ArrayList<Bullet> buls, ArrayList<Zombie> zoms, Player p){
    if(pos.x<0||pos.x>width||pos.y<0||pos.y>height){
      del = true;
      return;
    }
    pos.add(dir);
    
    
      
  }
}