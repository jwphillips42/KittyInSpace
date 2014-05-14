import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class KittyInSpace extends PApplet {

Player thePlayer;
EnemyManager theEnemyManager;
ProjectileManager theProjectileManager;
BackgroundManager theBackgroundManager;
HUD theHUD;

//0 = Pregame
//1 = Gameplay
//2 = Game Over
//3 = Escape Animation
//4 = Win Screen
int state;

float scanProgress;
int welcomeScreenDelay;
int flashOn;

int score;
long startTime;
long elapsedTime;
long targetTime;
boolean warpCharged;

PImage playerPic;
PImage scoutPic;
PImage fighterPic;
PImage destroyerPic;

PImage spreadPic;
PImage homingPic;
PImage missilePic;
PImage destroyerAttackPic;
PImage fighterAttackPic;

PImage welcomeScreen;
PImage farBackgroundA;
PImage farBackgroundB;
PImage closeBackgroundA;
PImage closeBackgroundB;

public void setup()
{
  size(500, 800);
  noStroke();
  imageMode(CENTER);
  textAlign(CENTER);
  
  targetTime = 60;
  scanProgress = 0;
  welcomeScreenDelay = 30;
  flashOn = -1;
  
  playerPic = loadImage("player.png");
  scoutPic = loadImage("scout.png");
  fighterPic = loadImage("fighter.png");
  destroyerPic = loadImage("destroyer.png");
  
  spreadPic = loadImage("spread.png");
  homingPic = loadImage("homing.png");
  missilePic = loadImage("missile.png");
  destroyerAttackPic = loadImage("enemySpread.png");
  fighterAttackPic = loadImage("fighterAttack.png");
  
  welcomeScreen = loadImage("welcomeScreen.png");
  farBackgroundA = loadImage("background3.png");
  farBackgroundB = loadImage("background4.png");
  closeBackgroundA = loadImage("background1.png");
  closeBackgroundB = loadImage("background2.png");
  
  state = 0;
}

public void reset()
{
  score = 0;
  println(score);
  startTime = millis();
  warpCharged = false;
  
  thePlayer = new Player(width / 2, height - 125);
  theEnemyManager = new EnemyManager();
  theProjectileManager = new ProjectileManager();
  theBackgroundManager = new BackgroundManager(closeBackgroundA, closeBackgroundB, farBackgroundA, farBackgroundB);
  theHUD = new HUD();
  
  state = 1;
}

public void draw()
{
  if(state == 0) preGame();
  else if(state == 1) gameplay();
  else if(state == 2) gameOver();
  else if(state == 3) escape();
  else if(state == 4) winScreen();
}

public void preGame()
{
  rectMode(CENTER);
  image(welcomeScreen, width/2, height/2);
  welcomeScreenDelay--;
  fill(163, 215, 113);
  if(welcomeScreenDelay == 0)
  {
    flashOn *= -1;
    welcomeScreenDelay = 30;
  }
  if(flashOn == 1)
  {
    rect(144, 614, 90, 149);
    rect(299, 589, 58, 28);
  }
  if(keyPressed && key == '5')
  {
    scanProgress++;
  }
  else
  {
    scanProgress--;
    if(scanProgress < 0) scanProgress = 0;
  }
  rectMode(CORNER);
  float scanPercentage = map(scanProgress, 0, 150, 0, 290);
  rect(105, 359, scanPercentage, 50);
  if(scanProgress > 150) reset();
}

public void gameplay()
{
  background(0);
  theBackgroundManager.manageBackground();
  managePlayer();
  theEnemyManager.manageEnemies();
  theProjectileManager.manageProjectiles();
  theHUD.display();
  if(warpCharged) state = 3;
}

public void gameOver()
{
  background(0);
  fill(255);
  textSize(20);
  text("GAME OVER", width/2, height/2);
  text("SCORE : " + score, width/2, (height/2) + 20);
  text("SCAN IN TO PLAY AGAIN", width/2, (height/2) + 50);
}

public void escape()
{
  if(theEnemyManager.enemyCount > 0)
  {
    background(0);
    theBackgroundManager.manageBackground();
    managePlayer();
    theEnemyManager.windDown();
    theProjectileManager.manageProjectiles();
  }
  else
  {
    theBackgroundManager.speedUp();
    theBackgroundManager.manageBackground();
    if(thePlayer.escapeAnimation()) state = 4;
  }
  theHUD.display();
}

public void winScreen()
{
  theBackgroundManager.manageBackground();
  fill(0);
  text("YOU WIN", width/2, height/2);
  text("SCORE : " + score, width/2, (height/2) + 20);
  text("SCAN IN TO PLAY AGAIN", width/2, (height/2) + 50);
}

public void managePlayer()
{
  thePlayer.update();
  thePlayer.display();
}

public void keyPressed()
{
  if(state == 1 || state == 3)
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
  }
  else if(state == 2 || state == 4)
  {
    if(key == '5') reset();
  }
}

