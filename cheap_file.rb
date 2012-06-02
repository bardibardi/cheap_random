class CheapFile

  def self.file?(afn)
    File.file? afn
  end

  def self.from_file(afn)
    f = File.new afn
    s = f.read
    f.close
    s.force_encoding 'ASCII-8BIT'
  end
  
  def self.to_file(afn, s)
    f = File.new afn, "wb"
    f.write s
    f.close
  end
 
  def self.delete(afn)
    File.delete afn
  end

  def initialize(base_dir, xlat_ext, xlat_lambda)
    @base_dir = base_dir
    @xlat_ext = xlat_ext
    @xlat = xlat_lambda
  end

  def in_memory_in_place_xlat(fn)
    afn = "#{@base_dir}/#{fn}"
    if not self.class.file?(afn)
      puts afn + ' cannot be processed.'
      return nil
    end
    xlat_match = afn =~ Regexp.new("\.#{@xlat_ext}$")
    # fishy => xlat_match + 1
    new_afn = afn[0, (xlat_match + 1)] if xlat_match
    new_afn = afn + @xlat_ext unless xlat_match
    s = self.class.from_file afn
    is_do = !xlat_match
    @xlat.call is_do, s
    self.class.to_file new_afn, s
    self.class.to_file afn, s if is_do
    self.class.delete afn
  end

end #CheapFile

