// fileio.c - open/read/write/creat/close 檔案複製 (_vm 檔案 I/O 指令測試)
// args: build/fileio-src.txt build/fileio-out.txt
// expect: copied 7000 bytes
int main(int argc, char **argv)
{
  int fi; int fo; char *buf; int n; int total;

  if (argc < 3) { printf("usage: fileio src dst\n"); return 1; }

  fi = open(argv[1], 0);
  if (fi < 0) { printf("open failed: %s\n", argv[1]); return 2; }

  fo = creat(argv[2], 438);
  if (fo < 0) { printf("creat failed: %s\n", argv[2]); return 3; }

  buf = malloc(4096);
  total = 0;
  n = read(fi, buf, 4096);
  while (n > 0) {
    write(fo, buf, n);
    total = total + n;
    n = read(fi, buf, 4096);
  }
  close(fi);
  close(fo);
  free(buf);

  printf("copied %d bytes\n", total);
  return 0;
}
