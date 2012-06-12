p File.absolute_path(__FILE__)
CHEAP_DEPENDENCY_ENV_NAME = 'CD'
load File.expand_path('../lib/cheap_dependency.rb', File.dirname(__FILE__))
CheapDependency.cd_get('cheap_bits')

BASE_DIR = File.expand_path('../random', File.dirname(__FILE__))
RANDOM_FILE_SOURCE = "test.zip"
XLAT_EXT = '.random'
CB = CheapBits.new(9, BASE_DIR, RANDOM_FILE_SOURCE, XLAT_EXT)

def l
  load File.absolute_path(__FILE__)
end

if !CheapDependency.cd_test?
  p CB.get_many_random 441241, 256
end

