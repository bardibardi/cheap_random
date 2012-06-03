CHEAP_DEPENDENCY_ENV_NAME = 'CR'
load "#{File.dirname(__FILE__)}/cheap_dependency.rb"
CheapDependency.cd_get(
  'cheap_random',
  'cheap_file',
  'cheap_big_file',
  'cheap_file_rc'
)

if CheapDependency.cd_should_load?
  CheapDependency.cd_get 'cheap_test'
else
  CheapFileRc::CR.call ARGV[0]
end

