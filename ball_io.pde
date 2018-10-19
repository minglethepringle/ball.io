int widthX;
int heightY;
boolean started = false, collided = false;
ArrayList<Box> boxArray = new ArrayList<Box>();

float frames = 0;
int score = 0;
int boxDim = 50;
int campingSec = 0;
int screen = 1;

void setup()
{   
  fullScreen();
  //size(960, 465);
  frameRate(60);
  widthX = width;
  heightY = height;
}

void draw()
{  
  background(0, 0, 0);
  //colors
  color green = color(0, 255, 0);
  color red = color(255, 0, 0);
  color white = color(255, 255, 255);

  //copyright + version
  textSize(15);
  fill(white);
  textAlign(RIGHT, TOP);
  text("© Mingle Li, Zach Marto", width - 20, 20);
  text("v1.0", width - 20, 5);

  switch(screen) {
  case 1: //home

    //circle
    fill(green);
    ellipse(mouseX, mouseY, 30, 30);

    //home text
    fill(red);
    textSize(300);
    textAlign(CENTER, CENTER);
    text("ball.io", width/2, height/2 - 100);
    fill(green);
    text("o", 1075, 350);

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
    ellipse(mouseX, mouseY, 30, 30);

    //score
    fill(red);
    textSize(30);
    textAlign(LEFT, TOP);
    text("Score: " + score, 20, 20);
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

      if (frames % 300 == 0) {
        boxArray.add( new Box((int) random(10, 20), (int) random(0, widthX - boxDim), (int) random(0, heightY - boxDim)) );
      }

      if (frames % 60 == 0) {
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

void gameOver() {
  collided = true;
  boxArray.clear();
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Game Over!", width/2, height/2);
  text("Press R to restart.", width/2, height/2 + 50);
  textSize(20);
  text("Press Q to quit.", width/2, height/2 + 100);
  campingSec = 0;
  started = false;
}

void mouseMoved() {
  campingSec = 0;
}

void keyReleased() {

  if (screen == 1) {
    screen = 2;
    started = true;
  } else {
    if (key == 'q') {
      exit();
    }
    if (started == false && key == 'r') {
      score = 0;
      boxArray.add( new Box((int) random(10, 20), (int) random(0, widthX - boxDim), (int) random(0, heightY - boxDim)) );
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