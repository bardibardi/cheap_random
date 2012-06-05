module CheapDependency

  def self.cd_should_load?
    'test' == ENV[CHEAP_DEPENDENCY_ENV_NAME]
  end

  def self.cd_should_load(load)
    ENV[CHEAP_DEPENDENCY_ENV_NAME] = 'test' if load
    ENV[CHEAP_DEPENDENCY_ENV_NAME] = 'no_test' unless load
  end

  def self.cd_exists_absolute_fn(relative_fn_base)
    afn = File.expand_path("#{relative_fn_base}.rb", File.dirname(__FILE__))
    [File.exists?(afn), afn]
  end

  def self.cd_require_relative(relative_fn_base)
    exists, afn = cd_exists_absolute_fn relative_fn_base
    require_relative relative_fn_base if exists
    require relative_fn_base unless exists
  end

  def self.cd_load_relative(relative_fn_base)
    exists, afn = cd_exists_absolute_fn relative_fn_base
    load afn if exists
    require relative_fn_base unless exists
  end

  def self.cd_get(*relative_fn_base_array)
    relative_fn_base_array.each do |relative_fn_base|
      if cd_should_load?
        cd_load_relative relative_fn_base
      else
        cd_require_relative relative_fn_base
      end
    end
  end

end

