/**
 * TextIO.java
 * Interface
 *
 */
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.regex.*;
import java.lang.*;
import java.util.Scanner;

public class TextIO {
  private CatalogCtrl catalog_Ctrl;

  public TextIO()throws SQLException {
   catalog_Ctrl = new CatalogCtrl();
  }


  public void run_catalog() throws SQLException {
    try {
      display("Catalog System Running");
    Scanner scan = new Scanner(System.in);
    String input = "";
    ArrayList<String> args = null;
    if(scan.hasNext()){
    input = scan.nextLine();
    args = listifyInput(input);
    }
      int status = 1;

      while (status == 1) {
        String command = args.get(0) != null ? args.get(0) : "";
        switch (command) {
          case "help":
            display(catalog_Ctrl.help());
            display("Successful");
            break;
          case "quit":
            catalog_Ctrl.quit();
            break;
          case "cua":
            catalog_Ctrl.cua(args);
            display("Successful");
            break;
          case "gui":
            display(catalog_Ctrl.gui(args).toString());
            display("Successful");
            break;
          case "atc":
            catalog_Ctrl.atc(args);
            display("Successful");
            break;
          case "rfc":
            catalog_Ctrl.rfc(args);
            display("Successful");
            break;
          case "rrb":
            catalog_Ctrl.rrb(args);
            display("Successful");
            break;
          case "ubs":
            catalog_Ctrl.ubs(args);
            display("Successful");
            break;
          case "aaf":
            catalog_Ctrl.aaf(args);
            display("Successful");
            break;
          case "gbi":
            catalog_Ctrl.gbi(args);
            display("Successful");
            break;
          default:
            display("Invalid command: " + command);
        }
        try{
          Thread.sleep(2000);
        }
        catch(Exception e) {
          System.out.println(e);
       }
       input = scan.nextLine();
       args = listifyInput(input);
      }
    }catch (SQLException e) {
      System.out.println("Error" + e);
    }}
  


  /**
   * display() -- displays the given string to the screen.
   *
   * @param  msg - string to be displayed.
   */
  private void display(String msg) {
    System.out.println(msg);
  }

  /**
   * listifyInput() -- Make input into list
   *
   * @param  input - String to be listified.
   * @return args - list of args
   */
  private ArrayList<String> listifyInput(String input) {
    ArrayList<String> args = new ArrayList<String>();
    Pattern regex = Pattern.compile("[^\\s\"']+|\"([^\"]*)\"|'([^']*)'");
    Matcher regexMatcher = regex.matcher(input);
    while (regexMatcher.find()){
      if (regexMatcher.group(1) != null) {
         // Add double-quoted string without the quotes
         args.add(regexMatcher.group(1));
     } else if (regexMatcher.group(2) != null) {
         // Add single-quoted string without the quotes
         args.add(regexMatcher.group(2));
     } else {
         // Add unquoted word
         args.add(regexMatcher.group());
     }
    }
    //System.out.println(args);
      //args.add(regexMatcher.group(1)).replace("\"", "");
    return args;
  }

  
    
    
    
  
}
