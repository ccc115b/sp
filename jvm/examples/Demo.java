public class Demo {
    static int fib(int n) {
        return n < 2 ? n : fib(n - 1) + fib(n - 2);
    }

    static int gcd(int a, int b) {
        while (b != 0) {
            int t = a % b;
            a = b;
            b = t;
        }
        return a;
    }

    static boolean isPrime(int n) {
        if (n < 2) return false;
        for (int i = 2; i * i <= n; i++) {
            if (n % i == 0) return false;
        }
        return true;
    }

    public static void main(String[] args) {
        System.out.println("Hello from jvm0!");

        System.out.print("fib(0..15):");
        for (int i = 0; i <= 15; i++) {
            System.out.print(' ');
            System.out.print(fib(i));
        }
        System.out.println();

        System.out.println(gcd(1071, 462));          // 21
        System.out.println(isPrime(97));             // true

        // 埃拉托斯特尼篩法（使用 int[]）
        int[] sieve = new int[50];
        for (int i = 2; i < 50; i++) sieve[i] = 1;
        for (int i = 2; i * i < 50; i++)
            if (sieve[i] == 1)
                for (int j = i * i; j < 50; j += i) sieve[j] = 0;
        System.out.print("primes < 50:");
        for (int i = 2; i < sieve.length; i++)
            if (sieve[i] == 1) { System.out.print(' '); System.out.print(i); }
        System.out.println();

        System.out.println(Integer.MAX_VALUE + 1 == Integer.MIN_VALUE); // 溢位：true
    }
}
