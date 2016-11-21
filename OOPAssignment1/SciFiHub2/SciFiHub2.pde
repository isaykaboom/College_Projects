PImage open;
PFont f, p, b;
ArrayList<Hex> buttons = new ArrayList<Hex>();
Button vitals, mechBody, computer, mapMe;
Radar menu;
CPUClock yourCpu;

/*
Name; David Burton
Student Number; C15802086
Descriptor; This project is inspired by the animated series "Neon Genesis Evangelion" and its movies,
"Neon Genesis Evangelion: Death & Rebirth" and "The End of Evangelion" as well as the series of remakes
dubbed "Rebuild". 
The interface modelled here is my imagining of what a technician in this sci-fi series might see when
overseeing a mission being carried out by one of the series' many robots (mechs).
*/

void setup()
{
  size (1280, 800);
  background(0);
  open = loadImage("TitleScreen.jpg");
  //opening font
  f = createFont("digital-7.ttf", 72, true);
  //memory font
  p = createFont("digital-7.ttf", 10, true);
  //button font
  b = createFont("digital-7.ttf", 10, true);
  //button x y size stateChange
  vitals = new Button(100, 100, 40 , 4, "PILOT\nVITALS");
  mechBody = new Button(vitals.pos.x, vitals.pos.y + seperate, vitals.size, 5, "MACHINE\nINTEGRITY");
  computer = new Button(vitals.pos.x, mechBody.pos.y + seperate , vitals.size, 6, "COMPUTER\nSYSTEMS");
  mapMe = new Button(vitals.pos.x, computer.pos.y + seperate, vitals.size, 7, "MAP");
  menu = new Radar(width - 110, 115, 160);
  yourCpu = new CPUClock(width - 110, 400);
}

//global variables
int gameState = 0;
float seperate = 80;
int x = 0;
int fade = 255;


void draw()
{
  switch (gameState)
  {
     case 0:
     {
       loadIn();
       if(keyPressed)
       {
         gameState = 2;
       }
       break;
     }
     case 1:
     {
       loading();
       break;
     }
     case 2:
     {
       boot();
       break;
     }
     case 3:
     {
       menu();
       break;
     }
     case 4:
     {
       vitals();
       background(255, 0, 0);
       break;
     }
     case 5:
     {
       mechBody();
       background(0, 255, 0);
       break;
     }
     case 6:
     {
       computer();
       background(0, 0, 255);
       break;
     }
     case 7:
     {
       mapMe();
       background(255, 0, 255);
       break;
     }
     default:
     {
       exit();
       break;
     }
    
  }
}

void menu()
{
  background(0);
  //stroke(255);
  vitals.render();
  vitals.update();
  mechBody.render();
  mechBody.update();
  computer.render();
  computer.update();
  mapMe.render();
  mapMe.update();
  menu.render();
  yourCpu.render();
}

void boot()
{
  background(random(255), 0, 0);
  fill(255, 160, 0);
  textFont(f, 120);
  text("W A R N I N G", (width/2) - 280, (height/2) - 100);
  if(keyPressed)
  {
    gameState = 3;
  }
  if(frameCount % 20 == 0)
  {
    x++;
  }
  if(x % 2 == 0)
  {
    if(x % 4 == 0)  {
    text("SYSTEM BOOT INITIALISED", (width/2) - 550, (height/2)+150);
    }
    else
    {
      text("PRESS START", (width/2) - 250, (height/2)+150);
    }
  }
}

void loadIn()
{
  background(0);
       if (fade > 0)
       {
         fade -= 1.0;
       }
       tint(255, fade);
       open.resize(width, height + 10);
       image(open, 0, 0);
       if(fade == 10)
       {
         gameState = 1;
       }
}

void loading()
{
  x++;
  textFont(f, 50);
  if(x < 60)
  {
    text("LOADING. ", (width/2) - 50, (height/2) + 25);
  }
  else if(x >= 60 && x <= 120)
  {
    text("LOADING. . ", (width/2) - 50, (height/2) + 25);
  }
  else
  {
    text("LOADING. . .", (width/2) - 50, (height/2) + 25);
  }
  //after some seconds (amount denoted by no multiplied by 60)
  if(x == (60 * 3))
  {
    gameState = 2;
    //reset counter to zero for use elsewhere
    x = 0;
  }
}

void vitals()
{
  
}

void mechBody()
{
  
}

void computer()
{
  
}

void mapMe()
{

}