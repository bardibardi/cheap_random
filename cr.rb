load 'cheap_random.rb'
load 'cheap_random_rc.rb'
load 'cheap_test.rb' if 'test' == ENV['CR']

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
  s = CheapRandom.from_file afn
  is_randomizing = !is_random
  CheapRandom.cheap_random3! is_randomizing, PERM, s
  CheapRandom.to_file nafn, s
  CheapRandom.to_file afn, s if is_randomizing
  File.delete afn
end

cr ARGV[1] unless 'test' == ENV['CR']

