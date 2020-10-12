/********* 2D MARIO KART MADNESS *********/
// Creator: Manuel Guerra

// 0: Initial Screen
// 1: Game Screen
// 2: Game-over Screen

// Imported Libraries
import java.util.Random;
import processing.sound.*;

// SoundFiles
SoundFile music;
SoundFile roulette;
SoundFile marioYes;
SoundFile marioNo;
SoundFile welcomeN64;

// Images
PImage img;
PImage marioPic;
PImage bowserPic;
PImage toadPic;
PImage rouletteItem;
PImage roadItem;
PImage greeting;
PImage ending;
PImage controls;
PImage points;
PImage itemStrat;

// Driver Objects
marioDriver mario;
bowserDriver bowser; 
toadDriver toad;

// Global Variables
int x;
int score = 0;
int second = 0; //60 FPS
int milSec = 0; //TIME
int sec = 0; //TIME
int min = 0; //TIME
float marioY = 225;
float bowserY = 225;
float toadY = 300;
int itemBox = 0;
boolean throwFront = false;
boolean bowserItem = false;
boolean bowserItemUsed = false;
boolean toadItem = false;
boolean toadItemUsed = false;
boolean difficulty = false;
int gameScreen = 0;

/********* SETUP BLOCK *********/

void setup() {
  size(1200,500);
  // Display scene
  img = loadImage("clouds.jpg");
  marioPic = loadImage("mario.png");
  bowserPic = loadImage("bowser.png");
  toadPic = loadImage("toad_r.png");
  greeting = loadImage("GameLogo.png");
  ending = loadImage("GamePic.png");
  controls = loadImage("space-arrows.png");
  points = loadImage("Points.png");
  itemStrat = loadImage("ItemStrat.png");
  // Display drivers
  mario = new marioDriver(100, marioY, 0.25, 0);
  bowser = new bowserDriver(1200, bowserY, 0, 0);
  toad = new toadDriver(100, toadY, 0, 0);
  // Initiate music
  music = new SoundFile(this, "battleMode.mp3");
  marioYes = new SoundFile(this, "marioYes.wav");
  marioNo = new SoundFile(this, "marioNo.wav");
  roulette = new SoundFile(this, "itemBox.mp3");
  welcomeN64 = new SoundFile(this, "welcome.wav");
  welcomeN64.play();
}

/********* DRAW BLOCK *********/

