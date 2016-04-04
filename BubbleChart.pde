/*
Author Jaka Cikac, based on //http://www.openprocessing.org/sketch/51382
 
 This code is meant to create a nice bubble chart visualization with 
 4 dimensions (x axis, y axis, circle color and circle diameter).
 
 Areas in comments like
 ------------------------
 something 
 ------------------------
 need your attention, since they contain customisable parameters.
 */

Plot plot;
Table table;
Data rd;

Bubble[] bubbles;
Bubble[] legendBubbles;
PFont titleFont, smallFont;

int leftMargin = 80;
int rightMargin = 20;
int topMargin = 100;
int bottomMargin = 180;

// ----------------------
// A bunch of default data, later to be modified according to real data
String nameLabel = "Brand";
// on axis text
String xAxisText = "# of Units";
String yAxisText = "Value [$]";
// in data
String xLabelText = "Units sold";
String yLabelText = "Average Price";
String colorLabel = "Change";
String radiusLabel = "Market share";
// hover label (try to keep this short
int numRows = 20;

int minx = 0;
int maxx = 1000;
int numTicksX = 10;

int miny = 0;
int maxy = 1000;
int numTicksY = 10;

// Define the minimum radius of a bubble
int minRadius = 10;
// Define the maximum radius of a bubble
int maxRadius = 30;
// min value of data for radius
float minValueR = 0;
// max value of data for radius
float maxValueR = 100;

int numberOfBubbles = 40;
// ----------------------

// Define your colors
// ------------------------------------------
color red = color(255, 102, 102, 150);
color green = color(102, 255, 102, 150);
// ------------------------------------------

void setup() {
  // set the size of the canvas
  size(640, 640);
  smooth();
  frameRate(30);

  titleFont = loadFont("Helvetica-22.vlw");
  smallFont = loadFont("Helvetica-12.vlw");
  textFont(smallFont);

  // ----------------------------------------------------------
  // read in the data to display and pass it to generate values
  // set the minx, maxx, miny, maxy according to the data!!

  // LOAD the DATA
  rd = new Data("cars.tsv");
  table = rd.readData();
  numRows = rd.getNumRows();

  xLabelText = "Units sold";
  yLabelText = "Average Price";
  colorLabel = "Change";

  maxx = int(rd.getMaxValue(xLabelText)) + 3000; // add some number to make the plot look better
  maxy = int(rd.getMaxValue(yLabelText)) + 3000; // add some number to make the plot look better
  minValueR = rd.getMinValue(radiusLabel);
  maxValueR = rd.getMaxValue(radiusLabel);

  // ----------------------------------------------------------


  // initialize plot
  plot = new Plot(leftMargin, topMargin, rightMargin, bottomMargin, width, height, color(235));
  // compute the space between ticks, to be able to plot data correctly
  plot.computeTickSpace(numTicksX, numTicksY);

  generateValues(plot.xspace, plot.yspace, plot.yaxislen);


  
}

void draw() {
  // set main background to white on each call
  background(255);

  // display plot
  plot.display();
  // draw axes and text
  plot.drawAxes(minx, maxx, numTicksX, miny, maxy, numTicksY, xAxisText, yAxisText);

  // display bubbles
  for (int i = 0; i < bubbles.length; i++) {
    bubbles[i].display();
  }

  // display labels
  for (int i = 0; i < bubbles.length; i++) {
    bubbles[i].displayLabel(xLabelText, yLabelText, radiusLabel);
  }

  // Dispaly headline text
  fill(30);
  textFont(titleFont);
  text("Units sold, USA February 2016", leftMargin, topMargin-30);
  float textHeight = textAscent();
  textFont(smallFont);
  text("Author: Jaka Cikac", leftMargin, 30 + textHeight);
  
  color[] c = {green, red};
  generateLegend(minRadius, maxRadius, minValueR, maxValueR, c,  plot.yaxislen);
  
  // display legend bubbles
  for (int i = 0; i < legendBubbles.length; i++) {
    legendBubbles[i].display();
  }
  
}

// What happens on key press? Maybe change color scheme
void keyPressed() {
  // generate a new window with author name and metadata
}

// Generate data values
void generateValues(float xspace, float yspace, int yaxislen) {

  bubbles =  new Bubble[numRows];

  int i = 0;
  for (TableRow row : table.rows()) {

    // Get bubble name
    String name = row.getString(nameLabel);


    // Get values for x and y axis
    int x = row.getInt(xLabelText);
    int y = row.getInt(yLabelText);



    // Define COLOR data and RADIUS data, change if needed!!
    // ------------------------------------------
    String change = row.getString(colorLabel);

    color c = color(255, 255, 255); 
    if (change.equals("plus"))
      c = green;
    else if (change.equals("minus"))
      c = red;

    float marketShare = row.getFloat(radiusLabel);

    // map radiusValue to actual radius
    float r = mapToInterval(minValueR, maxValueR, minRadius, maxRadius, marketShare);
    // -------------------------------------------

    // calculate the x coordinate of the data
    float tickValueX = maxx / numTicksX; // value at first tick
    float offsetx = (x / tickValueX) * xspace; // offset from the x axis start
    float xcoord = offsetx + leftMargin;

    // calculate the y coordinate of the data
    float tickValueY = maxy / numTicksY; // value at first tick
    float offsety = (y / tickValueY) * yspace; // offset from the x axis start
    float ycoord = topMargin + yaxislen - offsety;

    bubbles[i] = new Bubble(name, xcoord, ycoord, x, y, r, marketShare, c);
    i++;
  }
}

float mapToInterval(float min, float max, float a, float b, float value) {
  return (((b - a) * (value - min))/(max - min)) + a;
}

// This part is heavily hardcoded ...
void generateLegend(int minRadius, int maxRadius, float minValue, float maxValue, color[] c, int yaxislen) {
  
  // generate radius legend
  legendBubbles = new Bubble[4];
  float ycoord = topMargin + yaxislen + 100;
  float xcoord = leftMargin;
  legendBubbles[0] = new Bubble(" ", xcoord + 20, ycoord, 0, 0, minRadius, minValue, c[0]);
  legendBubbles[1] = new Bubble(" ", xcoord + 70, ycoord, 100, 0, maxRadius, maxValue, c[0]);
  fill(color(128,128,128));
  text(round(minValue), xcoord + 20 - textWidth(str(round(minValue)))/2, ycoord + textAscent()/2);
  text(round(maxValue), xcoord + 70 - textWidth(str(round(maxValue)))/2, ycoord + textAscent()/2);
  text("Market Share", xcoord + 15, ycoord + 45);
  
  // draw line
  stroke(0.5);
  strokeWeight(0.5);
  line(xcoord + 125, ycoord - 30, xcoord + 125, ycoord + 30); 
  
   // generate color legend
  legendBubbles[2] = new Bubble(" ", xcoord + 170, ycoord - 15, 0, 0, maxRadius/2, minValue, c[0]);
  legendBubbles[3] = new Bubble(" ", xcoord + 170, ycoord + 15, 100, 0, maxRadius/2, maxValue, c[1]);
  
  text("Green color if # units sold is larger than one year before." , xcoord + 195 - textWidth(str(round(minValue)))/2, ycoord + textAscent()/2 - 15);
  text("Red color if # units sold is smaller than one year before.", xcoord + 198 - textWidth(str(round(maxValue)))/2, ycoord + textAscent()/2 + 15);
  text("Color depicts change since last year.", xcoord + 150, ycoord + 45);

}