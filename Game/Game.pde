/* Game Class Starter File
 * Authors: Carlos Perez | Justin Avila
 * Last Edit: 5/20/2024
 */

//import processing.sound.*;

//------------------ GAME VARIABLES --------------------//

//Title Bar
private int msElapsed = 0;
String titleText = "Crazy Chef";
String extraText = "";

//Current Screens
Screen currentScreen;
World currentWorld;
Grid currentGrid;

//Splash Screen Variables
Screen splashScreen;
String splashBgFile = "images/apcsa.png";
PImage splashBg;

//Level1 Screen Variables
Grid level1Grid;
String mainBgFile = "images/restaurantwallpaper.jpg";
PImage mainBg;

PImage chef;
String chefFile = "images/Chef_Player.png";
int chefRow = 7;
int chefCol = 1;
int health = 3;
PImage customer;
String customerFile = "images/Chef_Player.png";

PImage enemy;
AnimatedSprite enemySprite;

AnimatedSprite exampleSprite;
boolean doAnimation;

//EndScreen variables
World endScreen;
PImage endBg;
String endBgFile = "images/youwin.png";

//Example Variables
//HexGrid hGrid = new HexGrid(3);
//SoundFile song;

//------------------ REQUIRED PROCESSING METHODS --------------------//

//Required Processing method that gets run once
void setup() {

  //Match the screen size to the background image size
  size(800,1000);
  
  //Set the title on the title bar
  surface.setTitle(titleText);

  //Load BG images used
  splashBg = loadImage(splashBgFile);
  splashBg.resize(width, height);
  mainBg = loadImage(mainBgFile);
  mainBg.resize(width, height);
  endBg = loadImage(endBgFile);
  endBg.resize(width, height);

  //setup the screens/worlds/grids in the Game
  splashScreen = new Screen("splash", splashBg);
  level1Grid = new Grid("chessBoard", mainBg, 10, 8);
  endScreen = new World("end", endBg);
  currentScreen = splashScreen;

  //setup the sprites  
  chef = loadImage(chefFile);
  chef.resize(level1Grid.getTileWidth(),level1Grid.getTileHeight());
    customer = loadImage(customerFile);
  customer.resize(level1Grid.getTileWidth(),level1Grid.getTileHeight());
  // enemy = loadImage("images/articuno.png");
  // enemy.resize(100,100);
  exampleAnimationSetup();

  //Adding pixel-based Sprites to the world
  // level1Grid.addSpriteCopyTo(exampleSprite);
  level1Grid.printSprites();
  System.out.println("Done adding sprites to main world..");

  
  //Other Setup
  // Load a soundfile from the /data folder of the sketch and play it back
  // song = new SoundFile(this, "sounds/Lenny_Kravitz_Fly_Away.mp3");
  // song.play();
  
  imageMode(CORNER);    //Set Images to read coordinates at corners
  //fullScreen();   //only use if not using a specfic bg image
  println("Game started...");

}

//Required Processing method that automatically loops
//(Anything drawn on the screen should be called from here)
void draw() {

  updateTitleBar();
  updateScreen();

  //simple timing handling
  if (msElapsed % 300 == 0) {
    //sprite handling
    populateSprites();
    moveCustomers();
  }
  msElapsed +=100;
  currentScreen.pause(100);

  //check for end of game
  if(isGameOver()){
    endGame();
  }

}

//Known Processing method that automatically will run whenever a key is pressed
void keyPressed(){

  //check what key was pressed
  System.out.println("Key pressed: " + key); //keyCode gives you an integer for the key

  //What to do when a key is pressed?
  
  //set [W] key to move the chef up & avoid Out-of-Bounds errors
  if(keyCode == 87){
   
    //Store old GridLocation
    GridLocation oldLoc = new GridLocation(chefRow, chefCol);

    //Erase image from previous location
    

    //change the field for chefRow
    chefRow--;
  }
  if(keyCode == 65){
      GridLocation oldLoc = new GridLocation(chefRow, chefCol);
      chefCol--;
    }
    if(keyCode == 83){
      GridLocation oldLoc = new GridLocation(chefRow, chefCol);
      chefRow++;
    }
    if(keyCode == 68){
      GridLocation oldLoc = new GridLocation(chefRow, chefCol);
      chefCol++;
    }


}