public void keyReleased()
{
  if(state == 1 || state == 3)
  {
    if(key == 'a') thePlayer.attemptFire(0);
    else if(key == 's') thePlayer.attemptFire(1);
    else if(key == 'd') thePlayer.attemptFire(2);
  }
}
class BackgroundManager
{
  PImage nearBackgroundA;
  PImage nearBackgroundB;
  PImage farBackgroundA;
  PImage farBackgroundB;
  
  float nearBackgroundAPos;
  float nearBackgroundBPos;
  float farBackgroundAPos;
  float farBackgroundBPos;
  
  float nearSpeed;
  float farSpeed;
  
  BackgroundManager(PImage a, PImage b, PImage c, PImage d)
  {
    nearBackgroundA = c;
    nearBackgroundB = d;
    farBackgroundA = a;
    farBackgroundB = b;
    nearBackgroundAPos = height/2;
    nearBackgroundBPos = -600;
    farBackgroundAPos = height/2;
    farBackgroundBPos = -600;
    
    nearSpeed = 0.75f;
    farSpeed = 0.5f;
  }
  
  public void speedUp()
  {
    nearSpeed = 1.25f;
    farSpeed = 2.5f;
  }
  
  public void manageBackground()
  {
    updateBackgrounds();
    drawBackgrounds();
  }
  
  public void updateBackgrounds()
  {
    nearBackgroundAPos += nearSpeed;
    nearBackgroundBPos += nearSpeed;
    farBackgroundAPos += farSpeed;
    farBackgroundBPos += farSpeed;
    if(nearBackgroundAPos > height + 500) nearBackgroundAPos = -700;
    if(nearBackgroundBPos > height + 500) nearBackgroundBPos = -700;
    if(farBackgroundAPos > height + 500) farBackgroundAPos = -700;
    if(farBackgroundBPos > height + 500) farBackgroundBPos = -700;
    
  }
  
