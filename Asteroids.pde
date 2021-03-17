int screen;
int arraySize;
float[] astX, astY, sx, sy;
float playerWidth, playerHeight, playerX, playerY, speedX, speedY, astSize;
int buttonWidth, buttonHeight, playButtonX, playButtonY, shopButtonX, shopButtonY;
int blackHoleHeight, blackHoleWidth, blackHoleX, blackHoleY, blackHoleCountdown, blackHoleShownTimer, blackHoleFlag;
int coins, coinDisplayX, coinDisplayY, coinDisplayWidth, coinDisplayHeight;
int coinRushTimer, coinRushFlag;
int backdropArraySize = 300;
int[] backdropX, backdropY, backdropSpeedX, backdropSpeedY;
int backButtonWidth, backButtonHeight, backButtonX, backButtonY; 
int mainMenuBackButtonFlag, gameReturnBackButtonFlag;
int boostShopX, boostShopY;
int score; 
int boostUpgradeFlag;
float guessX, guessY;
boolean isGood;

ArrayList<Float> laserX = new ArrayList<Float>();
ArrayList<Float> laserY = new ArrayList<Float>();
ArrayList<Float> laserSX = new ArrayList<Float>();
ArrayList<Float> laserSY = new ArrayList<Float>();


void setup() {
  //screen & buttons varaibles
  screen = 0;
  /*
  0 - main menu 
   1 - in game
   2 - portal univerise
   3 - shop
   */

  arraySize = 10;

  //player variables
  playerWidth = 10;
  playerHeight = 10;
  playerX = 200;
  playerY = 300;
  speedX = 0;
  speedY = 0;

  //astrioid variables
  astSize = 15;


  buttonWidth = 200; 
  buttonHeight = 60;
  playButtonX = 320;
  playButtonY = 240;
  shopButtonX = 320;
  shopButtonY = 320;


  blackHoleHeight = 30;
  blackHoleWidth = 30;
  blackHoleX = floor(random(0, 700));
  blackHoleY = floor(random(150, 400));
  blackHoleCountdown = 500;
  blackHoleShownTimer = 500;
  blackHoleFlag = 0;

  coins = 0;
  coinDisplayX = 5;
  coinDisplayY = 5;
  coinDisplayWidth = 150;
  coinDisplayHeight = 50;
  coinRushTimer = 500;
  coinRushFlag = 1;

  backButtonWidth = 150;
  backButtonHeight = 50;
  backButtonX = 5;
  backButtonY = 5;

  mainMenuBackButtonFlag = 0;
  gameReturnBackButtonFlag = 0;

  boostShopX = 150;
  boostShopY = 350;



  boostUpgradeFlag = 0;

  size(860, 500);

  //astroids
  astX = new float[arraySize];
  astY = new float[arraySize];
  sx = new float[arraySize];
  sy = new float[arraySize];
  for (int i=0; i < astX.length; i = i+1) {
    astX[i] = 640 + random(width);
    astY[i] = random(height);

    sx[i] = random(2) - 1;
    sy[i] = random(2) - 1;
  }

  //lasers
  laserX.add(100.0);
  laserY.add(100.0);
  laserSX.add(5.0);
  laserSY.add(3.0);

  //backdrop
  backdropX = new int[backdropArraySize];
  backdropY = new int[backdropArraySize];
  backdropSpeedX = new int[backdropArraySize];
  backdropSpeedY = new int[backdropArraySize];
  for (int i=0; i < backdropX.length; i = i+1) {
    backdropX[i] = 640 + floor(random(100));
    backdropY[i] = floor(random(height));

    backdropSpeedX[i] = 1 + floor(random(4));
    backdropSpeedY[i] = 1 + floor(random(4));
  }



  //perfect spawn
  for (int i=0; i < arraySize; i=i+1) {
    guessX = random(width);
    guessY = random(height);

    isGood = false;

    while (isGood == false) {
      guessX = random(width);
      guessY = random(height);
      isGood = true;
      for (int j=0; j < i; j=j+1) {
        if (dist(astX[j], astY[j], guessX, guessY) < astSize *2) {
          isGood = false;
        }
      }
    }

    astX[i] = guessX;
    astY[i] = guessY;
  }
}

