class Missile extends Projectile
{
  Missile(Ship s, float x, float y)
  {
    super(s, x, y);
    damage = 30;
    ySpeed = 1;
    acceleration = 0.1;
    image = missilePic;
  }
}
