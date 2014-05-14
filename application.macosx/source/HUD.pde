class HUD
{
  float healthPercent;
  float chargePercent;
  float progressPercent;
  //Display the HUD
  void display()
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
