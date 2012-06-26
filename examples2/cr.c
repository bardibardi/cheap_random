/* gcc -Wall crf.c */
/* ./a.out */
#include <stdio.h>
#include <stdlib.h>

typedef unsigned char uc;
typedef uc *ucp;
typedef ucp (*cr_proc)(ucp, ucp, int);

void cr_dump(ucp s, int length) {
  int c;
  int x;
  for (x = 0; x < length; ++x) {
    c = (int)s[x];
    if (10 > c) {
      fputc(' ', stderr);
    }
    if (100 > c) {
      fputc(' ', stderr);
    }
    fprintf(stderr, " %i ", c);
  }
}

void cr_dump_line(ucp s, int length) {
  cr_dump(s, length);
  fputc(10, stderr);
}

void cr_dump_int_line(int i) {
  fprintf(stderr, "%i\n", i);
}

void cr_dump_string_line(char *s) {
  fprintf(stderr, "%s\n", s);
}

void cr_dump_buffers(ucp a, int a_len, ucp b, int b_len) {
  cr_dump_line(a, a_len);
  cr_dump_line(b, b_len);
}

int cr_has_byte_in_string(char byte, char *arg) {
  int c;
  c = -1;
  while (0 != c) {
    c = (int)*arg++;
    if ((char)c == byte) {
      return 1;
    }
  }
  return 0;
}

int cr_has_byte_in_string_array(char byte, char *argv[], int argc) {
  int x;
  for (x = 1; x < argc; ++x) {
    if (cr_has_byte_in_string(byte, argv[x])) {
      return 1;
    }
  }
  return 0;
}

ucp cr_m(int size) {
  return (ucp)malloc((size_t)size);
}

void cr_f(ucp ptr) {
  free((void *)ptr);
}

ucp cr_clone(ucp source, int length) {
  int x;
  ucp result;
  result = cr_m(length);
  for (x = 0; x < length; ++x) {
    result[x] = source[x];
  }
  return result;
}

void cr_assign(ucp target, ucp source, int length) {
  int x;
  for (x = 0; x < length; ++x) {
    target[x] = source[x];
  }
}

int cr_read(FILE *file, ucp buffer, int length) {
  int c;
  int x;
  x = 0;
  c = fgetc(file);
  while (x < length && c != EOF) {
    buffer[x] = (uc)c;
    ++x;
    if (x < length) {
      c = fgetc(file);
    }
  }
  return x;
}

void cr_write(FILE *file, ucp buffer, int length) {
  int c;
  int x;
  for (x = 0; x < length; ++x) {
    c = (int)buffer[x];
    fputc(c, file);
  }
}

void cr_to_file(char *file_name, ucp buf, int length) {
  FILE *file;
  file = fopen(file_name, "wb");
  cr_write(file, buf, length);
  fclose(file);
}

void cr_256fill(ucp buf, int c) {
  int x;
  for (x = 0; x < 256; ++x) {
    buf[x] = (uc)c;
  }
}

void cr_256shift(ucp buf, int shift) {
  int x;
  for (x = 0; x < 256 - shift; ++x) {
    buf[255 - x] = buf[255 - x - shift];
  }
}

void cr_move(ucp source_buf, int source_offset, ucp target_buf, int length) {
  int x;
  for (x = 0; x < length; ++x) {
    target_buf[x] = source_buf[x + source_offset];
    source_buf[x + source_offset] = (uc)0;
  }
}

ucp cr_subperm(ucp perm, int length) {
  ucp result;
  int idx;
  int x;
  result = cr_m(length);
  idx = 0;
  for (x = 0; x < 256; ++x) {
    if (perm[x] < length) {
      result[idx] = perm[x];
    }
  }
  return result;
}

void cr_permute(ucp perm, ucp buffer, int offset, int length) {
  int disp;
  uc temp;
  int y;
  int x;
  y = 0;
  for (x = 0; x < length; ++x) {
    while (perm[y] >= length) {
      ++y;
    }
    disp = offset + perm[y];
    ++y;
    temp = buffer[disp];
    buffer[disp] = buffer[offset + x];
    buffer[offset + x] = temp;
  }
}

