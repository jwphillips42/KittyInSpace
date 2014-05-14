class Ship
{
  float xPos;
  float yPos;
  float health;
  PImage image;
  float xSize;
  float ySize;
  boolean enemy;
  
  void display()
  {
    image(image, xPos, yPos);
  }
}