//Known Processing method that automatically will run when a mouse click triggers it
void mouseClicked(){
  
  //check if click was successful
  System.out.println("Mouse was clicked at (" + mouseX + "," + mouseY + ")");
  if(currentGrid != null){
    System.out.println("Grid location: " + currentGrid.getGridLocation());
  }

  //what to do if clicked? (Make chef jump back?)
  


  //Toggle the animation on & off
  doAnimation = !doAnimation;
  System.out.println("doAnimation: " + doAnimation);
  if(currentGrid != null){
    currentGrid.setMark("X",currentGrid.getGridLocation());
  }

}




//------------------ CUSTOM  GAME METHODS --------------------//

//method to update the Title Bar of the Game
public void updateTitleBar(){

  if(!isGameOver()) {
    //set the title each loop
    surface.setTitle(titleText + "    " + extraText + " " + health);

    //adjust the extra text as desired
  
  }

}

//method to update what is drawn on the screen each frame
public void updateScreen(){

  //Update the Background
  background(currentScreen.getBg());

  //splashScreen update
  if(splashScreen.getScreenTime() > 3000 && splashScreen.getScreenTime() < 5000){
    currentScreen = level1Grid;
  }

  //skyGrid Screen Updates
  if(currentScreen == level1Grid){
    currentGrid = level1Grid;

    //Display the chef image
    GridLocation chefLoc = new GridLocation(chefRow,chefCol);
    level1Grid.setTileImage(chefLoc, chef);
      
    //update other screen elements
    level1Grid.showSprites();
    level1Grid.showImages();
    level1Grid.showGridSprites();

    checkExampleAnimation();
    
  }

  //Other screens?


}

//Method to populate enemies or other sprites on the screen
public void populateSprites(){

  //What is the index for the last column?
int topRow = 0;

  //Loop through all the rows in the last column
  for (int c = 2; c <= 5; c++)
  {
    GridLocation loc = new GridLocation(topRow, c);
    //Generate a random number
    double random = Math.random();
    //10% of the time, decide to add an enemy image to a Tile
   if (random < 0.1)
   {
    level1Grid.setTileImage(loc, customer);
    System.out.println("Adding customer to " + loc);
   }
  }

}

//Method to move around the enemies/sprites on the screen
public void moveCustomers(){

//Loop through all of the rows & cols in the grid
for (int r = 0; r < 4; r++){
  for (int c = 2; c <= 5; c++){
    GridLocation loc = new GridLocation(r,c);
  
    //check for customer at location
    if(level1Grid.getTileImage(loc) == customer){

      //check if you SHOULD move the customer forward in line (no cust or counter in front)
      if(true){
        //eraser customer from current location
        level1Grid.clearTileSprite(loc);

        GridLocation newLoc = new GridLocation(r+1, c);

        level1Grid.setTileImage(newLoc, customer);
          //System.out.println("moving customer"); 
      }

    } 

  } //inner for loop
} //outer for loop


      //Store the current GridLocation

      //Store the next GridLocation

      //Check if the current tile has an image that is not chef      


        //Get image/sprite from current location
          

        //CASE 1: Collision with chef


        //CASE 2: Move enemy over to new location


        //Erase image/sprite from old location

        //System.out.println(loc + " " + grid.hasTileImage(loc));

          
      //CASE 3: Enemy leaves screen at first column

}

//Method to check if there is a collision between Sprites on the Screen
public boolean checkCollision(GridLocation loc, GridLocation nextLoc){

  //Check what image/sprite is stored in the CURRENT location
  // PImage image = grid.getTileImage(loc);
  // AnimatedSprite sprite = grid.getTileSprite(loc);

  //if empty --> no collision

  //Check what image/sprite is stored in the NEXT location

  //if empty --> no collision

  //check if enemy runs into player

    //clear out the enemy if it hits the player (using cleartTileImage() or clearTileSprite() from Grid class)

    //Update status variable

  //check if a player collides into enemy

  return false; //<--default return
}

//method to indicate when the main game is over
public boolean isGameOver(){
  
  return false; //by default, the game is never over
}

//method to describe what happens after the game is over
public void endGame(){
    System.out.println("Game Over!");

    //Update the title bar

    //Show any end imagery
    currentScreen = endScreen;

}

//example method that creates 1 horse run along the screen
public void exampleAnimationSetup(){  
  int i = 2;
  exampleSprite = new AnimatedSprite("sprites/horse_run.png", "sprites/horse_run.json", 50.0, i*75.0);
  //exampleSprite.resize(200,200);
}

//example method that animates the horse Sprites
public void checkExampleAnimation(){
  if(doAnimation){
    exampleSprite.animateHorizontal(5.0, 1.0, true);
    //System.out.println("animating!");
  }
}
