class Homing extends Projectile
{ 
  Homing(Ship s, float x, float y, Enemy t)
  {
    super(s, x, y);
    damage = 30;
    xSpeed = ((t.xPos - s.xPos) / 10);
    ySpeed = (((s.yPos - t.yPos) / 10) - t.ySpeed);
    image = homingPic;
  }
}
