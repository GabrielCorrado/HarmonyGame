//Author:  Nick Corrado
//Date:    12/14/15
//Desc:    A game of matching tile edges together on a randomly generated square grid. (Try it!) Gameplay rules identical to "loops of zen" by Dr. Arend Hintze: http://www.alproductions.us/Loops_Of_Zen/Loops_Of_Zen/Welcome.html
//Title:   Harmony

//initializing variables
int screenSize = 600; //dimensions of screen
int dims = 3; //dimensions of the (square) board
int margin = 100; //margin around the board
double tileSize = (screenSize-2*margin)/dims; //size of each tile on the board
Tile[][] boardTiles = new Tile[dims][dims]; //all tiles on the board, as a 2d array; this should be a separate class =|
boolean won;
boolean mode; //true is hard mode, false is easy mode

//this is the only way to set the screen size from a variable
void settings() {
  size(screenSize, screenSize);
}

void setup() {
  //initializes a starting game on easy mode
  stroke(0);
  background(255);
  won = false;
  mode = false;
  //initializes the map as a bunch of blanks
  for (int i = 0; i < dims; i++) {
    for (int j = 0; j < dims; j++) {
      boardTiles[i][j] = new Tile((int)(margin+j*tileSize),(int)(margin+i*tileSize),tileSize,false,false,false,false);
    }
  }
  
  //calls the easy mode level gen
  levelGen();
}

void draw() {
  if (won) {
    fill(0);
    //background(255);
    textSize(40);
    text("You won!",width/2-margin,margin/2);
    text("Click to play again",width/2-margin*2,height-margin/2);
  }
  else {
    //draws a UI
    drawUI();
    
    //draws a coord grid based on the window and board dimensions
    stroke(0);
    fill(0);
    for (int i = 0; i < dims+1; i++) {
      line(margin,(int)(margin+i*tileSize),(int)(margin+dims*tileSize),(int)(margin+i*tileSize));
      line((int)(margin+i*tileSize),margin,(int)(margin+i*tileSize),(int)(margin+dims*tileSize));
    }
    
    //draws all the tiles
    for (int i = 0; i < dims; i++) {
      for (int j = 0; j < dims; j++) {
        boardTiles[i][j].draw();
      }
    }
  }
}

void mousePressed() {
  if (won) {
    won = false;
    //resets the board and increments the dimension (a bit of a hack for "levels" for now)
    background(255);
    dims++;
    tileSize = (screenSize-2*margin)/dims;
    //empties the array of tiles
    boardTiles = new Tile[dims][dims];
    for (int i = 0; i < dims; i++) {
      for (int j = 0; j < dims; j++) {
        boardTiles[i][j] = new Tile(margin+j*(int)tileSize,margin+i*(int)tileSize,tileSize,false,false,false,false);
      }
    }
    
    //creates a new level, depending on what mode is selected
    if (mode) {
      levelGen2();
    }
    else {
      levelGen();
    }
  }
  //checks for button clicks on the UI
  else if (mouseX >= margin/2-margin/3 && mouseX < margin/2+margin/3 && mouseY >= margin+10-20 && mouseY < margin+10+20) {
    //home button
    //nothing happens for now; should clear the screen and initialize a home screen featuring instructions and a level select, say
  }
  else if (mouseX >= margin/2-margin/3 && mouseX < margin/2+margin/3 && mouseY >= margin+50-20 && mouseY < margin+50+20) {
    //reset button
    //re-randomizes the current map rather than generating a different one
    for (int i = 0; i < dims; i++) {
      for (int j = 0; j < dims; j++) {
        int randRot = (int)random(4);
        for (int k = 0; k < randRot; k++) {
          boardTiles[i][j].rotate_();
        }
      }
    }
  }
  else if (mouseX >= margin/2-margin/3 && mouseX < margin/2+margin/3 && mouseY >= margin+90-20 && mouseY < margin+90+20) {
    //you've clicked the Hard Mode button
    //switches modes; easy -> hard or hard -> easy
    mode = !mode;
    //clears board
    background(255);
    boardTiles = new Tile[dims][dims];
    for (int i = 0; i < dims; i++) {
      for (int j = 0; j < dims; j++) {
        boardTiles[i][j] = new Tile(margin+j*(int)tileSize,margin+i*(int)tileSize,tileSize,false,false,false,false);
      }
    }
    //generates a new level depending on which direction you switched
    if (mode) {
      levelGen2();
    }
    else {
      levelGen();
    }
  }
  else {
    //on a mousepress, if it falls on a tile, it rotates the clicked tile by 90 degrees
    for (int i = 0; i < dims; i++) {
      for (int j = 0; j < dims; j++) {
        if (mouseX >= boardTiles[i][j].getX() && mouseX < boardTiles[i][j].getX()+tileSize && mouseY >= boardTiles[i][j].getY() && mouseY < boardTiles[i][j].getY()+tileSize) {
          boardTiles[i][j].rotate_();
        }
      }
    }
    
    draw();
    
    //checks every time whether it has now been solved
    checkSolution();
  }
}