void cr_unpermute(ucp perm, ucp buffer, int offset, int length) {
  int disp;
  uc temp;
  int y;
  int x;
  y = 0;
  for (x = 1; x <= length; ++x) {
    while (perm[y] >= length) {
      --y;
    }
    disp = offset + perm[y];
    --y;
    temp = buffer[disp];
    buffer[disp] = buffer[offset + length - x];
    buffer[offset + length - x] = temp;
  }
}

void cr_random_cheap_random(ucp perm, ucp nextperm, ucp buffer, int offset, int length);

void cr_unrandom_cheap_random(ucp perm, ucp nextperm, ucp translation, ucp buffer, int offset, int length);

void cr_cheap_random7(int is_randomizing, ucp perm, ucp nextperm, ucp translation, ucp buffer, int offset, int length) {
  int x;
  if (is_randomizing) {
    cr_random_cheap_random(perm, nextperm, buffer, offset, length);
  } else {
    for (x = 0; x < 256; ++x) {
      translation[perm[x]] = x;
    }
    cr_unrandom_cheap_random(perm, nextperm, translation, buffer, offset, length);
  }
}

void cr_random_cheap_random(ucp perm, ucp nextperm, ucp buffer, int offset, int length) {
  int disp;
  uc temp;
  int y;
  int x;
  temp = (uc)0;
  y = 0;
  for (x = 0; x < length; ++x) {
    disp = offset + x;
    y = buffer[disp] ^ perm[x];
    y = perm[(y + x + x + x) & 255];
    buffer[disp] = y;
    temp = nextperm[x];
    nextperm[x] = nextperm[y];
    nextperm[y] = temp;
  }
  y = 0;
  for (x = 0; x < length; ++x) {
    while (perm[y] >= length) {
      ++y;
    }
    disp = offset + perm[y];
    ++y;
    temp = buffer[disp];
    buffer[disp] = buffer[offset + x];
    buffer[offset + x] = temp;
  }
}

void cr_unrandom_cheap_random(ucp perm, ucp nextperm, ucp translation, ucp buffer, int offset, int length) {
  int disp;
  uc temp;
  int y;
  y = 255;
  int x;
  for (x = 1; x <= length; ++x) {
    while (perm[y] >= length) {
      --y;
    }
    disp = offset + perm[y];
    --y;
    temp = buffer[disp];
    buffer[disp] = buffer[offset + length - x];
    buffer[offset + length - x] = temp;
  }
  y = 0;
  for (x = 0; x < length; ++x) {
    disp = offset + x;
    y = buffer[disp];
    buffer[disp] = ((translation[y] + 768 - x - x - x) & 255) ^ perm[x];
    temp = nextperm[x];
    nextperm[x] = nextperm[y];
    nextperm[y] = temp;
  }
}

int cr_next_block_size(int size) {
  if (size > 511) {
    return 256;
  }
  if (size <= 256) {
    return size;
  }
  return size - (size >> 1);
}

ucp cr_cheap_random5exclam(int is_randomizing, ucp startperm, ucp buffer, int offset, int length) {
  ucp nextperm;
  ucp perm;
  ucp translation;
  int len;
  int off;
  int bs;
  nextperm = cr_clone(startperm, 256);
  perm = cr_m(256);
  translation = cr_m(256);
  len = length;
  off = offset;
  while (len > 0) {
    bs = cr_next_block_size(len);
    cr_assign(perm, nextperm, 256);
    cr_cheap_random7(is_randomizing, perm, nextperm, translation, buffer, off, bs);
    off += bs;
    len -= bs;
  }
  cr_f(translation);
  cr_f(perm);
  return nextperm;
}

ucp cr_cheap_random3exclam(int is_randomizing, ucp perm, ucp s, int length) {
  return cr_cheap_random5exclam(is_randomizing, perm, s, 0, length);
}

ucp cr_cheap_random_fake(ucp perm, ucp s, int length) {
  return cr_clone(perm, 256);
}

