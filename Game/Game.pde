/* Game Class Starter File
 * Authors: Carlos Perez | Justin Avila
 * Last Edit: 5/20/2024
 */

//import processing.sound.*;

//------------------ GAME VARIABLES --------------------//

//VARIABLES: Title Bar
String titleText = "Crazy Chef";
String heldItem = "Holding: Nothing";
String extraText = heldItem;

//VARIABLES: Splash Screen
Screen splashScreen;
String splashBgFile = "images/apcsa.png";
PImage splashBg;

//VARIABLES: Level1Grid Screen
Grid level1Grid;
String level1BgFile = "images/wooden_plank-transformed.jpeg";
PImage level1Bg;

PImage chef;
String chefFile = "images/Chef_Player_2.gif";
int chefRow = 7;
int chefCol = 1;
int health = 3;

PImage customer;
String customerFile = "images/Customer_1.png";

PImage kCounter;
String kCounterFile = "images/kitchen_counter.jpg";
int kCounterRow = 9;
int kCounterCol = 0;
GridLocation kCounterLoc = new GridLocation(kCounterRow, kCounterCol);

PImage burger;
String burgerFile = "images/Burger.png";
int burgerRow = 9;
int burgerCol = 1;
GridLocation burgerLoc = new GridLocation(burgerRow, burgerCol);

PImage fries;
String friesFile = "images/Fries.png";
int friesRow = 9;
int friesCol = 3;
GridLocation friesLoc = new GridLocation(friesRow, friesCol);

PImage cola;
String colaFile = "images/Cola.png";
int colaRow = 9;
int colaCol = 5;
GridLocation colaLoc = new GridLocation(colaRow, colaCol);

//EndScreen variables
World endScreen;
PImage endBg;
String endBgFile = "images/youwin.png";


//VARIABLES: Tracking the current Screen being displayed
Screen currentScreen;
World currentWorld;
Grid currentGrid;
private int msElapsed = 0;
//SoundFile song;

//------------------ REQUIRED PROCESSING METHODS --------------------//

//Required Processing method that gets run once
void setup() {

  //SETUP: Match the screen size to the background image size
  size(800,1000);
  
  //SETUP: Set the title on the title bar
  surface.setTitle(titleText);

  //SETUP: Load BG images used in all screens
  splashBg = loadImage(splashBgFile);
  splashBg.resize(width, height);
  level1Bg = loadImage(level1BgFile);
  level1Bg.resize(width, height);
  endBg = loadImage(endBgFile);
  endBg.resize(width, height);

  //SETUP: Screens, Worlds, Grids
  splashScreen = new Screen("splash", splashBg);
  level1Grid = new Grid("chessBoard", level1Bg, 10, 8);
  endScreen = new World("end", endBg);
  currentScreen = splashScreen;


  //SETUP: Level 1
  chef = loadImage(chefFile);
  chef.resize(level1Grid.getTileWidth(),level1Grid.getTileHeight());
  customer = loadImage(customerFile);
  customer.resize(level1Grid.getTileWidth(),level1Grid.getTileHeight());
  kCounter = loadImage(kCounterFile);
  kCounter.resize(level1Grid.getTileWidth(),level1Grid.getTileHeight());
  level1Grid.setTileImage(kCounterLoc, kCounter);
  burger = loadImage(burgerFile);
  burger.resize(level1Grid.getTileWidth(),level1Grid.getTileHeight());
  level1Grid.setTileImage(burgerLoc, burger);
  fries = loadImage(friesFile);
  fries.resize(level1Grid.getTileWidth(),level1Grid.getTileHeight());
  level1Grid.setTileImage(friesLoc, fries);
  cola = loadImage(colaFile);
  cola.resize(level1Grid.getTileWidth(),level1Grid.getTileHeight());
  level1Grid.setTileImage(colaLoc, cola);

  System.out.println("Done adding sprites to main world..");

  
  //SETUP: Sound
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
  if(keyCode == 87 && chefRow > 6){
   
    //Store old GridLocation
    GridLocation oldLoc = new GridLocation(chefRow, chefCol);

    //Erase image from previous location
    level1Grid.clearTileImage(oldLoc);

    //change the field for chefRow
    chefRow--;
  }
  else if(keyCode == 65 && chefCol > 0){
    GridLocation oldLoc = new GridLocation(chefRow, chefCol);
    level1Grid.clearTileImage(oldLoc);
    chefCol--;
  }
  else if(keyCode == 83 && chefRow < 8){
    GridLocation oldLoc = new GridLocation(chefRow, chefCol);
    level1Grid.clearTileImage(oldLoc);
    chefRow++;
  }
  else if(keyCode == 68 && chefCol < 7){
    GridLocation oldLoc = new GridLocation(chefRow, chefCol);
    level1Grid.clearTileImage(oldLoc);
    chefCol++;
  }

  //CHANGING SCREENS BASED ON KEYS
  //change to level1 if 1 key pressed, level2 if 2 key is pressed
  if(key == '0'){
    currentScreen = splashScreen;
  } else if(key == '1'){
    currentScreen = level1Grid;
  } else if(key == '2'){
    currentScreen = endScreen;
  }



}

//Known Processing method that automatically will run when a mouse click triggers it
void mouseClicked(){
  
  //check if click was successful
  System.out.println("\nMouse was clicked at (" + mouseX + "," + mouseY + ")");
  if(currentGrid != null){
    System.out.println("Grid location: " + currentGrid.getGridLocation());
  }

  //what to do if clicked? (Make chef jump back?)
  


  //Toggle the animation on & off

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

  //UPDATE: Background of the current Screen
  if(currentScreen.getBg() != null){
    background(currentScreen.getBg());
  }

  //UPDATE: splashScreen
  if(currentScreen == splashScreen){
    System.out.print("s");
    
    if(splashScreen.getScreenTime() > 3000 && splashScreen.getScreenTime() < 5000){
    currentScreen = level1Grid;
    }
  }

  //UPDATE: level1Grid Screen
  if(currentScreen == level1Grid){
    System.out.print("1");
    currentGrid = level1Grid;

    //Display the chef image
    GridLocation chefLoc = new GridLocation(chefRow,chefCol);
    level1Grid.setTileImage(chefLoc, chef);
      
    //update other screen elements
    level1Grid.showSprites();
    level1Grid.showImages();
    level1Grid.showGridSprites();
    
  }

  //UPDATE: End Screen
  // if(currentScreen == endScreen){

  // }

} //end updateScreen()

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

    //clear out the enemy if it hits the player (using clearTileImage() or clearTileSprite() from Grid class)

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

