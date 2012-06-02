module CheapFile

  def self.file?(fn)
    File.file? fn
  end

  def self.from_file(fn)
    f = File.new fn
    s = f.read
    f.close
    s.force_encoding 'ASCII-8BIT'
  end
  
  def self.to_file(fn, s)
    f = File.new fn, "wb"
    f.write s
    f.close
  end
 
  def self.delete(fn)
    File.delete fn
  end

  RANDOM_EXT = '.random'

  def self.abs_fn(fn)
    BASE_DIR + '/' + fn
  end

  def self.cr(fn)
    return unless fn
    afn = abs_fn fn
    if not file?(afn)
      puts afn + ' cannot be processed.'
      return nil
    end
    is_random = afn =~ /\.random$/
    nafn = afn[0, is_random] if is_random
    nafn = afn + RANDOM_EXT unless is_random
    s = from_file afn
    is_randomizing = !is_random
    CheapRandom.cheap_random3! is_randomizing, PERM, s
    to_file nafn, s
    to_file afn, s if is_randomizing
    delete afn
  end

end #CheapFile

