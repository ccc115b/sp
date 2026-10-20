package jack;

public final class Sys {
    private Sys() {}
    public static void halt() { Output.flush(); System.exit(0); }
    public static void error(int code) {
        Output.flush();
        System.err.println("ERR" + code);
        System.exit(1);
    }
    public static void wait(int ms) {
        try { Thread.sleep(ms); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
    }
}