void checkSolution() {
  won = true;
  //first checks edges, which are treated differently depending on what modei s being played
  if (mode) {
    checkEdges2();
  }
  else {
    checkEdges();
  }
  
  //then checks east sides of every tile but east column
  for (int i = 0; i < dims; i++) {
    for (int j = 0; j < dims-1; j++) {
      if (boardTiles[i][j].getEast() && !boardTiles[i][j+1].getWest()) {
        won = false;
      }
    }
  }
  
  //then check south sides of every tile but south row
  for (int i = 0; i < dims-1; i++) {
    for (int j = 0; j < dims; j++) {
      if (boardTiles[i][j].getSouth() && !boardTiles[i+1][j].getNorth()) {
        won = false;
      }
    }
  }
  
  //west sides mutatis mutandis
  for (int i = 0; i < dims; i++) {
    for (int j = 1; j < dims; j++) {
      if (boardTiles[i][j].getWest() && !boardTiles[i][j-1].getEast()) {
        won = false;
      }
    }
  }
  
  //north sides m.m.
  for (int i = 1; i < dims; i++) {
    for (int j = 0; j < dims; j++) {
      if (boardTiles[i][j].getNorth() && !boardTiles[i-1][j].getSouth()) {
        won = false;
      }
    }
  }
}

void checkEdges() {
  //checks whether edge tiles have anything pointing outward on easy mode
  //checks top row
  for (int j = 0; j < dims; j++) {
    if (boardTiles[0][j].getNorth()) {
      won = false;
    }
  }
  
  //checks left row
  for (int i = 0; i < dims; i++) {
    if (boardTiles[i][0].getWest()) {
      won = false;
    }
  }
  
  //checks bottom row
  for (int j = 0; j < dims; j++) {
    if (boardTiles[dims-1][j].getSouth()) {
      won = false;
    }
  }
  
  //checks right row
  for (int i = 0; i < dims; i++) {
    if (boardTiles[i][dims-1].getEast()) {
      won = false;
    }
  }
}

void checkEdges2() {
  //checks whether edges match opposite side's edges on hard mode; if one is true but the other is false, they conflict so must be wrong
  //checks top row against bottom row
  for (int j = 0; j < dims; j++) {
    if (boardTiles[0][j].getNorth() && !boardTiles[dims-1][j].getSouth()) {
      won = false;
    }
  }
  
  //checks left row against right row
  for (int i = 0; i < dims; i++) {
    if (boardTiles[i][0].getWest() && !boardTiles[i][dims-1].getEast()) {
      won = false;
    }
  }
  
  //checks bottom row against top row
  for (int j = 0; j < dims; j++) {
    if (boardTiles[dims-1][j].getSouth() && !boardTiles[0][j].getNorth()) {
      won = false;
    }
  }
  
  //checks right row against left row
  for (int i = 0; i < dims; i++) {
    if (boardTiles[i][dims-1].getEast() && !boardTiles[i][0].getWest()) {
      won = false;
    }
  }
}

void drawUI() {
  //draws a UI on the left
  //this should be a separate class, but I'm saving that for the rewrite
  //draws three black-bordered white rectangles in the left margin
  stroke(0);
  fill(255);
  rectMode(CENTER);
  rect(margin/2,margin+10,margin/1.5,20);
  rect(margin/2,margin+50,margin/1.5,20);
  rect(margin/2,margin+90,margin/1.5,20);
  
  //draws black text in those rectangles
  fill(0);
  textSize(12);
  text("Home",margin/4+5,margin+15);
  text("Reset",margin/4+5,margin+55);
  if (mode) {
    text("Easy Mode",margin/4-5,margin+95);
  } else {
    text("Hard Mode",margin/4-5,margin+95);
  }
}

