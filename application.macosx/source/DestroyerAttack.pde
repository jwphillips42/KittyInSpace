class DestroyerAttack extends Projectile
{
  DestroyerAttack(Ship s, float x, float y)
  {
    super(s, x, y);
    damage = 5;
    ySpeed = -4;
    xSpeed = random(-3, 3);
    image = destroyerAttackPic;
  }
}
