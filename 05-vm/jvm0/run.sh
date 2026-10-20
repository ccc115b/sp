cargo build --release
javac examples/Demo.java
./target/release/jvm0 examples/Demo.class      # 加 -t 可追蹤每個 opcode

diff <(java -cp examples Demo) <(./target/release/jvm0 examples/Demo.class) && echo "一致"