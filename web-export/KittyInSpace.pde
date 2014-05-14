Player thePlayer;
EnemyManager theEnemyManager;
ProjectileManager theProjectileManager;
HUD theHUD;

//0 = Pregame
//1 = Gameplay
//2 = Game Over
int state;

void setup()
{
  size(500, 800);
  noStroke();
  
  thePlayer = new Player(width / 2, height - 125);
  theEnemyManager = new EnemyManager();
  theProjectileManager = new ProjectileManager();
  
  theHUD = new HUD();
  
  state = 0;
}

void draw()
{
  if(state == 0) preGame();
  else if(state == 1) gameplay();
  else if(state == 2) gameOver();
}

void preGame()
{
  background(0);
  state = 1;
}

void gameplay()
{
  background(0);
  managePlayer();
  theEnemyManager.manageEnemies();
  theProjectileManager.manageProjectiles();
  theHUD.display();
}

void gameOver()
{
  background(0);
  fill(255);
  textSize(20);
  textAlign(CENTER);
  text("GAME OVER", width/2, height/2);
}

void managePlayer()
{
  thePlayer.update();
  thePlayer.display();
}

void keyPressed()
{
  if(key == '1') thePlayer.load(0, 0);
  else if(key == '2') thePlayer.load(0, 1);
  else if(key == '3') thePlayer.load(0, 2);
  else if(key == '4') thePlayer.load(1, 0);
  else if(key == '5') thePlayer.load(1, 1);
  else if(key == '6') thePlayer.load(1, 2);
  else if(key == '7') thePlayer.load(2, 0);
  else if(key == '8') thePlayer.load(2, 1);
  else if(key == '9') thePlayer.load(2, 2);
  else if(key == 'a') thePlayer.fire(0);
  else if(key == 's') thePlayer.fire(1);
  else if(key == 'd') thePlayer.fire(2);
}
class Enemy extends Ship
{
  float xSpeed;
  float ySpeed;
  float collideDamage;
  float perlinIndex;
  
  //Constructor
  Enemy(float x, float y)
  {
    xPos = x;
    yPos = y;
    collideDamage = 10;
  }
  
  //Update that will occur every frame
  void update()
  {
    yPos += ySpeed;
  }
  
  //Draw the enemy to the screen
  void display()
  {
    fill(255, 0, 0);
    rect(xPos, yPos, 10, 10);
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
    else if(health <= 0) return true;
    //If the enemy collides with the player, destroy it
    //And damage the player
    else if(yPos > thePlayer.yPos - 30 && yPos < thePlayer.yPos + 30
      && xPos < thePlayer.xPos + 30 && xPos > thePlayer.xPos - 30)
      {
        thePlayer.damage(this);
        return true;
      }
    else return false;
  }
}
class EnemyManager
{
  Enemy[] enemies = new Enemy[15];
  int enemyCount = 0;
  int enemySpawnTimer;
  
  //Constructor
  EnemyManager()
  {
    enemySpawnTimer = 0;
  }
  
  Enemy randomEnemy()
  {
    int index = (int)random(0, enemyCount-1);
    return enemies[index];
  }
  
  //General method that contains the class's functionality
  void manageEnemies()
  {
    if(enemySpawnTimer % 60 == 0)
    {
      spawnEnemy(2);
    }
    updateEnemies();
    displayEnemies();
    enemySpawnTimer++;
  }
  
  //Spawn a new enemy
  //1 = Scout
  //2 = Fighter
  void spawnEnemy(int type)
  {
    if(enemyCount < enemies.length)
    {
      if(type == 1) enemies[enemyCount] = new Scout(random(10, width-10), -10);
      else if(type == 2) enemies[enemyCount] = new Fighter(random(10, width-10), -10);
      enemyCount++;
    }
  }
  
  //Update all of te enemies, check whether they were destroyed
  void updateEnemies()
  {
    for(int i = (enemyCount - 1); i >= 0; i--)
    {
      if(enemies[i] != null)
      {
        enemies[i].update();
        if(enemies[i].checkDestroyed()) removeEnemy(i);
      }
    }
  }
  
  //Display all of the enemies
  void displayEnemies()
  {
    for(int i = 0; i < enemyCount; i++)
    {
      if(enemies[i] != null)
      {
        enemies[i].display();
      }
    }
  }
   
