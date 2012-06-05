CHEAP_DEPENDENCY_ENV_NAME = 'CR'
load File.expand_path('../lib/cheap_dependency.rb', File.dirname(__FILE__))
CheapDependency.cd_get(
  'cheap_random',
  'cheap_file',
  'cheap_big_file'
)
load File.expand_path('cheap_file_rc.rb', File.dirname(__FILE__))

if CheapDependency.cd_should_load?
  CheapDependency.cd_get 'cheap_test'
else
  CheapFileRc::CR.call ARGV[0]
end

