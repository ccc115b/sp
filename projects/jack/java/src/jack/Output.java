package jack;

import java.io.*;

/** Jack 的 Output 類別,輸出到 stdout(只有文字,沒有螢幕座標)。 */
public final class Output {
    private Output() {}
    private static final PrintStream out =
        new PrintStream(new BufferedOutputStream(new FileOutputStream(FileDescriptor.out), 1 << 16), false);
    static {
        Runtime.getRuntime().addShutdownHook(new Thread(out::flush));
    }
    static void flush() { out.flush(); }

    public static void printString(JString s) { out.print(s.toString()); }
    public static void printInt(int i) { out.print(i); }
    public static void println() { out.println(); }
    public static void printChar(int c) { out.print((char) c); }
    public static void backSpace() { out.print('\b'); }
}
