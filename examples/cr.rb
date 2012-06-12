p File.absolute_path(__FILE__)
CHEAP_DEPENDENCY_ENV_NAME = 'CD'
load File.expand_path('../lib/cheap_dependency.rb', File.dirname(__FILE__))
CheapDependency.cd_get(
  'cheap_random',
  'cheap_file',
  'cheap_big_file'
)
if CheapDependency.cd_test?
  CheapDependency.cd_get 'cheap_test'
end

BASE_DIR = File.expand_path('../random', File.dirname(__FILE__))
# SEED = CheapRandom.cheap_seed!('secret' * 100)
# CheapFile.to_file "#{BASE_DIR}/the.seed", SEED
SEED = CheapFile.from_file "#{BASE_DIR}/the.seed"
XLAT = lambda {|is_do, perm, s| CheapRandom.cheap_random3! is_do, perm, s}
XLAT_EXT = '.random'
#    CheapFile.new(BASE_DIR, XLAT_EXT, SEED, XLAT).xlat_small_file file_name
CF = CheapBigFile.new(9, BASE_DIR, XLAT_EXT, SEED, XLAT)

def l
  load File.absolute_path(__FILE__)
end

if !CheapDependency.cd_test?
  file_name = ARGV[0]
  generated_seed = CF.xlat_big_file file_name
  seed_file_name = "#{BASE_DIR}/#{file_name}.seed"
  CheapFile.to_file seed_file_name, generated_seed
  p generated_seed.each_byte.inject([], :<<)
end

