cargo build --release
javac examples/Demo.java
./target/release/jvm0 examples/Demo.class      # 加 -t 可追蹤每個 opcode
./target/release/jvm0 -d examples/Demo.class   # 反組譯（javap -c 風格）

diff <(java -cp examples Demo) <(./target/release/jvm0 examples/Demo.class) && echo "一致"