  void removeEnemy(int index)
  {
    for(int i = index; i < (enemies.length - 1); i++)
    {
      enemies[i] = enemies[i+1];
    }
    enemies[(enemies.length - 1)] = null;
    enemyCount--;
  }
  
}
class Fighter extends Enemy
{
  Fighter(float x, float y)
  {
    super(x, y);
    xSpeed = 0;
    ySpeed = 1;
    health = 20;
  }
}
class HUD
{
  float healthPercent;
  //Display the HUD
  void display()
  {
    //Background
    fill(125);
    rect(0, height - 75, width, 75);
    
    //Health
    fill(255, 0, 0);
    healthPercent = map(thePlayer.health, 0, 100, 0, (width / 2) - 10);
    if(healthPercent > 0)
    rect((width / 2) + 5, height - 65, healthPercent, 25);
    
    //Filler, will display shields or lives later
    fill(0, 255, 0);
    rect((width / 2) + 5, height - 35, (width / 2) - 10, 25);
  }
}
class Homing extends Projectile
{ 
  Homing(Ship s, float x, float y, Enemy t)
  {
    super(s, x, y);
    damage = 100;
    xSpeed = ((t.xPos - s.xPos) / 10);
    ySpeed = (((s.yPos - t.yPos) / 10) + t.ySpeed);
  }
}
class Missile extends Projectile
{
  Missile(Ship s, float x, float y)
  {
    super(s, x, y);
    damage = 20;
    ySpeed = 1;
    acceleration = 0.1;
  }
}
class Player extends Ship
{  
  //Weapons Array
  //[SLOT][ENTRY]
  int[][] weapons;
  float[][] loadPctg;
  int missilesToFire;
  int spreadToFire;
  int homingToFire;
  int missileDelay;
  int spreadDelay;
  int homingDelay;
  
  //Constructor
  Player(float x, float y)
  {
    xPos = x;
    yPos = y;
    health = 100;
    weapons = new int[3][5];
    loadPctg = new float[3][5];
    missileDelay = 5;
    spreadDelay = 3;
  }
  
  //Update that runs every frame
  void update()
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
        homingDelay = 2;
      }
    }
  }
  
  //Takes weapon slot, type as an argument
  //0 - Missile
  //1 - Spread
  //2 - Homing
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
  
  void fire(int slot)
  {
    for(int i = 0; i < weapons[slot].length; i++)
    {
      if(weapons[slot][i] == 1)
      {
        missilesToFire++;
        weapons[slot][i] = 0;
      }
      else if(weapons[slot][i] == 2)
      {
        spreadToFire+=4;
        weapons[slot][i] = 0;
      }
      else if(weapons[slot][i] == 3)
      {
        homingToFire++;
        weapons[slot][i] = 0;
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
  
  //Draws the player to the screen
  void display()
  {
    fill(255);
    ellipse(xPos, yPos, 50, 50);
  }
}
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
    if(s != owner)
    {
      if(dist(xPos, yPos, s.xPos, s.yPos) < 15)
      {
        return true;
      } 
    }
    return false;
  }
  
  boolean checkDestroyed()
  {
    if(yPos < -2) return true;
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
    fill(0, 255, 0);
    ellipse(xPos, yPos, 5, 5);
  }
}
class ProjectileManager
{
  Projectile[] theProjectiles;
  int addLocation;
  
  ProjectileManager()
  {
    theProjectiles = new Projectile[75];
    addLocation = 0;
  }
  
  void manageProjectiles()
  {
    updateProjectiles();
    displayProjectiles();
  }
  
  void addProjectile(Projectile p)
  {
    theProjectiles[addLocation] = p;
    p.arrayIndex = addLocation;
    addLocation++;
  }
  
  void removeProjectile(Projectile p)
  {
    for(int i = p.arrayIndex; i < addLocation; i++)
    {
      theProjectiles[i] = theProjectiles[i+1];
      if(theProjectiles[i] != null)
      theProjectiles[i].arrayIndex--;
    }
    addLocation--;
  }
  
  void updateProjectiles()
  {
    for(int i = 0; i < addLocation; i++)
    {
      theProjectiles[i].update();
    }
  }
  
  void displayProjectiles()
  {
    for(int i = 0; i < addLocation; i++)
    {
      theProjectiles[i].display();
    }
  }
}
class Scout extends Enemy
{
  Scout(float x, float y)
  {
    super(x, y);
    xSpeed = 2;
    ySpeed = 1;
    health = 10;
    perlinIndex = random(0, 50000);
  }
  
  void update()
  {
    float p = noise(perlinIndex);
    float deltaX = map(p, 0, 1, (-1 * xSpeed), xSpeed);
    xPos += deltaX;
    xPos = constrain(xPos, 0, width-10);
    yPos += ySpeed;
    perlinIndex += 0.01;
  }
}
class Ship
{
  float xPos;
  float yPos;
  float health;
}
class Spread extends Projectile
{
  Spread(Ship s, float x, float y)
  {
    super(s, x, y);
    damage = 5;
    ySpeed = 4;
    xSpeed = random(-3, 3);
  }
}

