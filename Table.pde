import java.io.PrintWriter;

class newTable {
    String[][] data;
    int rowCount;

    newTable() {
        data = new String[27][27];
    }

    newTable(String filename) {
        String[] rows = loadStrings(filename);
        data = new String[rows.length][];
        rowCount = 0;
        
        for (int i = 0; i < rows.length; i++) {
            if (trim(rows[i]).length() == 0) {
                continue; // skip empty rows
            }
            if (rows[i].startsWith("#")) {
                continue;  // skip comment lines
            }

            // split the row on the tabs
            String[] pieces = split(rows[i], TAB);
            // copy to the table array
            data[rowCount] = pieces;
            rowCount++;
        }
        // resize the 'data' array as necessary
        data = (String[][]) subset(data, 0, rowCount);
    }

    int getRowCount() {
        return rowCount;
    }

    // find a row by its name, returns -1 if no row found
    int getRowIndex(String name) {
        for (int i = 0; i < rowCount; i++) {
            if (data[i][0].equals(name)) {
                return i;
            }
        }
        println("No row named '" + name + "' was found");
        return -1;
    }

    String getRowName(int row) {
        return getString(row, 0);
    }

    String getString(int rowIndex, int column) {
        return data[rowIndex][column];
    }

    String getString(String rowName, int column) {
        return getString(getRowIndex(rowName), column);
    }

    int getInt(String rowName, int column) {
        return parseInt(getString(rowName, column));
    }

    int getInt(int rowIndex, int column) {
        return parseInt(getString(rowIndex, column));
    }

    float getFloat(String rowName, int column) {
        return parseFloat(getString(rowName, column));
    }

    float getFloat(int rowIndex, int column) {
        return parseFloat(getString(rowIndex, column));
    }

float calculateMean(int columnIndex) {
    float sum = 0;
    int count = 0;

    // Calculate the sum of values in the specified column
    for (int i = 1; i < rowCount; i++) { // Start from 1 to skip the header row
        float value = parseFloat(data[i][columnIndex]);
        if (!Float.isNaN(value)) { // Exclude NaN values
            sum += value;
            count++;
        }
    }

    // Calculate the mean value
    if (count > 0) {
        return sum / count;
    } else {
        return 0; // Return 0 if no valid values found
    }
}

    void setRowName(int row, String what) {
        data[row][0] = what;
    }

    void setString(int rowIndex, int column, String what) {
        data[rowIndex][column] = what;
    }

    void setString(String rowName, int column, String what) {
        int rowIndex = getRowIndex(rowName);
        data[rowIndex][column] = what;
    }

    void setInt(int rowIndex, int column, int what) {
        data[rowIndex][column] = str(what);
    }

    void setInt(String rowName, int column, int what) {
        int rowIndex = getRowIndex(rowName);
        data[rowIndex][column] = str(what);
    }

    void setFloat(int rowIndex, int column, float what) {
        data[rowIndex][column] = str(what);
    }

    void setFloat(String rowName, int column, float what) {
        int rowIndex = getRowIndex(rowName);
        data[rowIndex][column] = str(what);
    }

    // Write this table as a TSV file
    void write(PrintWriter writer) {
        for (int i = 0; i < rowCount; i++) {
            for (int j = 0; j < data[i].length; j++) {
                if (j != 0) {
                    writer.print(TAB);
                }
                if (data[i][j] != null) {
                    writer.print(data[i][j]);
                }
            }
            writer.println();
        }
        writer.flush();
    }
}
