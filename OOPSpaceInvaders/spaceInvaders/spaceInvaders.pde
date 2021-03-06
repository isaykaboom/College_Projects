/*
Name; David Burton
Student Number; C15802086
Commits; 25
Descriptor; This is my take on Gradius/Japanese side scrolling shoot 'em ups.
*/

import ddf.minim.*;
Minim gameMusic, menuMusic, deathMusic;
AudioPlayer menu, game, death;
ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();
ArrayList<Stars> starArray = new ArrayList<Stars>();
ArrayList<Score> scoreArray = new ArrayList<Score>();
boolean[] keyStrokes = new boolean[500];
Player player0;
PFont gameText;
PImage open, player;
Table scoreList;


void setup()
{
  size(900, 600);
  background(0);
  noCursor();
  open = loadImage("title.png");
  player = loadImage("viper.gif");
  gameMusic = new Minim(this);
  menuMusic = new Minim(this);
  deathMusic = new Minim(this);
  death = deathMusic.loadFile("death.wav", 512);
  menu = menuMusic.loadFile("flameMan.mp3", 512);
  game = gameMusic.loadFile("moon.mp3", 512);
  gameText = createFont("game.ttf", 30, true);
  player0 = new Player(55, height/2, 'w', 's', ' ');
  gameObjects.add(player0);
  PowerSpread test = new PowerSpread(width - 600, random(10, height - 10) );
  gameObjects.add(test);
  
  scoreList = loadTable("hiScore.csv", "header");
  populateArrayList();
  
  for(int i = 0; i < 2; i++)
  {
    Score s = scoreArray.get(0);
    hiScore = s.hiScore;
  }
  
  
  
  for(int i = 0; i < 250; i++)
  {
    //check
    Stars s = new Stars();
    s.theta = random(-0.05, 0.05);
    s.shape.rotate(random(0, 2*PI));
    starArray.add(s);
  }
  
}

int hiScore;
int swap = 1;
int gameState = 0;
int selector = 1;
int score = 0;

void draw()
{
  background(0);
  for(int i = starArray.size()-1; i >= 0; i--)
    {
      //check
      Stars use = starArray.get(i);
      use.shape.rotate(use.theta);
      use.update();
      use.display();
    }
  
  switch(gameState)
  { 
    case 0:
    {
      background(0);
      String print;
      
      if(keyPressed)
      {
        gameState = 1;
      }
      imageMode(CENTER);
      image(open, width/2, height/2);
      textFont(gameText, 20);
      textAlign(CENTER, CENTER);
      text("KIND OF LIKE", width/2, (height/2) - 60);
      if(frameCount % 45 == 0)
      {
        swap *= -1;
      }
      if(swap == 1)
      {
        print = "";
      }
      else
      {
        print = "PRESS ANY BUTTON TO START";
      }
      text(print, width/2, height - 35);
      break;
    }
    
    
    case 1: //setup/game menu?
    {
      death.pause();
      death.rewind();
      menu.play();
      textFont(gameText, 20);
      text("START", (width/2) + 50, height - 100 );
      text("EXIT", (width/2) + 41, height - 60);
      text("HIGH SCORE - " + hiScore, width/2, height/2);
      imageMode(CENTER);
      text("KIND OF LIKE", width/2, 42);
      image(open, width/2, 100);
      selector();
      break;
    }
    
    
    case 2: //game mode 1
    {
      //enemy spawn trigger
      if(frameCount % 60 == 0)
      {
        enemySpawn();
      }
      if(frameCount % 300 == 0)
      {
        for(int i = 0; i < 4; i++)
        {
          enemySpawn();
        }
      }
      
      //this must be in ascending order as a sudden decrease in ArrayList size makes the compiler unhappy!
      //for(int i = gameObjects.size()-1; i >= 0; i--)
      for(int i = 0; i < gameObjects.size(); i++)
      {
        GameObject use = gameObjects.get(i);
        use.update();
        use.render();
      }
      powerUp();
      scoreDisplay();
      game.play();
      break;
    }
    case 3: //game over
    {
      gameEnd();
      break; 
    }
    default:
    {
      break;
    }
  }
}

int cleanUp = 0;
int count = 0;

