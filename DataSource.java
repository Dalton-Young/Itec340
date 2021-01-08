/**
 * DataSource.java
 *Database Interface
 */

import java.sql.*;
import java.util.*;

class DataSource {

  private Connection conn;

  public DataSource() throws SQLException {
    try {
      create_connection();
    } catch (SQLException e) {
      System.out.println("Could not Connect to the db" + e);
    }
  }

  /**
   * create_connection() -- Creates Connection to Database
   *
   */
  private void create_connection() throws SQLException {
    DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
    String user, pass;
    user = "dyoung54";
    pass = "Prohunter900852578";
    try {
      conn =
        DriverManager.getConnection(
          "jdbc:oracle:thin:@Worf.radford.edu:1521:itec3",
          user,
          pass
        );
    } catch (SQLException e) {
      System.out.println("Could not Connect to the db" + e);
    }
  }

  /**
   * exe_query(String query) -- Executes query on the database
   *
   * @param  query - Query to be executed on database
   */
  private ResultSet exe_query(String query) throws SQLException {
    ResultSet rset = null;
    try {
      Statement stmt = conn.createStatement();
      rset = stmt.executeQuery(query);
    } catch (SQLException e) {
      System.out.println("Could not execute query: " + e);
    }
    return rset;
  }

  public void create_Account(ArrayList<String> query) throws SQLException {
    try {
      CallableStatement stmt = conn.prepareCall(
        "{call Create_Account(?, ?, ?, ?)}"
      );
      stmt.setString(1, query.get(1));
      stmt.setString(2, query.get(2));
      stmt.setString(3, query.get(3));
      stmt.setString(4, "A");
      stmt.execute();
    } catch (SQLException e) {
      System.out.println("Could not Create Account: " + e);
    }
  }

  public Integer find_user(ArrayList<String> query) throws SQLException {
    Integer result = -1;
    try {
      CallableStatement stmt = conn.prepareCall("{? = call find_user(?)}");
      stmt.registerOutParameter(1, Types.INTEGER);
      stmt.setString(2, query.get(1));
      stmt.executeUpdate();
      result = stmt.getInt(1);
      return result;
    } catch (SQLException e) {
      System.out.println("Could not Find User: " + e);
    }
    return result;
  }

  public void add_to_catalog(ArrayList<String> query) throws SQLException {
    try {
      CallableStatement stmt = conn.prepareCall("{call add_to_catalog(?,?,?)}");
      stmt.setInt(1, Integer.parseInt(query.get(1)));
      stmt.setInt(2, Integer.parseInt(query.get(2)));
      stmt.setString(3, "Message: ");
      stmt.execute();
    } catch (SQLException e) {
      System.out.println("Could not Add to catalog: " + e);
    }
  }

  public void remove_from_catalog(ArrayList<String> query) throws SQLException {
    try {
      CallableStatement stmt = conn.prepareCall(
        "{call remove_from_catalog(?,?,?)}"
      );
      stmt.setInt(1, Integer.parseInt(query.get(1)));
      stmt.setInt(2, Integer.parseInt(query.get(2)));
      stmt.setString(3, "Message: ");
      stmt.execute();
    } catch (SQLException e) {
      System.out.println("Could not Remove from catalog: " + e);
    }
  }

  public void rate_book(ArrayList<String> query) throws SQLException {
    try {
      CallableStatement stmt = conn.prepareCall("{call rate_book(?,?,?,?,?)}");
      stmt.setInt(1, Integer.parseInt(query.get(1)));
      stmt.setInt(2, Integer.parseInt(query.get(2)));
      stmt.setInt(3, Integer.parseInt(query.get(3)));
      stmt.setString(4, query.get(4));
      stmt.setString(5, "Message: ");
      stmt.execute();
    } catch (SQLException e) {
      System.out.println("Could not Remove from catalog: " + e);
    }
  }

  public void update_status(ArrayList<String> query) throws SQLException {
    try {
      CallableStatement stmt = conn.prepareCall(
        "{call update_status(?,?,?,?)}"
      );
      stmt.setInt(1, Integer.parseInt(query.get(1)));
      stmt.setInt(2, Integer.parseInt(query.get(2)));
      stmt.setString(3, query.get(3));
      stmt.setString(4, "Message: ");
      stmt.execute();
    } catch (SQLException e) {
      System.out.println("Could not Update Status: " + e);
    }
  }

  public void add_friend(ArrayList<String> query) throws SQLException {
    boolean result = false;
    try {
      CallableStatement stmt = conn.prepareCall(
        "BEGIN" +
        " ? := CASE WHEN (add_friend(?,?)) " +
        "       THEN 1 " +
        "       ELSE 0" +
        "      END;" +
        "END;"
      );
      //System.out.println("start bool");
      stmt.registerOutParameter(1, Types.INTEGER);
      //System.out.println("Bool done");
      stmt.setInt(2, Integer.parseInt(query.get(1)));
      //System.out.println("First Done");
      stmt.setInt(3, Integer.parseInt(query.get(2)));
      //System.out.println("Second Done");
      stmt.execute();
      //System.out.println("Done");
      //System.out.println(stmt.getBoolean(1));
      //stmt.getInt(1);

      //return result;
    } catch (SQLException e) {
      System.out.println("Could not Add Friend: " + e);
    }
    //return result;
  }

  public String getBookInfo(ArrayList<String> query) throws SQLException {
    ResultSet rs = null;
    Statement stmt = null;
    String bookInfo = "";
    String searchID;
    String searchBY = query.get(2);
    if (query.get(1).equals("-id")) {
      searchID = "-ISBN";
    } else if (query.get(1).equals("-author")) {
      searchID = "-primary_author";
    } else {
      searchID = query.get(1);
    }

    String sqlquery =
      "select ISBN, title	, edition, pub_year, description, link, num_pages, primary_author from Books where " +
      searchID.substring(1, searchID.length()) +
      " = '" +
      searchBY +
      "'";
    //System.out.println(sqlquery);

    try {
      stmt = conn.createStatement();
      rs = stmt.executeQuery(sqlquery);
      while (rs.next()) {
        bookInfo = bookInfo + "ISBN: " + rs.getString("ISBN") + "\n";
        //System.out.println(rs.getString("ISBN"));
        bookInfo = bookInfo + "Title: " + rs.getString("title") + "\n";
        bookInfo = bookInfo + "Edition: " + rs.getString("edition") + "\n";
        bookInfo =
          bookInfo + "Publication Year: " + rs.getString("pub_year") + "\n";
        bookInfo =
          bookInfo + "Description: " + rs.getString("description") + "\n";
        bookInfo = bookInfo + "Link: " + rs.getString("link") + "\n";
        bookInfo = bookInfo + "Pages: " + rs.getString("num_pages") + "\n";
        bookInfo =
          bookInfo + "Author: " + rs.getString("primary_author") + "\n";
        //System.out.println(bookInfo);
      }
      return bookInfo;
    } catch (SQLException e) {
      System.out.println("Could not get book info" + e);
    }
    return bookInfo;
  }

  /**
   * close() -- closes the Database conection
   *
   */
  public void close() throws SQLException {
    try {
      conn.close();
    } catch (SQLException e) {
      System.out.println("Could not Close Connection" + e);
    }
  }
}
