class String
  
  def self.reverse_perm
    s = ' ' * 256
    (0..255).each do |x|
      s.setbyte(x, 255 - x)
    end
    s
  end
 
  def cheap_random2!(is_randomizing, perm)
    CheapRandom::cheap_random5(is_randomizing, perm, self, 0, length)
    nil
  end
  
  def cheap_key!
    ip = String::reverse_perm
    result = CheapRandom::cheap_random5(true, ip, self, 0, length)
    CheapRandom::cheap_random5(false, ip, self, 0, length)
    result
  end
  
  def cheap_perm_check!(perm)
    return nil if length > 256
    CheapRandom::permute perm, self, 0, length
    CheapRandom::unpermute perm, self, 0, length
  end
  
  def self.from_file(fn)
    f = File.new fn
    s = f.read
    f.close
    s.force_encoding 'ASCII-8BIT'
  end
  
  def to_file(fn)
    f = File.new fn, "wb"
    f.write self
    f.close
  end
  
end # String