//method to show end of game
void gameEnd()
{
    
    death.play();
    background(0);
    if(cleanUp == 0)
    {
      
      for(int i = gameObjects.size() - 1; i >= 1; i--)
      {
        GameObject use = gameObjects.get(i);
        gameObjects.remove(use);
      }
      
      if(hiScore <= score)
      {
        hiScore = score;
        for(int i = scoreList.getRowCount() - 1; i >= 0; i--)
        {
          scoreList.removeRow(i);
        }
        
        TableRow newRow = scoreList.addRow();
        newRow.setFloat("hiScore", hiScore);
        //THIS IS IMPORTANT!!!
        //This is a critical line. The game will crash if not run on a mac with the user name David
        //This is because the .csv files with the saveTable command automatically are saved to the
        //sketch folder rather than the sketch data folder
        //the only way to put these files into the DATA folder is to provide the absolute path to them while saving
        //This feature could be removed but I liked saving the score on my end. This feature will be removed in the public
        //version
        saveTable(scoreList, "/Users/David/desktop/github/College_Projects/OOPSpaceInvaders/SpaceInvaders/data/hiScore.csv");
      }
      cleanUp = 1;
    }
    
    String print;
    
    if(frameCount % 45 == 0)
    {
      swap *= -1;
    }
    
    if(swap == 1)
    {
      print = "";
    }
    else
    {       
      print = "GAME\nOVER";
    }
    textFont(gameText, 50);
    textAlign(CENTER, CENTER);
    text(print, width/2, height/2);
    textFont(gameText, 15);
    print = "SCORE = " + score;
    text(print, width/2, (height/2) + 100);
    print = "press any key to go back to menu";
    text(print, width/2, (height/2) + 200);
    count++;
    if(hiScore <= score)
    {
      text("NEW HIGH SCORE", width/2, (height/2) + 150);
    }
    
    if(count > 25)
    {
      //write out score to file
      
      
      if(keyPressed)
      {
        gameState = 1;
        count = 0;
        spawnTimer = 180;
        score = 0;
        cleanUp = 0;
      }
    }
    
    game.pause();
    game.rewind();
    menu.pause();
    menu.rewind();
}

void selector()
{
   imageMode(CENTER);
   player.resize(70, 45);
   
   if(checkKey('w'))
   {
     selector = 1;
   }
   else if(checkKey('s'))
   {
     selector = 0;
   }
   if(selector == 1)
   {
     image(player, 400, height - 108 );
   }
   if(selector == 0)
   {
     image(player, 400, height - 67);
   }
   
   if(selector == 1 && checkKey(' '))
   {
     menu.pause();
     menu.rewind();
     gameState = 2;
   }
   else if(selector == 0 && checkKey(' '))
   {
     exit();
   }
}

void scoreDisplay()
{
  textAlign(CENTER);
  textFont(gameText, 17);
  text("SCORE-" + score, width - 75, 35);
}
void powerUp()
{
  float luck;
  if(frameCount % 30 == 0)
  {
    luck = random(0, 300);
    if(luck > 290)
    {
        PowerFast test = new PowerFast(width - 600, random(10, height - 10) );
        gameObjects.add(test);
    }
  }
  
  luck = random(0, 101);
  if(luck > 100.5)
  {
      PowerSpread test = new PowerSpread(width - 600, random(10, height - 10) );
      gameObjects.add(test);
  }
}

void populateArrayList()
{
  for (int i = scoreArray.size() - 1; i >= 0; i--) 
  {
    scoreArray.remove(i);
  }

  for(TableRow row : scoreList.rows())
   {
     Score s = new Score(row);
     scoreArray.add(s);
   }
}


float spawnTimer = 180;
void enemySpawn()
{
  float x = width + 20; 
  float y = height / 6;
  
  if(frameCount % 400 == 0)
  {
    if(spawnTimer >= 0)
    {
      spawnTimer -= 20;
    }
  }
  
  if(frameCount % spawnTimer == 0)
  {
    for(int i = 0; i < 3; i++)
    {
      for(int j = 0; j < 1; j++)
      {
        Baddie b = new Baddie(x + (400/3 * i), y + (random(height/5, height - 250)));
        gameObjects.add(b);
      }
    }
  }
}

void keyPressed()
{
  keyStrokes[keyCode] = true;
}

void keyReleased()
{
  keyStrokes[keyCode] = false;
}

boolean checkKey(int a)
{
  if(keyStrokes.length >= a)
  {
    return keyStrokes[a] || keyStrokes[Character.toUpperCase(a)];
  }
  return false;
}