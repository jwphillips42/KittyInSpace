class Projectile
{
  Ship owner;
  float damage;
  float xPos;
  float yPos;
  float xSpeed;
  float ySpeed;
  float acceleration;
  int arrayIndex;
  PImage image;
  float xSize;
  float ySize;
  
  Projectile(Ship s, float x, float y)
  {
    owner = s;
    xPos = x;
    yPos = y;
    damage = 5.0;
    xSpeed = 0;
    ySpeed = 5;
    acceleration = 0;
  }
  
  boolean checkCollide(Ship s)
  {
    if(s.enemy != owner.enemy)
    {
      if(s.image == destroyerPic)
      {
        if(yPos + (ySize/2) > s.yPos - (s.ySize/2) && yPos - (ySize/2) < s.yPos + (s.ySize/2)
            && xPos - (xSize/2) < s.xPos + (s.xSize/2) && xPos + (xSize/2) > s.xPos - (s.xSize/2))
            {
              return true;
            }
      }
      else if(dist(xPos, yPos, s.xPos, s.yPos) < 15)
      {
        return true;
      } 
    }
    return false;
  }
  
  boolean checkDestroyed()
  {
    if(yPos < -2) return true;
    else if(yPos > (height   + 2)) return true;
    else if(checkCollide(thePlayer))
    {
      thePlayer.damage(this);
      return true;
    }
    else
    {
      for(int i = 0; i < theEnemyManager.enemyCount; i++)
      {
        if(checkCollide(theEnemyManager.enemies[i]))
        {
          theEnemyManager.enemies[i].damage(this);
          return true;
        }
      }
    }
    return false;
  }
  
  void update()
  {
    if(ySpeed < 8) ySpeed += acceleration;
    xPos += xSpeed;
    yPos -= ySpeed;
    if(checkDestroyed()) theProjectileManager.removeProjectile(this);
  }
  
  void display()
  {
    image(image, xPos, yPos);
  }
}
