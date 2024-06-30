WebScraper scraper;
newTable locTable;
newTable popTable;
PImage mapImage;
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;
PFont font;
float closestDist;
String closestText;
float closestTextX;
float closestTextY;

void setup() {
  size(867, 800);
  mapImage = loadImage("map.jpg");

  String url = "https://en.wikipedia.org/wiki/Subdivisions_of_Egypt";
  
  // Initialize the WebScraper object with the URL
  scraper = new WebScraper(url);

  // Display the data
  scraper.display();

  // Save the data as a CSV file
  scraper.saveAsTSV("egypt-pop");

  locTable = new newTable("location.tsv");
  popTable = new newTable("egypt-pop.tsv");
  
  rowCount = locTable.getRowCount( );
  
  // load font
  font = createFont("Arial", 18);
  textFont(font);
  
  // Find the minimum and maximum values
  for (int row = 0; row < rowCount; row++) {
   float value = popTable.getFloat(row, 1);
    if (value > dataMax) {
      dataMax = value;
    }
    if (value < dataMin) {
      dataMin = value;
    }
  }
}

void draw(){
  background(255);
  image(mapImage, 0, 0);
   closestDist = MAX_FLOAT;
  // Drawing attributes for the ellipses.
   smooth();
   noStroke();
 for (int row = 0; row < rowCount; row++) {
   String name = popTable.getRowName(row);
   float x = locTable.getFloat(name, 1);
   float y = locTable.getFloat(name, 2);
   drawData(x, y, name);
   }
   
 // Use global variables set in drawData( ) to draw text related to closest circle.
 if (closestDist != MAX_FLOAT) {
  
    // Calculate text width and height
    float textWidth = textWidth(closestText);
    float textHeight = textAscent() + textDescent();
  
    // Draw a filled rectangle behind the text
    float rectX = closestTextX - (textWidth / 2) - 5; // Adjust for padding
    float rectY = closestTextY - textHeight ;
    float rectWidth = textWidth + 15; // Adjust for padding
    float rectHeight = 2*textHeight + 10 ; // Adjust for padding
    fill(255); // Background color for the text
    smooth();
    rect(rectX, rectY, rectWidth, rectHeight);
 
    fill(0);
    textAlign(CENTER);
    text(closestText, closestTextX, closestTextY);
   }
}

void drawData(float x, float y, String name) {
 float mean = popTable.calculateMean(1);
 int value = popTable.getInt(name, 1);
 float radius = 0;
 if (value >= mean) {
   radius = map(value, mean , dataMax, 10, 12.5);
   float percent = norm(value, mean, dataMax);
   color between = lerpColor(#FFAE00 , #B90000 , percent); //orange - red
   float a = map(value, mean, dataMax, 200, 255);
   fill(between,a);
 }  else  {
   radius = map(value, dataMin, mean, 7.5, 10);
   float percent = norm(value, dataMin, mean);
   color between = lerpColor(#7DFF8B, #FFE000 , percent); //green - yellwo
   float a = map(value, dataMin, mean, 150, 200);
   fill(between,a); 
 }
 ellipseMode(RADIUS);
 ellipse(x, y, radius, radius);
 float d = dist(x, y, mouseX, mouseY);
 // Because the following check is done each time a new circle is drawn, we end up with the values of the circle closest to the mouse.
 if ((d < radius + 2) && (d < closestDist)) {
   closestDist = d;
   closestText = "Governorate: " + name.trim() + "\nPopulation: " + formatNumber(value);
   closestTextX = x;
   closestTextY = y-radius-25;
  }
}

String formatNumber(int number) {
  String str = str(number); // Convert the number to a string
  String formatted = ""; // Initialize an empty string for the formatted output
  int count = 0; // Counter to keep track of digits

  // Iterate through the string in reverse order
  for (int i = str.length() - 1; i >= 0; i--) {
    char c = str.charAt(i); // Get the current character

    // Add the current character to the formatted string
    formatted = c + formatted;
    count++;

    // Add a comma after every 3 digits, except for the last group of digits
    if (count % 3 == 0 && i != 0) {
      formatted = "," + formatted;
    }
  }
  return formatted;
}
