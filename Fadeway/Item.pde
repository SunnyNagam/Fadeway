class Item extends Charecter{
  
  Item(int x, int y){
    pos = new PVector(x, y);
    size = 40;
    speed = 4;
    col =  color(255,255,0);
  }
  
  void drawItem(){
    fill(col);
    ellipse(pos.x,pos.y,size,size);
    /*
    pushMatrix();
    translate(pos.x,pos.y);
    float ang = PVector.angleBetween(play.copy().sub(pos),imgUnit);
    if(play.y<pos.y) ang*=-1;
    rotate(ang);
    image(img,-30,0-30);
    popMatrix();
    */
  } 
  
}