  public void drawBackgrounds()
  {
    image(nearBackgroundA, width/2, nearBackgroundAPos);
    image(nearBackgroundB, width/2, nearBackgroundBPos);
    image(farBackgroundA, width/2, farBackgroundAPos);
    image(farBackgroundB, width/2, farBackgroundBPos);
  }
}
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
  
  public void update()
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
  
  public void attack()
  {
    theProjectileManager.addProjectile(new DestroyerAttack(this, xPos, yPos));
  }
}
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
  public void update()
  {
    yPos += ySpeed;
  }
  
  public void damage(Projectile p)
  {
    health -= p.damage;
  }
  
  //Check whether an enemy has been destroyed
  public boolean checkDestroyed()
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
  
  public Enemy randomEnemy()
  {
    int index = (int)random(0, enemyCount-1);
    return enemies[index];
  }
  
  //General method that contains the class's functionality
  public void manageEnemies()
  {
    if(enemySpawnTimer == 240)
    {
      int toSpawn = (int)random(1, 10);
      if(toSpawn < 3) 
      {
        spawnEnemy(3);
        enemySpawnTimer = 0;
      }
      else if(toSpawn < 6) 
      {
        spawnEnemy(2);
        spawnEnemy(2);
        enemySpawnTimer = 60;
      }
      else if(toSpawn < 11) 
      {
        spawnEnemy(1);
        spawnEnemy(1);
        spawnEnemy(1);
        spawnEnemy(1);
        enemySpawnTimer = 60;
      }
    }
    updateEnemies();
    displayEnemies();
    enemySpawnTimer++;
  }
  
  public void windDown()
  {
    updateEnemies();
    displayEnemies();
  }
  
  //Spawn a new enemy
  //1 = Scout
  //2 = Fighter
  //3 = Destroyer
  public void spawnEnemy(int type)
  {
    if(enemyCount < enemies.length)
    {
      if(type == 1) enemies[enemyCount] = new Scout(random(10, width-10), -10);
      else if(type == 2) enemies[enemyCount] = new Fighter(random(10, width-10), -10);
      else if(type == 3) enemies[enemyCount] = new Destroyer(random(10, width-10), -10);
      enemyCount++;
    }
  }
  
  //Update all of te enemies, check whether they were destroyed
  public void updateEnemies()
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
  public void displayEnemies()
  {
    for(int i = 0; i < enemyCount; i++)
    {
      if(enemies[i] != null)
      {
        enemies[i].display();
      }
    }
  }
   
  public void removeEnemy(int index)
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
    ySpeed = 2;
    health = 30;
    attackTimer = 40;
    image = fighterPic;
    xSize = image.width;
    ySize = image.height;
    collideDamage = 20;
    scoreBonus += 50;
  }
  
  public void update()
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
  
  public void attack()
  {
    theProjectileManager.addProjectile(new FighterAttack(this, xPos, yPos));
  }
}
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
class HUD
{
  float healthPercent;
  float chargePercent;
  float progressPercent;
  //Display the HUD
  public void display()
  {
    rectMode(CORNER);
    //Background
    fill(125);
    rect(0, height - 75, width, 75);
    
    //Health
    fill(255, 0, 0);
    healthPercent = map(thePlayer.health, 0, 100, 0, (width / 2) - 10);
    if(healthPercent > 0)
    rect((width / 2) + 5, height - 65, healthPercent, 25);
    
    //Warp
    elapsedTime = (millis() - startTime) / 1000;
    if(elapsedTime > targetTime)
    { 
      elapsedTime = targetTime;
      warpCharged = true;
    }
    progressPercent = map(elapsedTime, 0, targetTime, 0, (width / 2) - 10);
    if(warpCharged) fill(0, 255, 0);
    else fill(0, 255, 0, 120);
    rect((width / 2) + 5, height - 35, progressPercent, 25);
    
    //Weapons Bars
    fill(0, 0, 255, 120);
    float chunkSize = ((width / 2) - 10) / 5;
    for(int i = 0; i < thePlayer.weapons[0].length; i++)
    {
      if(thePlayer.weapons[0][i] != 0)
      {
        rect(5 + (i * chunkSize), height - 65, chunkSize, 15);
      }
    }
    for(int i = 0; i < thePlayer.weapons[1].length; i++)
    {
      if(thePlayer.weapons[1][i] != 0)
      {
        rect(5 + (i * chunkSize), height - 45, chunkSize, 15);
      }
    }
    for(int i = 0; i < thePlayer.weapons[2].length; i++)
    {
      if(thePlayer.weapons[2][i] != 0)
      {
        rect(5 + (i * chunkSize), height - 25, chunkSize, 15);
      }
    }
    
    fill(0, 0, 255);
    for(int i = 0; i < thePlayer.chargePctg[0].length; i++)
    {
      if(thePlayer.weapons[0][i] != 0)
      {
        chargePercent = map(thePlayer.chargePctg[0][i], 0, 100, 0, chunkSize);
        rect(5 + (i * chunkSize), height - 65, chargePercent, 15);
      }
    }
    for(int i = 0; i < thePlayer.chargePctg[1].length; i++)
    {
      if(thePlayer.weapons[1][i] != 0)
      {
        chargePercent = map(thePlayer.chargePctg[1][i], 0, 100, 0, chunkSize);
        rect(5 + (i * chunkSize), height - 45, chargePercent, 15);
      }
    }
    for(int i = 0; i < thePlayer.chargePctg[2].length; i++)
    {
      if(thePlayer.weapons[2][i] != 0)
      {
        chargePercent = map(thePlayer.chargePctg[2][i], 0, 100, 0, chunkSize);
        rect(5 + (i * chunkSize), height - 25, chargePercent, 15);
      }
    }
  }
}
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
class Missile extends Projectile
{
  Missile(Ship s, float x, float y)
  {
    super(s, x, y);
    damage = 30;
    ySpeed = 1;
    acceleration = 0.1f;
    image = missilePic;
  }
}
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
  public void update()
  {
    move();
    chargeLoadedWeapons();
    fire();
  }
  
  //Handles the movement of the ship
  public void move()
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
  public void chargeLoadedWeapons()
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
  public void fire()
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
  public void load(int s, int w)
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
  public void attemptFire(int slot)
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
  public void launchVolley(int slot)
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
  public void damage(Enemy e)
  {
    health -= e.collideDamage;
    //If the player loses all health, game over
    if(health <= 0) state = 2;
  }
  
  //Take damage from collision with enemy projectile
  public void damage(Projectile p)
  {
    health -= p.damage;
    if(health <= 0) state = 2;
  }
  
  public boolean escapeAnimation()
  {
    if(xPos < width/2) xPos++;
    else if(xPos > width/2) xPos--;
    else if(xPos == width/2) yPos -= 5;
    image(image, xPos, yPos);
    if(yPos < -30) return true;
    else return false;
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
  PImage image;
  float xSize;
  float ySize;
  
  Projectile(Ship s, float x, float y)
  {
    owner = s;
    xPos = x;
    yPos = y;
    damage = 5.0f;
    xSpeed = 0;
    ySpeed = 5;
    acceleration = 0;
  }
  
  public boolean checkCollide(Ship s)
  {
    if(s.enemy != owner.enemy)
    {
      if(s.image == destroyerPic)
      {
        if(yPos + (ySize/2) > s.yPos - (s.ySize/2) && yPos - (ySize/2) < s.yPos + (s.ySize/2)
            && xPos - (xSize/2) < s.xPos + (s.xSize/2) && xPos + (xSize/2) > s.xPos - (s.xSize/2))
            {
              return true;
            }
      }
      else if(dist(xPos, yPos, s.xPos, s.yPos) < 15)
      {
        return true;
      } 
    }
    return false;
  }
  
  public boolean checkDestroyed()
  {
    if(yPos < -2) return true;
    else if(yPos > (height   + 2)) return true;
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
  
  public void update()
  {
    if(ySpeed < 8) ySpeed += acceleration;
    xPos += xSpeed;
    yPos -= ySpeed;
    if(checkDestroyed()) theProjectileManager.removeProjectile(this);
  }
  
  public void display()
  {
    image(image, xPos, yPos);
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
  
  public void manageProjectiles()
  {
    updateProjectiles();
    displayProjectiles();
  }
  
  public void addProjectile(Projectile p)
  {
    theProjectiles[addLocation] = p;
    p.arrayIndex = addLocation;
    addLocation++;
  }
  
  public void removeProjectile(Projectile p)
  {
    for(int i = p.arrayIndex; i < addLocation; i++)
    {
      theProjectiles[i] = theProjectiles[i+1];
      if(theProjectiles[i] != null)
      theProjectiles[i].arrayIndex--;
    }
    addLocation--;
  }
  
  public void updateProjectiles()
  {
    for(int i = 0; i < addLocation; i++)
    {
      theProjectiles[i].update();
    }
  }
  
  public void displayProjectiles()
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
    ySpeed = 2;
    health = 10;
    perlinIndex = random(0, 50000);
    image = scoutPic;
    xSize = image.width;
    ySize = image.height;
    collideDamage = 10;
    scoreBonus += 25;
  }
  
  public void update()
  {
    float p = noise(perlinIndex);
    float deltaX = map(p, 0, 1, (-1 * xSpeed), xSpeed);
    xPos += deltaX;
    xPos = constrain(xPos, 0, width-10);
    yPos += ySpeed;
    perlinIndex += 0.01f;
  }
}
class Ship
{
  float xPos;
  float yPos;
  float health;
  PImage image;
  float xSize;
  float ySize;
  boolean enemy;
  
  public void display()
  {
    image(image, xPos, yPos);
  }
}
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "KittyInSpace" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
