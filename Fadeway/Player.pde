class Player{
  PVector pos, dim;
  int size,speed;
  color col;
  Player(int x, int y){
    pos = new PVector(x, y);
    size = 20;
    speed = 5;
    col =  color(255,255,255);
  }
  
  void drawPlayer(){
    fill(col);
    ellipse(pos.x,pos.y,size,size);
  }
  
  void move(int x, int y){
    pos.add(speed*x,-speed*y);
  }
  void move(PVector v){
    v.normalize();
    pos.add(v.mult(speed));
  }
}