void draw() {
  // Display the contents of the current screen
  if (gameScreen == 0) {
    // Welcome screen with instructions on how to play
    background(0);
    image(greeting, 100, -75, 1000, 300);
    image(controls, width/2 - 20, 115, 120, 120);
    textSize(12);
    fill(255);
    text("• Up: Upper lane\n• Down: Lower lane\n• Left: Drag item behind\n• Right: Drag item in front\n• Space: Use item", width/2 - 35, 260);
    image(points, 75, 115, 470, 232);
    image(itemStrat, width/2 + 135, 115, 362, 230);
    stroke(255);
    line(0, height-height/5, width, height-height/5);
    line(width/2, height-height/5, width/2, height);
    textSize(20);
    fill(255);
    text("Select Difficulty", width/2 - 75, height - 110);
    textSize(12);
    fill(255);
    text("• Item Path Laser AND Danger Signal Enabled\n • Items push you back a fair amount\n", (width/8)-10, height - 125);
    textSize(12);
    fill(255);
    text("• Item Path Laser AND Danger Signal Disabled\n • Items push you back a tremendous amount\n", (width*5/8)+50, height - 125);
    
    // Mouse hover over normal difficulty & click
    if(mouseX < width/2 && mouseY > height - height/5){
      fill(0,255,0);
      rect(0, height-height/5, width/2, height/5);
      if(mousePressed == true){
        gameScreen = 1;
        difficulty = false;
        music.loop();
      }
    }
    textSize(40);
    fill(255);
    text("Normal Difficulty", 125, height-40);
    
    // Mouse hover over brutal difficulty & click
    if(mouseX > width/2 && mouseY > height - height/5){
      fill(255,0,0);
      rect(width/2, height-height/5, width/2, height/5);
      if(mousePressed == true){
        gameScreen = 1;
        difficulty = true;
        music.loop();
      }
    }
    textSize(40);
    fill(255);
    text("Brutal Difficulty", width/2+150, height-40);
  } 
  else if (gameScreen == 1) {
    // Side scrolls background indefinitely
    int x = frameCount*10 % img.width;
    for (int i = -x ; i < width ; i += img.width) {
      copy(img, 0, 0, img.width, height, i, 0, img.width, height);
    }
    
    // Displays Item Frame
    fill(255);
    noStroke();
    rect(width/2 - 50,30,100,100);
    fill(0);
    rect(width/2 - 42.5,37.5,85,85);
    
    // Displays TIME & SCORE
    textSize(26);
    text("TIME: " + min + ":" + sec + ":" + milSec, 20, 40);
    text("SCORE: " + score, 20, 80);
    
    // TIME calculator in MINUTES:SECONDS:MILLISECONDS
    milSec++;
    if(milSec == 60){
      sec++;
      milSec = 0;
    }
    if(sec == 60){
      min++;
      sec = 0;
    }
    // ******************** MARIO ********************
    // Displays the main driver
    mario.forwardMario(false);
    mario.displayMario();
    
    // Gives main driver an item every 7 seconds if they don't have one
    if(second % 420 == 0 && itemBox == 0 && second != 0){
      throwFront = false;
      itemBox = 1 + (int)(Math.random() * 4); //items 1-4
      roulette.play();
    }
    mario.displayItem(itemBox);
    
    // Displays the shell item either forward or behind the driver
    if(itemBox == 1 || itemBox == 2 || itemBox == 3){
      keyPressed();
      mario.displayRoadItem(itemBox, throwFront);
    }
    
    // Outcomes of when the driver uses their item
    if(keyPressed == true) {
      if (key == ' ') {
        if(itemBox == 4){
          mario.forwardMario(true);
          marioYes.play();
        }
        // When driver throws a green shell successfully
        else if(itemBox == 1){
          if(mario.yPosMario() == bowserY && throwFront == true){
            marioYes.play();
            score = score + 25;
          }
        }
        // When driver throws a red shell successfully
        else if(itemBox == 2){
          if(mario.yPosMario() == bowserY && throwFront == true){
            marioYes.play();
            score = score + 50;
          }
        }
        // When driver throws a blue shell successfully
        else if(itemBox == 3){
          if(mario.yPosMario() == bowserY && throwFront == true){
            marioYes.play();
            score = score + 100;
          }
        }
        itemBox = 0;
      }
    }
    
    // ******************** BOWSER ********************
    // Forward AI decides on Y position every 1.5 seconds
    if(second % 90 == 0 && mario.positionMario() >= 170){
      if(Math.random() >= 0.5){
        bowserY = 225;
      } else {
        bowserY = 300;
      }
    }
    // Forward AI gets an item every 6 seconds
    if(second % 360 == 0 && mario.positionMario() >= 170){
      bowserItem = true;
    }
    // Forward AI decides using an item (if it has one) every 1.5 seconds
    if(second % 90 == 0){
      if(Math.random() >= 0.5){
        bowserItemUsed = true;
      } else {
      }
    }
    // If the forward AI hits the player
    if(bowserItem == true && bowserItemUsed == true){
      if(bowserY == mario.yPosMario() && itemBox == 3 && throwFront == true){
        marioYes.play();
        score = score + 50;
        itemBox = 0;
      } else if(bowserY == mario.yPosMario() && itemBox != 3){
        mario.backwardMario(true);
        marioNo.play();
      }
    }
    // Displays the forward AI
    bowser.displayBowser(bowserY);
    bowser.displayRoadItem(bowserY, bowserItem, bowserItemUsed);
    // Displays danger signals if Bowser has an item in your lane
    if(difficulty == false && bowserItem == true && bowserY == mario.yPosMario()){
      textSize(40);
      fill(255,0,0);
      text("!!!", width/2 - 20, 170);
    }
    // Resets Bowser's boolean values
    if(bowserItemUsed == true){
      bowserItem = false;
      bowserItemUsed = false;
    }
    
    // ******************** TOAD ********************
    // Behind AI decides on Y position every 2 seconds
    if(second % 120 == 0 && mario.positionMario() >= 170){
      if(Math.random() >= 0.5){
        toadY = 225;
      } else {
        toadY = 300;
      }
    }
    // Behind AI gets an item every 5 seconds
    if(second % 300 == 0 && mario.positionMario() >= 170){
      toadItem = true;
    }
    // Behind AI decides using an item (if it has one) every 1 second
    if(second % 60 == 0){
      if(Math.random() >= 0.5){
        toadItemUsed = true;
      } else {
      }
    }
    // If the behind AI hits the player
    if(toadItem == true && toadItemUsed == true){
      if(toadY == mario.yPosMario() && (itemBox == 2 || itemBox == 3) && throwFront == false){
        marioYes.play();
        score = score + 25;
        itemBox = 0;
      } else if(toadY == mario.yPosMario() && (itemBox != 2 || itemBox != 3)){
        mario.backwardMario(true);
        marioNo.play();
      }
    }
    // Displays the behind AI
    toad.displayToad(toadY);
    toad.displayRoadItem(toadY, toadItem, toadItemUsed);
    // Displays danger signals if Toad has an item in your lane
    if(difficulty == false && toadItem == true && toadY == mario.yPosMario()){
      textSize(40);
      fill(255,0,0);
      text("!!!", width/2 - 20, 170);
    }
    // Resets Toad's boolean values
    if(toadItemUsed == true){
      toadItem = false;
      toadItemUsed = false;
    }
    
    // Increments seconds as a draw() function is 60 FPS
    second++;
    
    // When main driver reaches the end, the game is over
    if(mario.positionMario() >= 1200){
      gameScreen = 2;
      music.stop();
    }
  } 
  else if (gameScreen == 2) {
    // Victory screen displaying TIME, SCORE, and Difficulty
    // Also let's the user click to exit game
    background(0);
    image(ending, 100, 100, 400, 300);
    textSize(40);
    fill(0,255,0);
    text("CONGRATULATIONS!", width/2 - 40, height/2-100);
    textSize(40);
    fill(255);
    text("TIME: " + min + ":" + sec + ":" + milSec, width/2 - 40, height/2);
    textSize(40);
    fill(255);
    text("SCORE: " + score, width/2 - 40, height/2 + 50);
    textSize(20);
    fill(255);
    if(difficulty == false){
      text("DIFFICULTY: NORMAL", width/2 - 40, height/2 + 85);
    } else if(difficulty == true){
      text("DIFFICULTY: BRUTAL", width/2 - 40, height/2 + 85);
    }
    textSize(12);
    fill(255);
    text("Click anywhere to exit game", width/2 - 40, height/2 + 120);
  }
  if(mousePressed == true && gameScreen == 2){
    exit();
  }
}

