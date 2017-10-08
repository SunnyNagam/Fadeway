class Button{
  PVector pos, dim;
  String text;
  boolean clicked = false;
  Button(int x, int y, int wid, int hei, String tex){
    pos = new PVector(x,y);
    dim = new PVector(wid, hei);
    text = tex;
    clicked = false;
  }
  
  void drawButton(){
    fill(255);
    rect(pos.x,pos.y,dim.x,dim.y);
    fill(0);
    textSize(22);
    text(text,pos.x+dim.x/2,pos.y+dim.y/2+10);
  }
  
  boolean contains(int x, int y){
    return x>pos.x && x<pos.x+dim.x && y>pos.y && y<pos.y+dim.y;
  }
}