void levelGen() {
  //counts connections made over time, and while the number of connections is below a target percentage (e.g. 75%), keep picking random tiles and directions
  int numCons = 0;
  int randPos = (int)random(dims*dims);
  int randPosX = randPos%dims; //its x place in the array
  int randPosY = randPos/dims; //its y place
  Tile startPos = boardTiles[randPosY][randPosX];
  //while the ratio of the number of connections over the number of total possible connections on a square grid is less than 0.75 ...
  while ((double)numCons/(4*2+(dims-2)*4*3+(dims-2)*(dims-2)*4) < 0.75) {
    //picks a direction at random, and ...
    int randRot = (int)random(4);
    //... if startPos has a neighbor in that direction, ...
    if (checkDir(randRot, randPosX, randPosY)) {
      startPos.setDir(randRot); //sets the direction to true
      numCons++;
      pickTile(randRot,randPosX,randPosY).setDir(randRot+2); //sets neighbor's corresponding direction to true
      numCons++;
      //picks new startPos at random
      randPos = (int)random(dims*dims);
      randPosX = randPos%dims;
      randPosY = randPos/dims;
      startPos = boardTiles[randPosY][randPosX];
    }
  }
  
  //finally, applies a random number of rotations to every block
  for (int i = 0; i < dims; i++) {
    for (int j = 0; j < dims; j++) {
      int randRot = (int)random(4);
      for (int k = 0; k < randRot; k++) {
        boardTiles[i][j].rotate_();
      }
    }
  }
}

void levelGen2() {
  //this level gen embeds the map on a torus, so connections from the bottom row to the top and from the left column to the right and vice versa are possible
  //this makes the game considerably tougher, hence the designation "hard mode"
  //counts connections made over time, and while the number of connections is below a target percentage (e.g. 60%), keep picking random tiles and directions
  int numCons = 0;
  int randPos = (int)random(dims*dims);
  int randPosX = randPos%dims; //its x place in the array
  int randPosY = randPos/dims; //its y place
  Tile startPos = boardTiles[randPosY][randPosX];
  //while the ratio of the number of connections over the number of total possible connections on a toroidal grid is less than 0.6 ...
  while ((double)numCons/(dims*dims*4) < 0.6) {
    //picks a direction at random, and ...
    int randRot = (int)random(4);
    //... if startPos has a neighbor in that direction (i.e. the normal case), ...
    if (checkDir(randRot, randPosX, randPosY)) {
      startPos.setDir(randRot); //sets the direction to true
      numCons++;
      pickTile(randRot,randPosX,randPosY).setDir(randRot+2); //sets neighbor's corresponding direction to true
      numCons++;
    }
    // ... else the neighbor does not have a neighbor, so we're connecting to the corresponding tile on the opposite side of the map
    else {
      startPos.setDir(randRot); //sets the direction to true
      numCons++;
      pickTile2(randRot,randPosX,randPosY).setDir(randRot+2); //sets neighbor's corresponding direction to true
      numCons++;
    }
    //picks new startPos at random
    randPos = (int)random(dims*dims);
    randPosX = randPos%dims;
    randPosY = randPos/dims;
    startPos = boardTiles[randPosY][randPosX];
  }
  
  //finally, applies a random number of rotations to every block
  for (int i = 0; i < dims; i++) {
    for (int j = 0; j < dims; j++) {
      int randRot = (int)random(4);
      for (int k = 0; k < randRot; k++) {
        boardTiles[i][j].rotate_();
      }
    }
  }
}

boolean checkDir(int dir, int tileX, int tileY) {
  //checks whether there can be a neighbor in a given direction for a given block
  //tileX and tileY refer to a tile's positions in the array, NOT its x coordinates in the window
  if (dir == 0) { //north
    if (tileY-1 >= 0) {
      return true;
    }
  }
  else if (dir == 1) { //east
    if (tileX+1 < dims) {
      return true;
    }
  }
  else if (dir == 2) { //south
    if (tileY+1 < dims) {
      return true;
    }
  }
  else if (dir == 3) { //west
    if (tileX-1 >= 0) {
      return true;
    }
  }
  return false;
}

Tile pickTile(int dir, int tileX, int tileY) {
  //returns the tile in that direction; ONLY USE THIS AFTER USING CHECKDIR, OTHERWISE IT COULD RETURN A NULL
  if (dir == 0) {
    return boardTiles[tileY-1][tileX];
  }
  else if (dir == 1) {
    return boardTiles[tileY][tileX+1];
  }
  else if (dir == 2) {
    return boardTiles[tileY+1][tileX];
  }
  else if (dir == 3) {
    return boardTiles[tileY][tileX-1];
  }
  return null;
}

Tile pickTile2(int dir, int tileX, int tileY) {
  //returns the tile on the opposite edge of the board; used to get corresponding tile in hard mode level gen
  if (dir == 0) {
    return boardTiles[dims-1][tileX];
  }
  else if (dir == 1) {
    return boardTiles[tileY][0];
  }
  else if (dir == 2) {
    return boardTiles[0][tileX];
  }
  else if (dir == 3) {
    return boardTiles[tileY][dims-1];
  }
  return null;
}