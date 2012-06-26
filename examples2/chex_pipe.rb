#!/usr/bin/env ruby

def to_file(afn, s)
  f = File.new afn, 'wb'
  f.write s
  f.close
end

def to_stdout(s)
  STDOUT.write s
  STDOUT.close
end

def from_file(afn)
  f = File.new afn, 'rb'
  s = f.read
  s.force_encoding 'ASCII-8BIT'
end

def from_stdin
  STDIN.read.force_encoding 'ASCII-8BIT'
end

HEX =
{0 => '0', 1 => '1', 2 => '2', 3 => '3', 4 => '4',
 5 => '5', 6 => '6', 7 => '7', 8 => '8', 9 => '9',
 10 => 'a', 11 => 'b', 12 => 'c', 13 => 'd', 14 => 'e',
 15 => 'f'}

def to_hex(byte)
  "0x#{HEX[byte >> 4]}#{HEX[byte & 15]}"
end

def to_hex_a(s)
  a = []
  s.each_byte do |b|
    a << to_hex(b)
  end
  a
end

def c_a(a)
  a.join ", "
end

def slice(s, slice_size)
  a = []
  line_count = s.length / slice_size
  line_count += 1 if 0 < s.length % slice_size
  (0...line_count).each do |i|
    a << s[(i * slice_size)...((i + 1) * slice_size)]
  end
  a.join("\n") + "\n"
end

def chex_pipe
  x = from_stdin
  a = to_hex_a x
  s = c_a a
  to_stdout slice(s, 72)
end

chex_pipe

