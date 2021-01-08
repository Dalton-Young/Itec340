/**
 * CatalogDriver.java
 *
 *
 */

import java.sql.*;
import java.util.Scanner;

class CatalogDriver {

  private static TextIO text_io;
  private static CatalogCtrl catlog_ctrl;
  private static DataSource data;

  public static void main(String[] args) throws SQLException {
    try {
      text_io = new TextIO();
      catlog_ctrl = new CatalogCtrl();
      data = new DataSource();
      text_io.run_catalog();
    } catch (SQLException e) {
      System.out.println("Error: " + e);
    }
  }
}
