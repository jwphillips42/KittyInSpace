class Enemy extends Ship
{
  float xSpeed;
  float ySpeed;
  float collideDamage;
  float perlinIndex;
  
  int attackTimer;
  int scoreBonus;
  
  //Constructor
  Enemy(float x, float y)
  {
    xPos = x;
    yPos = y;
    collideDamage = 10;
    enemy = true;
  }
  
  //Update that will occur every frame
  void update()
  {
    yPos += ySpeed;
  }
  
  void damage(Projectile p)
  {
    health -= p.damage;
  }
  
  //Check whether an enemy has been destroyed
  boolean checkDestroyed()
  {
    //If the enemy goes off screen, destroy it
    if(yPos > height - 60) return true;
    //If the enemy has no more health, destroy it
    else if(health <= 0) 
    {
      score += scoreBonus;
      return true;
    }
    //If the enemy collides with the player, destroy it
    //And damage the player
    else if(yPos + (ySize/2) > thePlayer.yPos - (thePlayer.ySize/2) && yPos - (ySize/2) < thePlayer.yPos + (thePlayer.ySize/2)
      && xPos - (xSize/2) < thePlayer.xPos + (thePlayer.xSize/2) && xPos + (xSize/2) > thePlayer.xPos - (thePlayer.xSize/2))
      {
        thePlayer.damage(this);
        return true;
      }
    else return false;
  }
}
