module CheapRandom

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
  
  def self.reverse_perm
    s = ' ' * 256
    (0..255).each do |x|
      s.setbyte(x, 255 - x)
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
  
  def self.subperm(perm, length)
    result = ' ' * length
    idx = 0
    (0..255).each do |x|
      if perm.getbyte(x) < length
        result.setbyte idx, perm.getbyte(x)
        idx += 1
      end
    end
    result
  end
  
  def self.permute(perm, buffer, offset, length)
    disp = 0
    temp = 0
    y = 0
    (0...length).each do |x| 
      while perm.getbyte(y) >= length do
        y += 1
      end
      disp = offset + perm.getbyte(y)
      y += 1
      temp = buffer.getbyte disp
      buffer.setbyte disp, buffer.getbyte(offset + x)
      buffer.setbyte(offset + x, temp)
    end
    nil
  end
  
  def self.unpermute(perm, buffer, offset, length)
    disp = 0
    temp = 0
    y = 255
    (1..length).each do |x| 
      while perm.getbyte(y) >= length do
        y -= 1
      end
      disp = offset + perm.getbyte(y)
      y -= 1
      temp = buffer.getbyte disp
      buffer.setbyte disp, buffer.getbyte(offset + length - x)
      buffer.setbyte(offset + length - x, temp)
    end
    nil
  end
  
  # is_locking is a boolean
  # cheap_lock with is_locking true
  # is decrypted with is_locking false
  # perm is a read only string of length 256 with each
  # char represented once
  # perm is cheap_locks key
  # nextperm writeable string of length 256
  # comes in as a copy of perm
  # it is the next key for use in a chain cypher
  # translation is a buffer needed for perm reversed as a substitution cipher
  # buffer is read as cleartext
  # and written as ciphertext
  # offset is a pointer into the buffer
  # length is from 1 to 256
  # it is the number of chars to process
  # starting at offset in buffer
  def self.cheap_lock7(is_locking, perm, nextperm, translation, buffer, offset, length)
    if is_locking then
      lock_cheap_lock(perm, nextperm, buffer, offset, length)
    else
      (0..255).each do |x|
        translation.setbyte perm.getbyte(x), x
      end
      unlock_cheap_lock(perm, nextperm, translation, buffer, offset, length)
    end
    return nil
  end
  
  def self.lock_cheap_lock(perm, nextperm, buffer, offset, length)
    disp = 0
    temp = 0
    y = 0
    (0...length).each do |x| 
      disp = offset + x
      y = buffer.getbyte(disp) ^ perm.getbyte(x)
      y = perm.getbyte((y + x + x + x) & 255)
      buffer.setbyte disp, y
      temp = nextperm.getbyte x
      nextperm.setbyte x, nextperm.getbyte(y)
      nextperm.setbyte y, temp
    end
    y = 0
    (0...length).each do |x| 
      while perm.getbyte(y) >= length do
        y += 1
      end
      disp = offset + perm.getbyte(y)
      y += 1
      temp = buffer.getbyte disp
      buffer.setbyte disp, buffer.getbyte(offset + x)
      buffer.setbyte(offset + x, temp)
    end
    nil
  end
  
  def self.unlock_cheap_lock(perm, nextperm, translation, buffer, offset, length)
    disp = 0
    temp = 0
    y = 255
    (1..length).each do |x| 
      while perm.getbyte(y) >= length do
        y -= 1
      end
      disp = offset + perm.getbyte(y)
      y -= 1
      temp = buffer.getbyte disp
      buffer.setbyte disp, buffer.getbyte(offset + length - x)
      buffer.setbyte(offset + length - x, temp)
    end
    y = 0
    (0...length).each do |x| 
      disp = offset + x
      y = buffer.getbyte disp
      buffer.setbyte(disp, ((translation.getbyte(y) + 768 - x - x - x) & 255) ^ perm.getbyte(x))
      temp = nextperm.getbyte(x)
      nextperm.setbyte x, nextperm.getbyte(y)
      nextperm.setbyte y, temp
    end
    nil
  end
  
  def self.next_block_size(size)
    return 256 if size > 511
    return size if size <= 256
    size - (size >> 1)
  end
  
  # length > 0
  def self.cheap_lock5(is_locking, startperm, buffer, offset, length)
    nextperm = startperm + 'NEXT'
    perm = (' ' * 256) + 'PERM'
    translation = (' ' * 256) + 'TRAN'
    len = length
    off = offset
    while len > 0 do
      bs = next_block_size len
      (0..255).each do |x|
        perm.setbyte x, nextperm.getbyte(x)
      end
      cheap_lock7(is_locking, perm, nextperm, translation, buffer, off, bs)
      off += bs
      len -= bs
    end
    nextperm[0..255]
  end

end # CheapRandom
  
