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

void setup()
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

void reset()
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

void draw()
{
  if(state == 0) preGame();
  else if(state == 1) gameplay();
  else if(state == 2) gameOver();
  else if(state == 3) escape();
  else if(state == 4) winScreen();
}

void preGame()
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

void gameplay()
{
  background(0);
  theBackgroundManager.manageBackground();
  managePlayer();
  theEnemyManager.manageEnemies();
  theProjectileManager.manageProjectiles();
  theHUD.display();
  if(warpCharged) state = 3;
}

void gameOver()
{
  background(0);
  fill(255);
  textSize(20);
  text("GAME OVER", width/2, height/2);
  text("SCORE : " + score, width/2, (height/2) + 20);
  text("SCAN IN TO PLAY AGAIN", width/2, (height/2) + 50);
}

void escape()
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

void winScreen()
{
  theBackgroundManager.manageBackground();
  fill(0);
  text("YOU WIN", width/2, height/2);
  text("SCORE : " + score, width/2, (height/2) + 20);
  text("SCAN IN TO PLAY AGAIN", width/2, (height/2) + 50);
}

void managePlayer()
{
  thePlayer.update();
  thePlayer.display();
}

void keyPressed()
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

void keyReleased()
{
  if(state == 1 || state == 3)
  {
    if(key == 'a') thePlayer.attemptFire(0);
    else if(key == 's') thePlayer.attemptFire(1);
    else if(key == 'd') thePlayer.attemptFire(2);
  }
}
