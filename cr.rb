load 'cheap_random.rb'
load 'cheap_file.rb'
load 'cheap_big_file.rb'
load 'cheap_file_rc.rb'

if 'test' == ENV['CR']
  load 'cheap_test.rb'
else
  CheapFileRc::CR.call ARGV[1]
end

