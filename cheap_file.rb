module CheapFile

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

end #CheapFile

