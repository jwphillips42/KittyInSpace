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
