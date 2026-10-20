set -x
python3 -c '
f1 = open("c4_rs1.bc", "rb").read()
f2 = open("c4_rs2.bc", "rb").read()

print("File lengths: rs1=%d, rs2=%d" % (len(f1), len(f2)))

for i in range(min(len(f1), len(f2))):
    if f1[i] != f2[i]:
        print("First diff at byte offset %d:" % i)
        print("  rs1 byte: %02x" % f1[i])
        print("  rs2 byte: %02x" % f2[i])
        import struct
        w1 = struct.unpack("<q", f1[16:24])[0]
        d1 = struct.unpack("<q", f1[24:32])[0]
        r1 = struct.unpack("<q", f1[32:40])[0]
        text_end = 48 + w1*8
        data_end = text_end + d1
        rel_end  = data_end + r1*8
        line_end = rel_end + w1*8
        print("Section boundaries: Text[48..%d], Data[%d..%d], Rel[%d..%d], Line[%d..%d], Src[%d..%d]" % (text_end, text_end, data_end, data_end, rel_end, rel_end, line_end, line_end, len(f1)))
        if i < text_end:
            print("=> 差異在 Text 代碼段！")
        elif i < data_end:
            print("=> 差異在 Data 資料段！")
        elif i < rel_end:
            print("=> 差異在 Relocation 重定位段！")
        elif i < line_end:
            print("=> 差異在 Line Info 行號資訊段！")
        else:
            print("=> 差異在 Source Code 原始碼文字段！")
        break
'