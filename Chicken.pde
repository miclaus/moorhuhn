/* @author iosif miclaus */
class Chicken {

  private int xPos;
  private int yPos;
  private int cWidth;
  private int cHeight;
  private int speed;
  private int speedModulator = 0;
  // defines the area within which the chicken will fly
  private int yModulator;
  // defines the amplitude of the chickens flying behaviour
  private int yAmplitude;
  private int killCount = 0;
  private int escapeCount = 0;
  private String imageName;
  private PImage chickenImage, chickenImageDead;
  private boolean dying = false;

  // some constants
  private final int minSpeed = 2;
  private final int maxSpeed = 4;
  private final int maxWidth = 100;
  private final int maxHeight = 80;
  private final int maxAmplitude = 30;
  private final float e = 2.71828182845904523536028;
  private final float g = 0.3;
  private float fallGravity = g;

  // constructor, only needs one parameter for the image that should be loaded for the chicken
  //  everything else will be randomly generated
  Chicken(String imageName) {
    this.imageName = imageName;
    reborn();
  }

  private boolean hover() {   
    // since isHover is a boolean, we can write instead of a regular if...else...statement the following:
    //  remember! if you set a boolean to a if-condition, if the condition is correct isHover will be true else false;
    return (mouseX > xPos && mouseX < (xPos + cWidth) && mouseY > yPos && mouseY < (yPos + cHeight));
  }

  // generates a new speed, with which the size of the chicken and some other parameters will depend on
  //  e.g.: - the size of the chicken depends on the speed, the faster the chicken the bigger it is 
  //          (well actually it's just an illusion, so bigger = nearer, smaller = further)
  //        - the amplitude of the chickens movement on the y-axis get's bigger the nearer/bigger the chicken is
  private void newSpeed() {
    // loads the image here, because it will be resizes and we still want it to look good
    chickenImage = loadImage(imageName);
    chickenImageDead = loadImage("chickenDead.png");
    // random speed between min and max speed values is generated
    speed = round(random(minSpeed, maxSpeed));
    // calculates the new size of the chicken
    int cResizeWidth = maxWidth*speed/maxSpeed;
    int cResizeHeight = maxHeight*speed/maxSpeed;
    // resizes the chicken
    chickenImage.resize(cResizeWidth, cResizeHeight);
    chickenImageDead.resize(cResizeWidth, cResizeHeight);
    cWidth = chickenImage.width;
    cHeight = chickenImage.height;
    // calculates the amplitude of the chickens movement on the y-axis
    yAmplitude = speed*maxAmplitude/maxSpeed;
  }

  // generates new position coordinates for the chicken
  private void newPosition() {
    // the chicken should always start on the left side minus a random value, which's will make it look more dynamic
    xPos = 0-round(random(cWidth, cWidth*2));
    // this minuend is needed because the function for the y-position may make the chicken to cross the ends of the window
    int crossVerticalsMinuend = cHeight-yAmplitude;
    // function for the y-position
    yPos = floor(yAmplitude*random(height-crossVerticalsMinuend)) + yModulator;
    // the yModulator is the area where the y-position function should be translated to on the vertical axis
    yModulator = floor(random(yAmplitude, 300-crossVerticalsMinuend));
  }

  public void show() {
    // movement on the x-axis is the speed plus the speedModulator, which makes the game harder ever x number of kills
      xPos += speed+speedModulator;
    
    // if the chicken is not currently in the process of dying
    if(!dying) {
      // if the chicken passed the window
      if (xPos > width) {
        // it should start left at the window with the front of the chicken
        xPos = 0-cWidth-round(random(1,10));
        // if the chicken escapes, then increment the escape count by one
        escapeCount++;
      }
  
      // movement on the y-axis
      //  yAmplitude affects obviously the amplitude of the sinus curve
      //  yModulator affect the area where the sinus curve will randomly be
      yPos = round(yAmplitude*cos(radians(xPos))) + yModulator;
      
      // display the chicken
      image(chickenImage, xPos, yPos);
    } else {
      // increase the gravity to have exponential values later on
      fallGravity += 0.1;
      // exponentially increase the y-position
      yPos += pow(e, fallGravity)/2;
      
      // if the chicken disappeared from the bottom of the window
      if(yPos > height) {
        newSpeed();
        newPosition();
        dying = false;
        // reset the fall gravity
        fallGravity = g;
      }
      
      // display the dead chicken
      image(chickenImageDead, xPos, yPos);
    }
  }

  public void click() {
    // if the mouse is over the chicken
    //  (!there is no need to check whether the mouse is pressed, since this method will only be called when the mouse if pressed)
    //    it's also important to check whether the current chicken is not currently in the process of dying, 
    //    else you would get points for shooting a chicken which is already dying
    if (hover() && !dying) { 
      dying = true;
      killCount++;
    }
  }

  // returns the kill count of this chicken (getter for killCount)
  public int getKillCount() {
    return killCount;
  }
  // returns the escape count of this chicken (getter for escapeCount)
  public int getEscapeCount() {
    return escapeCount;
  }
  // sets the speed modulator to a new one (setter for speedModulator)
  public void setSpeedModulator(int speedModulator) {
    this.speedModulator = speedModulator;
  }

  // resets the chicken and some key values
  public void reborn() {
    killCount = 0;
    escapeCount = 0;
    speedModulator = 0;
    newSpeed();
    newPosition();
  }
}

