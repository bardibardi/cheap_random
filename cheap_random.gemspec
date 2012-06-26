Gem::Specification.new do |s|
  s.name = 'cheap_random'
  s.version = '0.9.2'
  s.date = '2012-06-12'
  s.summary = 'pseudo random number generation from arbitrary data'
  s.description = <<-EOT
    **CheapRandom** is a set of tools for pseudo random number generation from arbitrary data. The properties of the **CheapRandom seed** make convenient random number generation possible -- useful for easily repeatable software testing. The **CheapRandom algorithm** is information conserving and generally appears to produce lower chi-squared statistics than **Kernel::rand** i.e. it appears to be more random. The **CheapRandom algorithm**, an original work by Bardi Einarsson, has been in use for 6 years.
  EOT

  s.authors = ['Bardi Einarsson']
  s.email = ['bardi_e@hotmail.com']
  s.homepage = 'https://github.com/bardibardi/cheap_random'
  s.required_ruby_version = '>= 1.9.2'
  s.add_development_dependency('rspec', '~> 2.2')
  s.files = %w(
cheap_random.gemspec
.gitignore
LICENSE.md
README.md
examples/cb.rb
examples/chi_squared.rb
examples/cr.rb
examples/make_seed.rb
examples2/chex_pipe.rb
examples2/cr.c
examples2/crf.rb
examples2/crx
examples2/crxs
examples2/make_seed
examples2/pet_cat.png
examples2/rpb.c
examples2/the.seed
lib/cheap_big_file.rb
lib/cheap_bits.rb
lib/cheap_byte_count.rb
lib/cheap_dependency.rb
lib/cheap_file.rb
lib/cheap_random.rb
lib/cheap_random/version.rb
lib/cheap_test.rb
spec/cheap_big_file_spec.rb
spec/cheap_bits_spec.rb
spec/cheap_random_spec.rb
spec/using_cheap_bits_cheap_random_spec.rb
)
end

