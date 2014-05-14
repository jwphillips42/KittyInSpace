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
    
    nearSpeed = 0.75;
    farSpeed = 0.5;
  }
  
  void speedUp()
  {
    nearSpeed = 1.25;
    farSpeed = 2.5;
  }
  
  void manageBackground()
  {
    updateBackgrounds();
    drawBackgrounds();
  }
  
  void updateBackgrounds()
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
  
  void drawBackgrounds()
  {
    image(nearBackgroundA, width/2, nearBackgroundAPos);
    image(nearBackgroundB, width/2, nearBackgroundBPos);
    image(farBackgroundA, width/2, farBackgroundAPos);
    image(farBackgroundB, width/2, farBackgroundBPos);
  }
}
