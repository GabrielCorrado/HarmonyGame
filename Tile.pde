//Author:  Nick Corrado
//Date:    12/14/15
//Desc:    Tiles to be used in the game Harmony. They can connect via their north, east, south, and west edges, which are true when connected and false when unconnected.
//Title:   Tile

public class Tile {
  private int x, y;
  private boolean north, east, south, west;
  private double tileSize;
  
  //constructor
  public Tile(int x, int y, double tileSize, boolean north, boolean east, boolean south, boolean west) {
    this.x = x;
    this.y = y;
    this.tileSize = tileSize;
    this.north = north;
    this.east = east;
    this.south = south;
    this.west = west;
  }
  
  //draws the Tile; n.b. each direction's rectangle is drawn separately, overlapping in the center
  public void draw() {
    fill(0);
    stroke(0);
    rectMode(CORNERS);
    if (north) {
      rect((int)(x+tileSize*2/5),y,(int)(x+tileSize*3/5),(int)(y+tileSize*3/5));
    }
    if (east) {
      rect((int)(x+tileSize*2/5),(int)(y+tileSize*2/5),(int)(x+tileSize),(int)(y+tileSize*3/5));
    }
    if (south) {
      rect((int)(x+tileSize*2/5),(int)(y+tileSize*2/5),(int)(x+tileSize*3/5),(int)(y+tileSize));
    }
    if (west) {
      rect(x,(int)(y+tileSize*2/5),(int)(x+tileSize*3/5),(int)(y+tileSize*3/5));
    }
  }
  
  public void rotate_() {
    //draws a white rectangle over the previous Tile, then rotates the Tile's edges touched by 90 degrees, so upon next draw() it has rotated 90 degrees
    fill(255);
    stroke(0);
    rectMode(CORNERS);
    rect(x,y,(int)(x+tileSize),(int)(y+tileSize));
    fill(0);
    
    //this moves each rotation 90 degrees clockwise
    boolean temp = west;
    west = south;
    south = east;
    east = north;
    north = temp;
  }
  
  //getters
  public int getX() {
    return x;
  }
  
  public int getY() {
    return y;
  }
  
  public boolean getNorth() {
    return north;
  }
  
  public boolean getEast() {
    return east;
  }
  
  public boolean getSouth() {
    return south;
  }
  
  public boolean getWest() {
    return west;
  }
  
  //takes in any int and sets the block's corresponding direction to true, where 0 = north, 1 = east, 2 = south, 3 = west
  //n.b. would do nothing with negative numbers; this method is a bit of a hack to simplify assigning directions
  public void setDir(int i) {
    if (i%4 == 0) {
      north = true;
    }
    else if (i%4 == 1) {
      east = true;
    }
    else if (i%4 == 2) {
      south = true;
    }
    else if (i%4 == 3) {
      west = true;
    }
  }
}