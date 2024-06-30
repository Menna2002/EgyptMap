class WebScraper {
  Table dataTable;

  WebScraper(String url) {
    dataTable = new Table();
    dataTable.addColumn("city");
    dataTable.addColumn("population", Table.INT);

    int rowCount = 0; // Counter to track the number of rows processed

    try {
      Document doc = Jsoup.connect(url).get();
      Element table = doc.select("table.wikitable.sortable").first();

      if (table != null) {
        Elements rows = table.select("tr");

        for (Element row : rows) {
          Elements cells = row.select("td");
          if (cells.size() >= 4) { // Make sure the table has at least 4 columns
            String city = cells.get(0).text().replaceAll("\\[\\d+\\]", ""); // First column, remove "[23]" text
            String popString = cells.get(2).text(); // Third column (index 2)
            int population = 0; // Default value
            try {
              population = Integer.parseInt(popString.replace(",", "")); // Parse the text to an integer
            } catch (NumberFormatException e) {
              // Handle parsing errors, such as non-integer values in the table
              println("Error parsing pop value: " + popString);
            }
            TableRow newRow = dataTable.addRow();
            newRow.setString("city", city);
            newRow.setInt("population", population);
            
            rowCount++; // Increment the counter
            if (rowCount == 27) // Check if we have reached 27 rows
              break; // Exit the loop
          }
        }
      } else {
        println("Table not found!");
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  void display() {
    println(dataTable);
  }

  void saveAsTSV(String filename) {
    saveTableAsTSV(dataTable, filename);
  }

void saveTableAsTSV(Table table, String filename) {
    String[] lines = new String[table.getRowCount()]; // Create an array to hold lines of text

    // Find the maximum length of city name
    int maxCityLength = 0;
    for (int i = 0; i < table.getRowCount(); i++) {
        String city = table.getString(i, "city");
        maxCityLength = Math.max(maxCityLength, city.length());
    }

    // Iterate over table rows and construct each line of text
    for (int i = 0; i < table.getRowCount(); i++) {
        String city = table.getString(i, "city");
        int population = table.getInt(i, "population");

        // Use tab characters to align the columns
        lines[i] = String.format("%-" + (maxCityLength + 1) + "s\t%d", city, population);
    }

    // Save lines array to a text file with .tsv extension
    saveStrings(filename + ".tsv", lines);
    System.out.println("Data saved as " + filename + ".tsv");
  }
}
