package jack;

/**
 * Jack 的 String 類別。Jack 的 String 是可變的,所以用 StringBuilder 實作。
 * 編譯器把 Jack 的 `String` 型別對應到這個類別。
 * 建構子 `String.new(n)` 對應到 static 方法 `$new(int)`(Jack 的 constructor 一律編成 `$名稱`)。
 */
public final class JString {
    private final StringBuilder sb;

    /** 給編譯器處理字串常數 "..." 用。 */
    public JString(String s) { sb = new StringBuilder(s); }

    public static JString $new(int maxLength) { return new JString(""); }

    public void dispose() {}
    public int length() { return sb.length(); }
    public int charAt(int j) { return sb.charAt(j); }
    public void setCharAt(int j, int c) { sb.setCharAt(j, (char) c); }
    public JString appendChar(int c) { sb.append((char) c); return this; }
    public void eraseLastChar() { if (sb.length() > 0) sb.setLength(sb.length() - 1); }

    public int intValue() {
        int i = 0, n = sb.length(), v = 0;
        boolean neg = false;
        if (n > 0 && sb.charAt(0) == '-') { neg = true; i = 1; }
        for (; i < n && Character.isDigit(sb.charAt(i)); i++) v = v * 10 + (sb.charAt(i) - '0');
        return neg ? -v : v;
    }

    public void setInt(int v) { sb.setLength(0); sb.append(v); }

    public static int backSpace() { return 8; }
    public static int doubleQuote() { return 34; }
    public static int newLine() { return 10; }

    @Override public String toString() { return sb.toString(); }
}
