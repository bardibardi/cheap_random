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
 
  def self.is_do_afn_new_afn(base_dir, fn, xlat_ext)
    afn = "#{base_dir}/#{fn}"
    xlat_match = afn =~ Regexp.new("\\#{xlat_ext}$")
    new_afn = afn[0, xlat_match] if xlat_match
    new_afn = afn + xlat_ext unless xlat_match
    [!xlat_match, afn, new_afn]
  end

  def initialize(base_dir, xlat_ext, seed, xlat_lambda)
    @base_dir = base_dir
    @xlat_ext = xlat_ext
    @seed = seed
    @xlat = xlat_lambda
  end

  def in_memory_in_place_xlat(fn)
    is_do, afn, new_afn = self.class.is_do_afn_new_afn @base_dir, fn, @xlat_ext
    s = self.class.from_file afn
    @xlat.call is_do, @seed, s
    self.class.to_file new_afn, s
    self.class.to_file afn, s if is_do
  end

end #CheapFile

