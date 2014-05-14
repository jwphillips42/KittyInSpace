class Spread extends Projectile
{
  Spread(Ship s, float x, float y)
  {
    super(s, x, y);
    damage = 10;
    ySpeed = 4;
    xSpeed = random(-3, 3);
    image = spreadPic;
  }
}
