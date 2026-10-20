# ./build.sh                                  # 建出 jackc.jar
java -jar jackc.jar --run ../examples/oop      # 編譯並直接執行 Main.main()
java -jar jackc.jar -d out ../examples/oop     # 只輸出 .class
java -cp out:jackc.jar Main                 # 交給 java 執行