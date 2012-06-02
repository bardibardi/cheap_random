module CheapTest

  def self.cheap_perm_check!(perm, s)
    return nil if length > 256
    CheapRandom::permute perm, s, 0, length
    CheapRandom::unpermute perm, s, 0, length
  end
 
  def self.random_string(len)
    s = ' ' * len
    (0...len).each do |x|
      s.setbyte x, rand(256)
    end
    s
  end
 
  def self.identity_perm
    s = ' ' * 256
    (0..255).each do |x|
      s.setbyte x, x
    end
    s
  end

  def self.random_perm
    s = identity_perm
    i = 256
    (0..255).each do |x|
      temp = s.getbyte x
      y = x + rand(i)
      s.setbyte x, s.getbyte(y)
      s.setbyte y, temp
      i -= 1
    end
    s
  end
  
  def self.play
    s = random_string(rand(10000))
    x = s + 'X'
    ip = random_perm
    CheapRandom::cheap_random3!(true, ip, s)
    CheapRandom::cheap_random3!(false, ip, s)
    s == x[0...(s.length)]
  end
  
end #CheapTest

