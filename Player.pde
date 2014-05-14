class Player extends Ship
{  
  //Weapons Array
  //[SLOT][ENTRY]
  int[][] weapons;
  float[][] chargePctg;
  char[] weaponSlotIndexes;
  boolean weaponCharged;
  int missilesToFire;
  int spreadToFire;
  int homingToFire;
  int missileDelay;
  int spreadDelay;
  int homingDelay;
  float chargeSum;
  float targetChargeSum;
  
  //Constructor
  Player(float x, float y)
  {
    xPos = x;
    yPos = y;
    health = 100;
    weapons = new int[3][5];
    chargePctg = new float[3][5];
    weaponSlotIndexes = new char[] {'a', 's', 'd'};
    missileDelay = 5;
    spreadDelay = 3;
    weaponCharged = false;
    image = playerPic;
    xSize = image.width;
    ySize = image.height;
    enemy = false;
  }
  
  //Update that runs every frame
  void update()
  {
    move();
    chargeLoadedWeapons();
    fire();
  }
  
  //Handles the movement of the ship
  void move()
  {
    if(keyPressed && key == CODED)
    {
      if(keyCode == RIGHT)
      {
        xPos += 5;
      }
      else if(keyCode == LEFT)
      {
        xPos -= 5;
      }
      
      xPos = constrain(xPos, 25, width-25);
    }
  }
  
  //Charges the weapons that have been loaded
  void chargeLoadedWeapons()
  {
    for(int i = 0; i < weapons.length; i++)
    {
      for(int j = 0; j < weapons[i].length; j++)
      {
        if(weaponCharged == false)
        {
          if(weapons[i][j] == 0){}  //Don't do anything, just pulls the 0-case out
          //MISSILES
          else if(weapons[i][j] == 1 && chargePctg[i][j] < 100)
          {
            chargePctg[i][j] += 2;
            weaponCharged = true;
          }
          //SPREAD
          else if(weapons[i][j] == 2 && keyPressed && key == weaponSlotIndexes[i] && chargePctg[i][j] < 100)
          {
            chargePctg[i][j] += 8;
            weaponCharged = true;
          }
          //HOMING
          else if(weapons[i][j] == 3 && keyPressed && key == weaponSlotIndexes[i] && chargePctg[i][j] < 100)
          {
            chargePctg[i][j] += 4;
            weaponCharged = true;
          }
          else if(chargePctg[i][j] > 0 && chargePctg[i][j] < 99)
          {
            chargePctg[i][j]--;
          }
        }
      }
      weaponCharged = false;
    }
  }
  
  //Handles the firing of weapons that are fully charged and have been launched
  void fire()
  {
    if(missilesToFire > 0)
    {
      if(missileDelay > 0) missileDelay--;
      else
      {
        missilesToFire--;
        theProjectileManager.addProjectile(new Missile(this, xPos, yPos));
        missileDelay = 5;
      }
    }
    if(spreadToFire > 0)
    {
      if(spreadDelay > 0) spreadDelay--;
      else
      {
        spreadToFire--;
        theProjectileManager.addProjectile(new Spread(this, xPos, yPos));
        spreadDelay = 2;
      }
    }
    if(homingToFire > 0)
    {
      if(homingDelay > 0) homingDelay--;
      else
      {
        homingToFire--;
        theProjectileManager.addProjectile(new Homing(this, xPos, yPos, theEnemyManager.randomEnemy()));
        homingDelay = 0;
      }
    }
  }
  
  //Prepare weapons to load/charge. Commits to firing that weapon
  //Takes weapon slot, type as an argument
  //0 - Missile (stored here as a 1)
  //1 - Spread (stored here as a 2)
  //2 - Homing (stored here as a 3)
  void load(int s, int w)
  {
    int sum = 0;
    int zeroIndex = 10;
    int oneIndex = -1;
    int twoIndex = -1;
    int threeIndex = -1;
    
    for(int i = 0; i < weapons[s].length; i++)
    {
      //Find the last instance of a 1
      if(weapons[s][i] == 1)
      {
        oneIndex = i;
        sum++;
      }
      //Find the last instance of a 2
      else if(weapons[s][i] == 2)
      {
        twoIndex = i;
        sum++;
      }
      //Find the last instance of a 3
      else if(weapons[s][i] == 3)
      {
        threeIndex = i;
        sum++;
      }
      //Find the first instance of a 0
      else if(i < zeroIndex) zeroIndex = i;
    }
    
    if(twoIndex == -1) twoIndex = oneIndex;
    if(threeIndex == -1) threeIndex = twoIndex;
    
    if(sum < weapons[s].length)
    {
      //If loading a missile
      if(w == 0)
      {
        for(int i = (weapons[s].length - 1); i > (oneIndex+1); i--)
        {
          weapons[s][i] = weapons[s][i-1];
        }
        weapons[s][oneIndex+1] = 1;
      }
      //If loading a spread
      else if(w == 1)
      {
        for(int i = (weapons[s].length - 1); i > (twoIndex+1); i--)
        {
          weapons[s][i] = weapons[s][i-1];
        }
        weapons[s][twoIndex+1] = 2;
        
      }
      //If loading a homing
      else if(w == 2)
      {
        for(int i = (weapons[s].length - 1); i > (threeIndex+1); i--)
        {
          weapons[s][i] = weapons[s][i-1];
        }
        weapons[s][threeIndex+1] = 3;
        
      }
    }
  }
  
  //Method called from main class when key released to attempt firing
  //This is the actual trigger for firing weapons
  void attemptFire(int slot)
  {
      targetChargeSum = 0;
      chargeSum = 0;
      for(int i = 0; i < weapons[slot].length; i++)
      {
        if(weapons[slot][i] != 0) targetChargeSum+=100;
        chargeSum += chargePctg[slot][i];
      }
      if(chargeSum >= targetChargeSum)launchVolley(slot);
  }
  
  //Converts loaded/charged weapons into ones to fire
  void launchVolley(int slot)
  {
    for(int i = 0; i < weapons[slot].length; i++)
    {
      if(weapons[slot][i] == 1)
      {
        missilesToFire++;
        weapons[slot][i] = 0;
        chargePctg[slot][i] = 0;
      }
      else if(weapons[slot][i] == 2)
      {
        spreadToFire+=4;
        weapons[slot][i] = 0;
        chargePctg[slot][i] = 0;
      }
      else if(weapons[slot][i] == 3)
      {
        homingToFire++;
        weapons[slot][i] = 0;
        chargePctg[slot][i] = 0;
      }
    }
  }
  
  //Take damage from some enemy collision
  void damage(Enemy e)
  {
    health -= e.collideDamage;
    //If the player loses all health, game over
    if(health <= 0) state = 2;
  }
  
  //Take damage from collision with enemy projectile
  void damage(Projectile p)
  {
    health -= p.damage;
    if(health <= 0) state = 2;
  }
  
  boolean escapeAnimation()
  {
    if(xPos < width/2) xPos++;
    else if(xPos > width/2) xPos--;
    else if(xPos == width/2) yPos -= 5;
    image(image, xPos, yPos);
    if(yPos < -30) return true;
    else return false;
  }
}
