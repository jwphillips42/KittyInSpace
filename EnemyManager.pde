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
  
  void windDown()
  {
    updateEnemies();
    displayEnemies();
  }
  
  //Spawn a new enemy
  //1 = Scout
  //2 = Fighter
  //3 = Destroyer
  void spawnEnemy(int type)
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
