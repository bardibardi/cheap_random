p File.absolute_path(__FILE__)
CHEAP_DEPENDENCY_ENV_NAME = 'CD'
load File.expand_path('../lib/cheap_dependency.rb', File.dirname(__FILE__))
CheapDependency.cd_get('cheap_byte_count')

BASE_DIR = File.expand_path('../random', File.dirname(__FILE__))
XLAT_EXT = '.random'

def byte_count_array(file_name)
  afn = "#{BASE_DIR}/#{file_name}#{XLAT_EXT}"
  CheapByteCount.byte_count_array_from_file afn
end

def chi(a)
  d = a.length
  n = a.reduce(:+)
  p n
  e = (n*1.0)/d
  p e
  c = a.reduce(0) {|acc, r| acc + (r - e)*(r - e)/e}
  [d - 1, c]
end

def rand_array(a)
  d = a.length
  n = a.reduce(:+)
  rand_a = []
  d.times {rand_a << 0}
  n.times {i = rand(d); rand_a[i] += 1}
  rand_a 
end

def chi_of_bytes(file_name)
  bca = byte_count_array file_name
  chi bca
end

def l
  load File.absolute_path(__FILE__)
end

if !CheapDependency.cd_test?
  file_name = ARGV[0]
  bca = byte_count_array file_name
  p chi(bca)
  p chi(rand_array(bca))
end

