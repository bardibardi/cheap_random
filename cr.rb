load 'cheap_random.rb'
load 'cheap_file_rc.rb'
load 'cheap_file.rb'

if 'test' == ENV['CR']
  load 'cheap_test.rb'
else
  CheapFile.cr ARGV[1]
end