ucp cr_cheap_random_do(ucp perm, ucp s, int length) {
  return cr_cheap_random3exclam(1, perm, s, length);
}

ucp cr_cheap_random_undo(ucp perm, ucp s, int length) {
  return cr_cheap_random3exclam(0, perm, s, length);
}

int cr_last_bufs(ucp out_buf, int out_length, ucp in_buf, int in_length) {
  int length;
  int new_out_length;
  int new_in_length;
  length = out_length + in_length;
  new_in_length = length >> 1;
  new_out_length = length - new_in_length;
  cr_256shift(in_buf, out_length - new_out_length);
  cr_move(out_buf, new_out_length, in_buf, out_length - new_out_length);
  return (new_out_length << 8) + new_in_length;
}

ucp cr_write_step(FILE *file, cr_proc proc, ucp perm, ucp s, int length) {
  ucp nextperm;
  nextperm = (*proc)(perm, s, length);
  cr_write(file, s, length);
  cr_f(perm);
  return nextperm;
}

ucp cr_xlat_big(FILE *in_file, FILE *out_file, cr_proc proc, ucp seed) {
  ucp perm;
  int is_a_out_buff;
  int a_length;
  int b_length;
  int length;
  int out_length;
  int in_length;
  perm = cr_clone(seed, 256);
  ucp a_buff256;
  ucp b_buff256;
  ucp in_buff;
  ucp out_buff;
  a_length = 0;
  b_length = 0;
  length = 0;
  out_length = 0;
  in_length = 0;
  a_buff256 = cr_m(256);
  b_buff256 = cr_m(256);
  is_a_out_buff = 0;
  in_buff = a_buff256;
  out_buff = NULL;
  a_length = cr_read(in_file, in_buff, 256);
  length = a_length;
  while (256 == length) {
    if (out_buff) {
      length = is_a_out_buff ? a_length : b_length;
      perm = cr_write_step(out_file, proc, perm, out_buff, length);
    }
    if (is_a_out_buff) {
      is_a_out_buff = 0;
      in_buff = a_buff256;
      out_buff = b_buff256;
    } else {
      is_a_out_buff = 1;
      in_buff = b_buff256;
      out_buff = a_buff256;
    }
    length = cr_read(in_file, in_buff, 256);
    if (is_a_out_buff) {
      b_length = length;
    } else {
      a_length = length;
    }
  }
  out_length = is_a_out_buff ? a_length : b_length;
  in_length = is_a_out_buff ? b_length : a_length;
  if (in_length < 256) {
    if (256 == out_length) {
      length = cr_last_bufs(out_buff, out_length, in_buff, in_length);
      out_length = length >> 8;
      in_length = length & 255;
      perm = cr_write_step(out_file, proc, perm, out_buff, out_length);
    }
    perm = cr_write_step(out_file, proc, perm, in_buff, in_length);
  } else {
    perm = cr_write_step(out_file, proc, perm, out_buff, out_length);
  }
  cr_f(b_buff256);
  cr_f(a_buff256);
  return perm;
}

