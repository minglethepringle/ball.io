String VERSION = "v1.8";

//General
int widthX;
int heightY;
boolean started = false, collided = false;

//Colors
color green = color(0, 255, 0);
color red = color(255, 0, 0);
color white = color(200, 200, 200);

//Box
int boxDim = 50;
ArrayList<Box> boxArray = new ArrayList<Box>();
int nextX = 0, nextY = 0;

//Ball
int ballDim = 30;
//int safeRadius = 150;

//Counters
int fR = 60;
float frames = 0;
int score = 0;
int highScore = 0;
boolean highScoreSaved = false;
int campingSec = 0;
int screen = 1;

// JS Binding
JavaScript javascript;
interface JavaScript {
  void postHighScore(int hs);
}
void bindJavascript(JavaScript js) {
  javascript = js;
}

void setup()
{   
  size(1430, 690);
  frameRate(fR);
  widthX = width;
  heightY = height;
  syncHighScore();
}

void draw()
{  
  background(0, 0, 0);

  //copyright + version
  textSize(15);
  fill(white);
  textAlign(RIGHT, TOP);
  text("© Mingle Li, Zach Marto", width - 20, 20);
  text(VERSION, width - 20, 5);

  switch(screen) {
  case 1: //home

    //circle
    fill(green);
    ellipse(mouseX, mouseY, ballDim, ballDim);

    //home text
    fill(red);
    textSize(300);
    textAlign(CENTER, CENTER);
    text("ball.io", width/2, height/2 - 100);

    fill(red);
    textSize(100);
    text("Press any key to start", width/2, height/2 + 100);

    textSize(20);
    text("3 Rules:", width/2, height/2 + 250);
    text("1. Use your mouse to avoid the red boxes.", width/2, height/2 + 275);
    text("2. Don't camp, or else the game will stop.", width/2, height/2 + 300);
    text("3. Don't throw your computer.", width/2, height/2 + 325);

    text("Good luck.", width/2, height/2 + 400);

    break;
  case 2: //playing / game over

    //circle
    fill(green);
    ellipse(mouseX, mouseY, ballDim, ballDim);

    //score
    fill(red);
    textSize(30);
    textAlign(LEFT, TOP);
    text("Score: " + score, 20, 20);
    text("High Score: " + highScore, 20, 60);
    fill(red);

    if (campingSec >= 5) {
      gameOver();
    }

    if (started) {
      for (Box box : boxArray) {

        if (checkCollision(box)) {
          collided = true;
          started = false;
        } else {
          if ( (box.y + boxDim) >= heightY) {
            // hit bottom, needs to bounce up 

            box.directionY = "up";
            box.y -= box.speed;
          } else if (box.y <= 0) {
            // hit rock top, needs to bounce down 
            box.directionY = "down";
            box.y += box.speed;
          } else {

            if (box.directionY == "up") {
              box.y -= box.speed;
            } else if (box.directionY == "down") {
              box.y += box.speed;
            }
          }

          if ( (box.x + boxDim) >= widthX ) {
            // hit right side, needs to bounce left
            box.directionX = "left";
            box.x -= box.speed;
          } else if ( box.x <= 0 ) {
            // hit left side, needs to bounce right
            box.directionX = "right";
            box.x += box.speed;
          } else {

            if (box.directionX == "left") {
              box.x -= box.speed;
            } else if (box.directionX == "right") {
              box.x += box.speed;
            }
          }

          //rectangle
          rect(box.x, box.y, boxDim, boxDim);
        }
      }

      if (frames % (fR * 5) >= 180 && frames % (fR * 5) <= 300) {
        drawBoxHint();
      }

      if (frames % (fR * 5) == 0) {
        spawnBox();
      }

      if (frames % fR == 0) {
        score++;
        campingSec++;
      }

      frames++;
    } else if (collided == true) {
      gameOver();
    } else {
      started = true;
    }

    break;
  }
}

void drawBoxHint() {
  fill(white);
  if (nextX == 0 && nextY == 0) {
    generateNextXY();
  }
  rect(nextX, nextY, boxDim, boxDim);
}

void generateNextXY() {
  nextX = (int) random(0, widthX - boxDim);
  nextY = (int) random(0, heightY - boxDim);
}

void spawnBox() {
  boolean spawnOk = false;
  do {
    if (nextX == 0 && nextY == 0) {
      generateNextXY();
    }
    int x = nextX;
    int y = nextY;
    double factor = 2 * fR / 60.0;
    boxArray.add( new Box((int) random((int) (8 - factor), (int) (16 - factor)), x, y) );
    spawnOk = true;

    nextX = 0;
    nextY = 0;
  } while (spawnOk == false);
}

void gameOver() {
  collided = true;
  boxArray.clear();
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Game Over!", width/2, height/2);
  text("Press Space to restart.", width/2, height/2 + 50);
  campingSec = 0;
  frames = 0;
  started = false;

  if (score > highScore) {
    text("New high score!", width/2, height/2 + 120);

    if (!highScoreSaved) {
      if (javascript != null) {
        javascript.postHighScore(score);
      }
      highScoreSaved = true;
    }
  }
}

void mouseMoved() {
  campingSec = 0;
}

void keyReleased() {

  if (screen == 1) {
    screen = 2;
    started = true;
  } else {
    if (started == false && keyCode == 32) {
      score = 0;

      syncHighScore();
      highScoreSaved = false;

      started = true;
    }
  }
}

boolean checkCollision(Box box) {
  int boxX = box.x;
  int boxY = box.y;
  boolean collided = false;

  //check if mouseX and mouseY are inside the box
  if (mouseX + 15 > boxX && mouseX - 15 < boxX + boxDim && mouseY + 15 > boxY && mouseY - 15 < boxY + boxDim) {
    collided = true;
  }
  return collided;
}

void syncHighScore() {
  highScore = int(loadStrings("highScore.txt")[0]);
}

class Box {
  String directionX = "right";
  String directionY = "down";
  int speed, x, y;

  Box(int speed, int x, int y) {
    this.x = x;
    this.speed = speed;
    this.y = y;
  }

  void drawBox() {
    rect(x, y, boxDim, boxDim);
  }

  String getDirectionX() {
    return this.directionX;
  }

  void setDirectionX(String direction) {
    this.directionX = direction;
  }

  String getDirectionY() {
    return this.directionY;
  }

  void setDirectionY(String direction) {
    this.directionY = direction;
  }

  int getSpeed() {
    return speed;
  }
}