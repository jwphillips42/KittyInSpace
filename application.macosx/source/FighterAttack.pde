class FighterAttack extends Projectile
{
  FighterAttack(Ship s, float x, float y)
  {
    super(s, x, y);
    damage = 10;
    ySpeed = -7;
    image = fighterAttackPic;
  }
}