uc DEFAULT_SEED[] = {
0xff, 0xfe, 0xfd, 0xfc, 0xfb, 0xfa, 0xf9, 0xf8, 0xf7, 0xf6, 0xf5, 0xf4, 
0xf3, 0xf2, 0xf1, 0xf0, 0xef, 0xee, 0xed, 0xec, 0xeb, 0xea, 0xe9, 0xe8, 
0xe7, 0xe6, 0xe5, 0xe4, 0xe3, 0xe2, 0xe1, 0xe0, 0xdf, 0xde, 0xdd, 0xdc, 
0xdb, 0xda, 0xd9, 0xd8, 0xd7, 0xd6, 0xd5, 0xd4, 0xd3, 0xd2, 0xd1, 0xd0, 
0xcf, 0xce, 0xcd, 0xcc, 0xcb, 0xca, 0xc9, 0xc8, 0xc7, 0xc6, 0xc5, 0xc4, 
0xc3, 0xc2, 0xc1, 0xc0, 0xbf, 0xbe, 0xbd, 0xbc, 0xbb, 0xba, 0xb9, 0xb8, 
0xb7, 0xb6, 0xb5, 0xb4, 0xb3, 0xb2, 0xb1, 0xb0, 0xaf, 0xae, 0xad, 0xac, 
0xab, 0xaa, 0xa9, 0xa8, 0xa7, 0xa6, 0xa5, 0xa4, 0xa3, 0xa2, 0xa1, 0xa0, 
0x9f, 0x9e, 0x9d, 0x9c, 0x9b, 0x9a, 0x99, 0x98, 0x97, 0x96, 0x95, 0x94, 
0x93, 0x92, 0x91, 0x90, 0x8f, 0x8e, 0x8d, 0x8c, 0x8b, 0x8a, 0x89, 0x88, 
0x87, 0x86, 0x85, 0x84, 0x83, 0x82, 0x81, 0x80, 0x7f, 0x7e, 0x7d, 0x7c, 
0x7b, 0x7a, 0x79, 0x78, 0x77, 0x76, 0x75, 0x74, 0x73, 0x72, 0x71, 0x70, 
0x6f, 0x6e, 0x6d, 0x6c, 0x6b, 0x6a, 0x69, 0x68, 0x67, 0x66, 0x65, 0x64, 
0x63, 0x62, 0x61, 0x60, 0x5f, 0x5e, 0x5d, 0x5c, 0x5b, 0x5a, 0x59, 0x58, 
0x57, 0x56, 0x55, 0x54, 0x53, 0x52, 0x51, 0x50, 0x4f, 0x4e, 0x4d, 0x4c, 
0x4b, 0x4a, 0x49, 0x48, 0x47, 0x46, 0x45, 0x44, 0x43, 0x42, 0x41, 0x40, 
0x3f, 0x3e, 0x3d, 0x3c, 0x3b, 0x3a, 0x39, 0x38, 0x37, 0x36, 0x35, 0x34, 
0x33, 0x32, 0x31, 0x30, 0x2f, 0x2e, 0x2d, 0x2c, 0x2b, 0x2a, 0x29, 0x28, 
0x27, 0x26, 0x25, 0x24, 0x23, 0x22, 0x21, 0x20, 0x1f, 0x1e, 0x1d, 0x1c, 
0x1b, 0x1a, 0x19, 0x18, 0x17, 0x16, 0x15, 0x14, 0x13, 0x12, 0x11, 0x10, 
0x0f, 0x0e, 0x0d, 0x0c, 0x0b, 0x0a, 0x09, 0x08, 0x07, 0x06, 0x05, 0x04, 
0x03, 0x02, 0x01, 0x00
};

