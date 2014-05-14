class Fighter extends Enemy
{
  Fighter(float x, float y)
  {
    super(x, y);
    xSpeed = 0;
    ySpeed = 2;
    health = 30;
    attackTimer = 40;
    image = fighterPic;
    xSize = image.width;
    ySize = image.height;
    collideDamage = 20;
    scoreBonus += 50;
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
      attackTimer = 40;
      attack();
    }
  }
  
  void attack()
  {
    theProjectileManager.addProjectile(new FighterAttack(this, xPos, yPos));
  }
}
