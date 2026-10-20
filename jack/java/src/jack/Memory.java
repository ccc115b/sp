package jack;

/** 精簡版 Memory:記憶體由 JVM 管理,所以 deAlloc 什麼都不用做。 */
public final class Memory {
    private Memory() {}
    public static int[] alloc(int size) { return new int[size]; }
    public static void deAlloc(Object o) {}
}