/********* DRIVER DEFINED CLASSES *********/

class marioDriver{ //User Defined Class (MARIO)
  float position;
  float yPos;
  float speed;
  int item;
  marioDriver(float tempX, float tempY, float tempSpeed, int tempItem){ //Constructor
    position = tempX;
    yPos = tempY;
    speed = tempSpeed;
    item = tempItem;
  }
  float yPosMario(){ // Gives Mario's y position in Draw()
    return yPos;
  }
  float positionMario(){ // Gives Mario's x position in Draw()
    return position;
  }
  void displayMario() { // Displays Mario on the track
    if(keyPressed == true) {
      if (key == CODED) {
        if (keyCode == UP) {
          yPos = 225;
        } else if (keyCode == DOWN) {
          yPos = 300;
        }
      }
    }
    pushMatrix();
    scale(-1, 1);
    image(marioPic, -position, yPos, width/12, height/5);
    popMatrix();
  }
  void displayItem(int item){ // Displays item on item frame
    switch(item) {
      case 0:
        break;
      case 1:
        rouletteItem = loadImage("greenShell.png");
        image(rouletteItem, width/2-40, 40, width/15, height/6);
        break;
      case 2:
        rouletteItem = loadImage("redShell.png");
        image(rouletteItem, width/2-40, 45, width/15, height/7);
        break;
      case 3:
        rouletteItem = loadImage("blueShell.png");
        image(rouletteItem, width/2-40, 35, width/15, height/6);
        break;
      case 4:
        rouletteItem = loadImage("mushroom.png");
        image(rouletteItem, width/2-40, 40, width/15, height/6);
        break;
    }
  }
  void displayRoadItem(int item, boolean throwF){ // Displays item on road
    int frontBack = 0;
    if(throwF == true){
      frontBack = 60;
    } else if(throwF == false){
      frontBack = -60;
    }
    switch(item) {
      case 1:
        rouletteItem = loadImage("greenShell.png");
        if(throwF == true && difficulty == false){
          fill(0,255,0);
          rect(position, yPos + 60, width, 5);
        }
        image(rouletteItem, position + frontBack - 75, yPos + 30, width/20, height/8);
        break;
      case 2:
        rouletteItem = loadImage("redShell.png");
        if(throwF == true && difficulty == false){
          fill(255,0,0);
          rect(position, yPos + 70, width, 5);
        }
        image(rouletteItem, position + frontBack - 75, yPos + 40, width/20, height/10);
        break;
      case 3:
        rouletteItem = loadImage("blueShell.png");
        if(throwF == true && difficulty == false){
          fill(0,0,255);
          rect(position, yPos + 60, width, 5);
        }
        image(rouletteItem, position + frontBack - 75, yPos + 30, width/20, height/8);
        break;
    }
  }
  void forwardMario(boolean zoom) { // Makes Mario go forward
    if(zoom == true){
      position = position + 25;
    }
    position = position + speed;
    if (position > width + 100) {
      position = 0;
    }
  }
  void backwardMario(boolean gloom) { // Makes Mario go backward
    if(gloom == true){
      position = position - 25;
      if(difficulty == true){
        position = position - 50;
      }
    }
  }
}

