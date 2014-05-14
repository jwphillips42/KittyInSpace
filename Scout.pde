class Scout extends Enemy
{
  Scout(float x, float y)
  {
    super(x, y);
    xSpeed = 2;
    ySpeed = 2;
    health = 10;
    perlinIndex = random(0, 50000);
    image = scoutPic;
    xSize = image.width;
    ySize = image.height;
    collideDamage = 10;
    scoreBonus += 25;
  }
  
  void update()
  {
    float p = noise(perlinIndex);
    float deltaX = map(p, 0, 1, (-1 * xSpeed), xSpeed);
    xPos += deltaX;
    xPos = constrain(xPos, 0, width-10);
    yPos += ySpeed;
    perlinIndex += 0.01;
  }
}
