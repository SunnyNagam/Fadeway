class Charecter{
  PVector pos, dim;
  int size,speed;
  boolean dead = false;
  color col;
  
  boolean checkColl(Bullet b){
    double rad = size/2;
    
    double dist = pos.copy().sub(b.pos).magSq();
    
    if(dist < (rad+b.size/2)*(rad+b.size/2))
      return true;
    
    return false;
    
  }
}