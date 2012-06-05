module CheapFileRc

  BASE_DIR = '/home/bardi/Desktop/random'
  SEED = CheapRandom.cheap_seed!('secret' * 100)
# XLAT = lambda {|is_do, s| CheapRandom.cheap_random3! is_do, PERM, s}
  XLAT = lambda {|is_do, perm, s| CheapRandom.cheap_random3! is_do, perm, s}
  XLAT_EXT = '.random'
  CR = lambda do |fn|
#   CheapFile.new(BASE_DIR, XLAT_EXT, SEED, XLAT).xlat_small_file fn
    CheapBigFile.new(9, BASE_DIR, XLAT_EXT, SEED, XLAT).xlat_big_file fn
  end

end #CheapFileRc

