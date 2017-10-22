class Charecter{
  PVector pos, dim, imgUnit = new PVector(1,0);
  float speed;
  int size;
  boolean dead = false;
  color col;
  
  boolean checkColl(Bullet b){
    double rad = size/2;
    
    double dist = pos.copy().sub(b.pos).magSq();
    
    if(dist < (rad+b.size/2)*(rad+b.size/2)){
      dead = true;
      return true;
    }
    
    return false;
    
  }
  
  boolean checkColl(Charecter c){
    double rad = size/2;
    
    double dist = pos.copy().sub(c.pos).magSq();
    
    if(dist < (rad+c.size/2)*(rad+c.size/2)){
      return true;
    }
    
    return false;
    
  }
}