class bowserDriver{ //User Defined Class (BOWSER)
  float position;
  float yPos;
  float speed;
  int item;
  bowserDriver(float tempX, float tempY, float tempSpeed, int tempItem){ //Constructor
    position = tempX;
    yPos = tempY;
    speed = tempSpeed;
    item = tempItem;
  }
  void displayBowser(float yPos) { // Displays Bowser on track
    pushMatrix();
    scale(-1, 1);
    image(bowserPic, -position, yPos, width/12, height/5);
    popMatrix();
  }
  void displayRoadItem(float bowserY, boolean itemSummoned, boolean used){ // Displays Bowser's item on track
    if(itemSummoned == true && used == false){
      image(loadImage("blueShell.png"), position - 60 - 75, bowserY + 30, width/20, height/8);
    } else {
    }
  }
}

class toadDriver{ //User Defined Class (TOAD)
  float position;
  float yPos;
  float speed;
  int item;
  toadDriver(float tempX, float tempY, float tempSpeed, int tempItem){ //Constructor
    position = tempX;
    yPos = tempY;
    speed = tempSpeed;
    item = tempItem;
  }
  void displayToad(float yPos) { // Displays Toad on track
    pushMatrix();
    scale(-1, 1);
    image(toadPic, -position, yPos, width/12, height/5);
    popMatrix();
  }
  void displayRoadItem(float toadY, boolean itemSummoned, boolean used){ // Displays Toad's item on track
    if(itemSummoned == true && used == false){
      image(loadImage("redShell.png"), position + 60 - 75, toadY + 40, width/20, height/10);
    } else {
    }
  }
}

void keyPressed(){ // Determines if LEFT key or RIGHT key is pressed
    if(keyCode == LEFT) {
      throwFront = false;
    } else if(keyCode == RIGHT) {
      throwFront = true;
    }
}
