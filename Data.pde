class Data {

  String tableName;
  Table table;

  Data(String tableName_) {

    tableName = tableName_;
  }

  Table readData() {

    try {  
      table = loadTable("cars.tsv", "header, tsv");
    } 
    catch(Exception e) {
    }

    return table;
  }

  int getNumRows() {
    return table.getRowCount();
  }

  float getMaxValue(String column) {

    float maxValue = 0.0;

    if (table != null) {
      for (TableRow row : table.rows()) {
        maxValue = max(maxValue, row.getFloat(column));
      }
    }

    return maxValue;
  }

  float getMinValue(String column) {

    float minValue = MAX_FLOAT;

    if (table != null) {
      for (TableRow row : table.rows()) {
        minValue = min(minValue, row.getFloat(column));
      }
    }

    return minValue;
  }
}