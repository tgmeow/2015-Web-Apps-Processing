public class SpreadsheetReader {

  public SpreadsheetReader() {
  }

  public ArrayList<ArrayList<String>> getFileAsArraylist(String name, String delimiter) {
    ArrayList<ArrayList<String>> contents = new ArrayList<ArrayList<String>>();
    try {
      BufferedReader input =  new BufferedReader(new java.io.FileReader(name));
      try {
        String line = null; //not declared within while loop
        while (( line = input.readLine()) != null) {
          contents.add(new ArrayList<String>(java.util.Arrays.asList(line.split(delimiter))));
        }
      }
      finally {
        input.close();
      }
    }
    catch (IOException ex) {
      ex.printStackTrace();
    }
    return contents;
  }
}