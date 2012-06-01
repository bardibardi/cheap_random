require 'cheap_random'
require 'cheap_string'

def play
  s = CheapRandom::random_string(rand(10000))
  x = s + 'X'
  ip = CheapRandom::random_perm
  CheapRandom::cheap_lock5(true, ip, s, 0, s.length)
  CheapRandom::cheap_lock5(false, ip, s, 0, s.length)
  s == x[0...(s.length)]
end

require 'cheap_random_rc'

RANDOM_EXT = '.random'

def abs_fn(fn)
  BASE_DIR + '/' + fn
end

def cr(fn)
  return unless fn
  afn = abs_fn fn
  if not File.file?(afn)
    puts afn + ' cannot be processed.'
    return nil
  end
  is_random = afn =~ /\.random$/
  nafn = afn[0, is_random] if is_random
  nafn = afn + RANDOM_EXT unless is_random
  s = String.from_file afn
  is_locking = !is_random
  s.cheap_lock2! is_locking, PERM
  s.to_file nafn
  s.to_file afn if is_locking
  File.delete afn
end

cr ARGV[1] unless 'test' == ENV['CR']

