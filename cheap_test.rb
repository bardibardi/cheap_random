module CheapTest

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
    CheapRandom::cheap_random5(true, ip, s, 0, s.length)
    CheapRandom::cheap_random5(false, ip, s, 0, s.length)
    s == x[0...(s.length)]
  end
  
end #CheapTest

