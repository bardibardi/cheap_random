ENV['CR'] = 'test'

module CheapFileRc

  BASE_DIR = '/home/bardi/Desktop/random'
  PERM = CheapRandom.cheap_key!('secret' * 100)
  XLAT = lambda {|is_do, s| CheapRandom.cheap_random3! is_do, PERM, s}
  XLAT_EXT = '.random'
  CR = lambda do |fn|
    CheapFile.new(BASE_DIR, XLAT_EXT, XLAT).in_memory_in_place_xlat fn
  end

end #CheapFileRc

