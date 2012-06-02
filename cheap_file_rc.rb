ENV['CR'] = 'test'

module CheapFile

  BASE_DIR = '/home/bardi/Desktop/random'
  PERM = CheapRandom.cheap_key!('secret' * 100)

end #CheapFile

