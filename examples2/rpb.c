#include <stdio.h>

void filecopy(FILE *, FILE *);

int main(int argc, char *argv[]) {
  FILE *file;
  char *program_name;
  program_name = argv[0];
  if (2 != argc) {
    fprintf(stderr, "usage: %s filename \n", program_name);
  } else {
    if (NULL == (file = fopen(argv[1], "r+b"))) {
      fprintf(stderr, "%s: can't open %s\n", program_name, argv[1]);
      return 1;
    } else {
      filecopy(stdin, file);
      fclose(file);
    }
    if (ferror(file)) {
      fprintf(stderr, "%s: error writing %s\n", program_name, argv[1]);
      return 2;
    }
  }
  return 0;
}

void filecopy(FILE *file_in, FILE *file_out) {
  int c;
  while (EOF != (c = getc(file_in))) {
    putc(c, file_out);
  }
}

