package jack;

/** Jack 的 Math 類別(對應 nand2tetris OS 的 Math)。 */
public final class Math {
    private Math() {}
    public static int multiply(int x, int y) { return x * y; }
    public static int divide(int x, int y) {
        if (y == 0) Sys.error(3);
        return x / y;
    }
    public static int min(int a, int b) { return a < b ? a : b; }
    public static int max(int a, int b) { return a > b ? a : b; }
    public static int abs(int x) { return x < 0 ? -x : x; }
    public static int sqrt(int x) {
        if (x < 0) Sys.error(4);
        return (int) java.lang.Math.sqrt(x);
    }
}
