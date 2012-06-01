load 'cheap_random.rb'
load 'cheap_string.rb'
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
  s = String.from_file afn
  is_randoming = !is_random
  s.cheap_random2! is_randoming, PERM
  s.to_file nafn
  s.to_file afn if is_randoming
  File.delete afn
end

cr ARGV[1] unless 'test' == ENV['CR']