void draw() {


  if (screen == 0) {
    background(100);

    fill(#ffffff);
    rect(playButtonX, playButtonY, buttonWidth, buttonHeight); 

    fill(#000000);
    textSize(30);
    text("Play", playButtonX + 70, playButtonY + 40);

    fill(#ffffff);
    rect(shopButtonX, shopButtonY, buttonWidth, buttonHeight);

    fill(#000000);
    textSize(30);
    text("Shop", shopButtonX + 70, shopButtonY + 40);
  }

  if (screen == 1) {
    background(0);

    //player
    fill(#ffffff);
    if (playerX < 0) playerX = width;
    else if (playerX > width) playerX = 0;
    if (playerY < 0) playerY = height;
    else if (playerY > height)playerY = 0;
    ellipse(playerX, playerY, playerWidth, playerHeight);
    playerX = playerX + speedX;
    playerY = playerY + speedY;
    //boost upgrad purchased, therefore increase apply the upgrade
    if (boostUpgradeFlag == 1) {
      playerX = playerX + (speedX * 1.5);
      playerY = playerY + (speedY * 1.5);
    }




    //astorids
    fill(#999D77);
    for (int i=0; i < arraySize; i = i + 1) {
      ellipse(astX[i], astY[i], astSize, astSize);

      astX[i] = astX[i] + sx[i];
      astY[i] = astY[i] + sy[i];

      if (astX[i] < 0) astX[i] = width;
      else if (astX[i] > width) astX[i] = 0;

      if (astY[i] < 0) astY[i] = height;
      else if (astY[i] > height) astY[i] = 0;


      //player vs astroid collision
      if (dist(playerX, playerY, astX[i], astY[i]) < astSize/2 + 5) {
        print("boom?");
      }
    }

    //lasers
    for (int i=0; i < laserX.size(); i=i+1) {
      fill(#E52A2A);
      ellipse(laserX.get(i), laserY.get(i), 7, 7);

      laserX.set(i, laserX.get(i) + laserSX.get(i));
      laserY.set(i, laserY.get(i) + laserSY.get(i));
    }


    //Garbage Collection
    for (int i=0; i < laserX.size(); i=i+1) {
      if (laserX.get(i) < 0 || laserX.get(i) > width || laserY.get(i) < 0 || laserY.get(i) > height) {
        laserX.remove(i);
        laserY.remove(i);
        laserSX.remove(i);
        laserSY.remove(i);
      }
    }


    //laser vs asteriod collision, asteriods are index i, lasers are index j
    for (int i=0; i < 10; i = i + 1) {//For all asteroids
      for (int j = 0; j < laserX.size(); j=j+1) {//Look at all lasers
        if (dist(astX[i], astY[i], laserX.get(j), laserY.get(j)) < 15) {//laser hit the asteroid
          astX[i] = -100;
          laserX.set(j, -100.0);
        }
      }
    }


    //scoreboard
    fill(#6F23D6);
    rect(5, 5, 110, 40);
    fill(#ffffff);
    textSize(25);
    text("Score: " + score, 13, 35);

    //blackhole
    if (blackHoleFlag == 0) {
      blackHoleCountdown = blackHoleCountdown - 1;
      if (blackHoleCountdown < 0) {
        rect(blackHoleX, blackHoleY, blackHoleWidth, blackHoleHeight);
        blackHoleShownTimer = blackHoleShownTimer - 1;
        if (blackHoleShownTimer == 0) blackHoleCountdown = 500;
        if (playerX > blackHoleX && playerX < blackHoleX + blackHoleWidth && playerY > blackHoleY && playerY <blackHoleY + buttonHeight) {
          screen = 2;
          coinRushFlag = 1;
          blackHoleFlag = 1;
        }
      }
    }

    //background stars
    fill(#6806BF);
    for (int i=0; i < backdropArraySize; i = i + 1) {
      backdropX[i] = backdropX[i] - backdropSpeedX[i];
      backdropY[i] = backdropY[i] - backdropSpeedY[i];
      if (backdropX[i] < 0) backdropX[i] = 640 + floor(random(width));
      if (backdropY[i] < 0) backdropY[i] = 480 + floor(random(width));

      rect(backdropX[i], backdropY[i], backdropSpeedX[i], backdropSpeedY[i]);
    }
  }

  if (screen == 2) {

    background(#C677E8);


    if (coinRushTimer > 0 && coinRushFlag == 1 && blackHoleFlag == 1) {
      coinRushTimer = coinRushTimer - 1;
      print(coinRushTimer + "   ");

      //player
      fill(#ffffff);
      if (playerX < 0) playerX = width;
      else if (playerX > width) playerX = 0;
      if (playerY < 0) playerY = height;
      else if (playerY > height)playerY = 0;
      ellipse(playerX, playerY, playerWidth, playerHeight);
      playerX = playerX + speedX;
      playerY = playerY + speedY;

      //coins 
      fill(#7111D3);
      for (int i=0; i < arraySize; i = i + 1) {
        astX[i] = astX[i] - sx[i];
        astY[i] = astY[i] - sy[i];
        if (astX[i] < 0) astX[i] = 640 + floor(random(width));
        if (astY[i] < 0) astY[i] = 480 + floor(random(width));
        ellipse(astX[i], astY[i], astSize, astSize);

        //player vs coin collision
        if (dist(playerX, playerY, astX[i], astY[i]) < astSize/2 + 5) {
          coins = coins + 1;
        }
      }

      //coin display
      fill(#ffffff);
      rect(coinDisplayX, coinDisplayY, coinDisplayWidth, coinDisplayHeight);
      fill(#000000);
      textSize(20);
      text("Coins: " + coins, coinDisplayX + 30, coinDisplayY + 30);

      if (coinRushTimer == 0) {
        coinRushTimer = 500;
        coinRushFlag = 0;
        screen = 1;
      }
    }
  }

  if (screen == 3) {
    background(120);

    fill(#000000);
    textSize(25);
    text("Welcome to the shop", 300, 50);

    fill(#ffffff);
    rect(backButtonX, backButtonY, backButtonWidth, backButtonHeight);
    fill(#000000);
    textSize(15);
    text("<-- Back Button", backButtonX + 5, backButtonY + 30);

    fill(#ffffff);
    rect(boostShopX, boostShopY, buttonWidth, buttonHeight);
    textSize(25);
    fill(#000000);
    text("Boost Upgrade", boostShopX + 10, boostShopY + 40);
  }
}




void keyPressed() {
  if (screen == 1 || screen == 2) {
    if (keyCode == UP) {
      speedY = -2;
    } else if (keyCode == DOWN) {
      speedY = 2;
    } else if (keyCode == RIGHT) {
      speedX = 2;
    } else if (keyCode == LEFT) {
      speedX = - 2;
    }
  }

  if (screen == 1) {
    if (key == '1') {
      screen = 3;
      gameReturnBackButtonFlag = 1;
    }
  }
}

void mousePressed() {

  if (mouseX > playButtonX && mouseX < playButtonX+ buttonWidth && mouseY > playButtonY && mouseY < playButtonY + buttonHeight && screen == 0) { //play button 
    screen = 1;
  }

  if (mouseX > shopButtonX && mouseX < shopButtonX+ buttonWidth && mouseY > shopButtonY && mouseY < shopButtonY + buttonHeight && screen == 0) { //shop button
    screen = 3;
    mainMenuBackButtonFlag = 1;
  }

  if (mouseX > backButtonX && mouseX < backButtonY + backButtonWidth && mouseY > backButtonY && mouseY < backButtonY + backButtonHeight) { //backButton button
    if (mainMenuBackButtonFlag == 1) {
      screen = 0;
    }

    if (gameReturnBackButtonFlag == 1) {
      screen = 1;
    }
  }

  if (mouseX > boostShopX && mouseX < boostShopY + buttonWidth && mouseY > boostShopY && mouseY < boostShopY + buttonHeight) { //in store purchase (boost upgrade)
    boostUpgradeFlag = 1;
    screen = 1;
    print("sucess");
  }

  if (laserX.size() < 5) { //To control how many you are allowed to fire at once, game balancing and all that
    float speedx;
    float speedy;

    speedx = 10 * (mouseX - playerX) / dist(mouseX, mouseY, playerX, playerY);
    speedy = 10 * (mouseY - playerY) / dist(mouseX, mouseY, playerX, playerY);

    laserX.add(playerX);
    laserY.add(playerY);

    laserSX.add(speedx);
    laserSY.add(speedy);
  }
}