uc SEED[] = {
0x23, 0xbd, 0xc8, 0x8c, 0xac, 0x5b, 0xf1, 0x9f, 0x14, 0xff, 0x7b, 0x30, 
0x8a, 0xdc, 0x01, 0xcb, 0xe3, 0x79, 0x57, 0xd6, 0x36, 0xa5, 0x61, 0xbe, 
0x5d, 0x59, 0xfd, 0xf5, 0x32, 0x4e, 0x50, 0xa3, 0x43, 0x93, 0x51, 0xa1, 
0x34, 0xc3, 0xe8, 0x82, 0x19, 0x55, 0x02, 0xae, 0xdd, 0x04, 0xe7, 0x87, 
0xdf, 0x0c, 0xe4, 0xa0, 0xb3, 0x27, 0x60, 0xd2, 0xd5, 0x1e, 0x83, 0x99, 
0x0b, 0xbc, 0x7a, 0x4a, 0x4f, 0xf3, 0x18, 0x2a, 0x31, 0x48, 0x75, 0xd0, 
0xd3, 0xfb, 0xb9, 0x3f, 0x96, 0xb4, 0x20, 0x0e, 0x46, 0xb2, 0x97, 0xea, 
0xb6, 0x25, 0xa7, 0xe6, 0x29, 0xe9, 0x03, 0x2d, 0x78, 0x12, 0xf4, 0x5a, 
0xc9, 0xaf, 0xb0, 0x2f, 0x22, 0x54, 0x8e, 0xba, 0x81, 0x90, 0xaa, 0x9b, 
0xf6, 0x3d, 0xb1, 0xc0, 0x88, 0x2c, 0xef, 0xb8, 0x07, 0x2e, 0xe1, 0x94, 
0xe5, 0x33, 0x17, 0x98, 0x05, 0xa4, 0xfc, 0x1f, 0xf7, 0x9e, 0xe2, 0x66, 
0x3e, 0xeb, 0x7f, 0x47, 0x91, 0xa6, 0x9a, 0xc6, 0x76, 0x1b, 0xa2, 0x62, 
0xf9, 0x89, 0x5f, 0xb5, 0x6d, 0xcd, 0x92, 0x84, 0xc4, 0x1a, 0xbb, 0x0a, 
0x7e, 0xde, 0x67, 0x21, 0x38, 0x26, 0x8d, 0x6e, 0x44, 0x63, 0xc5, 0x4c, 
0x45, 0x6a, 0x16, 0x42, 0xf0, 0x7c, 0x2b, 0x68, 0x4b, 0x71, 0x49, 0x53, 
0xcf, 0x5e, 0x13, 0x73, 0x3a, 0xd9, 0x6f, 0x9d, 0x5c, 0xca, 0x65, 0xc2, 
0x0f, 0x09, 0x80, 0x72, 0x41, 0xab, 0xfa, 0x3c, 0xfe, 0xe0, 0x58, 0x15, 
0x8b, 0x0d, 0xee, 0x06, 0x4d, 0xa9, 0xce, 0xb7, 0x08, 0xf2, 0x7d, 0x85, 
0x52, 0x1c, 0x86, 0xc1, 0xbf, 0x28, 0x8f, 0x39, 0x11, 0x9c, 0xd8, 0x70, 
0x10, 0x77, 0x35, 0x64, 0xd7, 0x00, 0x69, 0xa8, 0xdb, 0xc7, 0xad, 0x56, 
0xf8, 0xda, 0x24, 0xd1, 0x74, 0xcc, 0xd4, 0x6c, 0x40, 0x37, 0x95, 0x1d, 
0x6b, 0x3b, 0xec, 0xed
};

ucp simple_main(cr_proc proc, ucp seed) {
  return cr_xlat_big(stdin, stdout, proc, seed);
}

int simple_make_seed_main(cr_proc proc, ucp seed) {
  ucp new_seed;
  new_seed = simple_main(proc, seed);
  cr_to_file("new.seed", new_seed, 256);
  cr_f(new_seed);
  cr_to_file("the.seed", seed, 256);
  return 0;
}

int main(int argc, char *argv[]) {
  ucp seed;
  cr_proc proc;
  proc = cr_cheap_random_do;
  seed = SEED;
  if (cr_has_byte_in_string_array('h', argv, argc)) {
    cr_dump_string_line("cr is the cheap random pipe");
    cr_dump_string_line("cr <some_file >some_file.random");
    cr_dump_string_line("cr u <some_file.random >some_file");
    cr_dump_string_line("  u => undo, unrandomize");
    cr_dump_string_line("cr s <some_file >some_file.random");
    cr_dump_string_line("cr us <some_file.random >some_file");
    cr_dump_string_line("  s => write the files: the.seed new.seed");
    cr_dump_string_line("cr ms <some_file >/dev/null");
    cr_dump_string_line("  m => use the default seed, not the installed seed");
    return 1;
  }
  if (cr_has_byte_in_string_array('u', argv, argc)) {
    proc = cr_cheap_random_undo;
  }
  if (cr_has_byte_in_string_array('m', argv, argc)) {
    seed = DEFAULT_SEED;
  }
  if (cr_has_byte_in_string_array('s', argv, argc)) {
    return simple_make_seed_main(proc, seed);
  } else {
    cr_f(simple_main(proc, seed));
    return 0;
  }
  return 1;
}

