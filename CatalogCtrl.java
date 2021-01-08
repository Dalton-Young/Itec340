/**
 * CatalogCtrl.java
 *Logic Controller
 */
import java.sql.*;
import java.util.*;

class CatalogCtrl {

  private DataSource data;

  public CatalogCtrl() throws SQLException {
    try {
      data = new DataSource();
    } catch (SQLException e) {
      System.out.println("Could not Do stuff" + e);
    }
  }

  /**
   * help() -- Displays List of valid commands
   *
   * EX:help
   */
  public String help() {
    return (
      "help –	display a list of commands available to the user. Only list commands that have been implemented. \n" +
      "quit – quit the application.\n" +
      "cua – create user account\n" +
      "cua bob smith bsmith@gmail.com\n" +
      "gui – get user ID\n" +
      "gui bsmith@gmail.com\n" +
      "atc – add to catalog\n" +
      "atc 5021 123\n" +
      "rfc – remove from catalog\n" +
      "rfc 5021 123\n" +
      "rrb – rate and review book\n" +
      "rrb 5021 123 3 Great book \n" +
      "ubs – update book status \n" +
      "ubs 5021 123 Want to Read \n" +
      "aaf – add a friend\n" +
      "aaf 123 125\n" +
      "gbi - Get Book Information takes one option: -title, -author, or -id.\n" +
      "gbi  -title Clear and Present Danger\n" +
      "gbi  -author Tom Clancy\n" +
      "gbi  -id 5021"
    );
  }

  /**
   * quit() -- quits the application
   *
   * EX:quit
   */
  public void quit() throws SQLException {
    try {
      data.close();
      System.exit(0);
    } catch (SQLException e) {
      System.out.println("Could not Close: " + e);
    }
  }

  /**
   * cua(String user_info) --Adds a user accout to the database
   *
   * @param  user_info - User information First Name, Last Name, Email
   * EX:cua bob smith bsmith@gmail.com
   */
  public void cua(ArrayList<String> args) throws SQLException {
    try {
      data.create_Account(args);
    } catch (SQLException e) {
      System.out.println("Could not Create Account: " + e);
    }
  }

  /**
   * gui(String user_email) --Retrives Users ID by email
   *
   * @param  user_email - User email
   * EX:gui bsmith@gmail.com
   */
  public Integer gui(ArrayList<String> args) throws SQLException {
    Integer wow = -1;
    try {
      wow = data.find_user(args);
    } catch (SQLException e) {
      System.out.println("Could not Get User ID: " + e);
    }
    return wow;
  }

  /**
   * atc(String User_ID, String Book_ISBN) --Adds to users catalog
   *
   * @param  User_ID - User ID
   * @param  Book_ISBN - Book ISBN
   * EX:atc 5021 123
   */
  public void atc(ArrayList<String> args) throws SQLException {
    try {
      data.add_to_catalog(args);
    } catch (SQLException e) {
      System.out.println("Could not Add to Catalog: " + e);
    }
  }

  /**
   * rfc(String User_ID, String Book_ISBN) --Remove a Book from a users catalog
   *
   * @param  User_ID - User ID
   * @param  Book_ISBN - Book ISBN
   * EX:rfc 5021 123
   */
  public void rfc(ArrayList<String> args) throws SQLException {
    try {
      data.remove_from_catalog(args);
    } catch (SQLException e) {
      System.out.println("Could not remove from Catalog: " + e);
    }
  }

  /**
   * rrb(String User_ID, String Book_ISBN, Int Rating, String Desc) --Adds a review for a book.
   *
   * @param  User_ID - User ID
   * @param  Book_ISBN - Book ISBN
   * @param  Rating - Rating Number
   * @param  Desc - Rating Description
   * EX:rrb 5021 123 3 “Great book”
   */
  public void rrb(ArrayList<String> args) throws SQLException {
    try {
      data.rate_book(args);
    } catch (SQLException e) {
      System.out.println("Could not rate Book: " + e);
    }
  }

  /**
   * ubs(String User_ID, String Book_ISBN, String Status) --Updates a Books Status
   *
   * @param  User_ID - User ID
   * @param  Book_ISBN - Book ISBN
   * @param  Status - String of Status
   * EX:ubs 5021 123 “Want to Read”
   */
  public void ubs(ArrayList<String> args) throws SQLException {
    try {
      data.update_status(args);
    } catch (SQLException e) {
      System.out.println("Could not Update Status: " + e);
    }
  }

  /**
   * aaf(String User_ID, String Friend_ID) --Adds a friend
   *
   * @param  User_ID - User ID
   * @param  Friend_ID - Friends User ID
   * EX:aaf 123 125
   */
  public void aaf(ArrayList<String> args) throws SQLException {
    try {
      data.add_friend(args);
    } catch (SQLException e) {
      System.out.println("Could not add friend: " + e);
    }
  }

  /**
   * gbi(String User_ID, String Friend_ID) --Adds a friend
   *
   * @param  User_ID - User ID
   * @param  Friend_ID - Friends User ID
   * EX:aaf 123 125
   */
  public void gbi(ArrayList<String> args) throws SQLException {
    try {
      System.out.println(data.getBookInfo(args));
    } catch (SQLException e) {
      System.out.println("Could not get book information: " + e);
    }
  }
}
/*

Get Book Information (gbi) takes one option: -title, -author, or -id.  
gbi  -title “Clear and Present Danger” 
gbi  -author “Tom Clancy” 
gbi  -id 5021 

*/
