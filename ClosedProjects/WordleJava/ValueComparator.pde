//Used to sort the HashMap of words
//http://stackoverflow.com/questions/109383/sort-a-mapkey-value-by-values-java

public class ValueComparator implements java.util.Comparator<String> {
 
    java.util.Map<String, Integer> map;
 
    public ValueComparator(java.util.Map<String, Integer> base) {
        this.map = base;
    }
 
    public int compare(String a, String b) {
        if (map.get(a) >= map.get(b)) {
            return -1;
        } else {
            return 1;
        } // returning 0 would merge keys 
    }
}