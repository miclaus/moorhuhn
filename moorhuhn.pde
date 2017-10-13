/* @author iosif miclaus */

// images for background, foreground, live and bullet
PImage bgImage, fgImage, lifeImage, bulletImage;

// define how many chickens there will be and create a collection(array)
final int chickenCount = 3;
Chicken[] chickenCollection = new Chicken[chickenCount];

// how many lives the player has in total
final int lives = chickenCount+1;
// how many lives the player has lost
int lostLives = 0;
// icon size of the lives and bulles images
final int iconSize = 30;
// how many chickes have been killed in total
int totalKillCount = 0;

// how many bullets the player has in total
final int maxBullets = 6;
// how many buttles the player has left
int bullets = maxBullets;

boolean gameOver = false;

// the speed of the chicken will be multiplied with this modulator, after a certain number of kills
int speedModulator = 1;
// after how many kills should the speedModulator be increased
final int speedSteps = 20;

//initalise game
void setup() {
  frameRate(45);
  size(800, 500);
  // set the cursor to look like a cross (+)
  cursor(CROSS);

  // load and resize needed images accordingly
  bgImage = loadImage("background.jpg");
  fgImage = loadImage("foreground.png");
  lifeImage = loadImage("life.png");
  lifeImage.resize(iconSize, iconSize);
  bulletImage = loadImage("bullet.png");
  bulletImage.resize(iconSize, iconSize);

  // create the chickens
  for (int position = 0; position < chickenCount; position++) {
    String imageName;
    // set some images for different chicken (numbers)
    if ((position%2) == 0) {
      imageName = "chicken1.png";
    } else {
      imageName = "chicken2.png";
    }
    // create the chicken with the corresponding image
    chickenCollection[position] = new Chicken(imageName);
  }

  //font settings
  PFont myFont = createFont("Monaco", 28);
  textFont(myFont);
  textAlign(LEFT, TOP);
}

void draw() {
  // display the background image
  image(bgImage, 0, 0, width, height);

  // if it's not game over let the game run
  if (!gameOver) {
    // this is neccessary because the draw method runs constantly
    //  try uncommenting these variables to see what happens and you will understand
    lostLives = 0;
    totalKillCount = 0;

    // loop through all chickens
    for (int position = 0; position < chickenCount; position++) {
      // set the speed of the chicken
      chickenCollection[position].setSpeedModulator(speedModulator);
      // show the chicken
      chickenCollection[position].show();
      // add the escape count of the chicken to the lost lives of the player
      lostLives += chickenCollection[position].getEscapeCount();
      // add the kill count of the chicken to the total kill count of all chickens
      totalKillCount += chickenCollection[position].getKillCount();
    }
  
    // check if the player has reached the next speed level
    if (totalKillCount/speedSteps == speedModulator) {
      speedModulator++;
    }
  }

  // display the foreground image (tree)
  image(fgImage, 0-(fgImage.width/3), 40, fgImage.width, fgImage.height);

  // shows the total kill count
  showKillCount();
  // shows the remaining lives or game over
  showLives();
  // shows the remaining bullets or reload message
  showBullets();
}

void mousePressed() {
  // if the player still has bullets and (s)he clicks the left mouse button
  if (bullets > 0 && mouseButton == LEFT) {
    // decrement bullets by one shot
    bullets--;
    // send the click event to ALL chickens
    //  (every chicken will check for itself whether it was shot or not)
    for (int position = 0; position < chickenCount; position++) {
      chickenCollection[position].click();
    }
  } else if(mouseButton == RIGHT) {
    // click the right mouse button to reload
    reload();
  }
}

void keyPressed() {
  switch(keyCode) {
    case 78:
      // press "n"(78) for new game
      newGame();
      break;
    case 82:
      // press "r"(82) to reload 
      reload();
      break;
  }
}

// shows the total kill count
void showKillCount() {
  textSize(28);
  text("kills: " + totalKillCount, width/1.5, 5);
}

// shows the remaining lives or game over
void showLives() {
  // how many lives does the player still have
  int remainingLives = lives-lostLives;
  // if the player has no lives left -> game over
  if (remainingLives <= 0) {
    gameOver = true;
  }

  // if it's not game over (yet)
  if (!gameOver) {
    // display the lives the player still has
    for (int life = 1; life <= remainingLives; life++) {
      image(lifeImage, width-((iconSize+(iconSize/2))*life), height-(iconSize+(iconSize/4)), iconSize, iconSize);
    }
  } else {
    // if it's game over then display the game over text
    textSize(48);
    text("game over! [n]ew game?", 75, height/4);
  }
}

// shows the remaining bullets or reload message
void showBullets() {
  // only show bullets if it's not game over (yet)
  if (!gameOver) {
    // if the player still has bullets left
    if (bullets > 0) {
      // display the bullets the player still has
      for (int bullet = 1; bullet <= bullets; bullet++) {
        image(bulletImage, ((iconSize+(iconSize/4))*bullet), height-(iconSize+(iconSize/4)), iconSize, iconSize);
      }
    } else {
      // if the player doesn't have any bullets left, then display the reload message
      textSize(16);
      text("[right click] or press [r] to reload", iconSize+(iconSize/4), height-32);
    }
  }
}

// creates a new game
void newGame() {
  for (int position = 0; position < chickenCount; position++) {
    // reborn/reset all chickens and needed values
    chickenCollection[position].reborn();
    // set the game to the normal speed
    speedModulator = 1;
  }
  gameOver = false;
  // reset the bullets
  bullets = maxBullets;
}

// reset the bullets
void reload() {
  bullets = maxBullets;
}

