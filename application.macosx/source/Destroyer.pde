class Destroyer extends Enemy
{
  Destroyer(float x, float y)
  {
    super(x, y);
    xSpeed = 0;
    ySpeed = 1;
    health = 90;
    attackTimer = 30;
    image = destroyerPic;
    xSize = image.width;
    ySize = image.height;
    collideDamage = 50;
    scoreBonus += 100;
  }
  
  void update()
  {
    yPos += ySpeed;
    if(attackTimer > 0)
    {
      attackTimer--;
    }
    else
    {
      attackTimer = 30;
      attack();
    }
  }
  
  void attack()
  {
    theProjectileManager.addProjectile(new DestroyerAttack(this, xPos, yPos));
  }
}
