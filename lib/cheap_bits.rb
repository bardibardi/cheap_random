class CheapBits

  def self.readblock(fd_in, block_size)
    fd_in.readpartial block_size
  rescue EOFError
    nil
  end

  def self.getbit(random_block, bit_offset)
    byte_offset = bit_offset >> 3
    byte_bit_offset = bit_offset - (byte_offset << 3)
    byte = random_block.getbyte(byte_offset)
    1 & (byte >> (7 - byte_bit_offset))
  end

  def initialize(block_size_exponent, base_dir, fn, xlat_ext)
    @afn = "#{base_dir}/#{fn}#{xlat_ext}"
    @block_size = 1 << block_size_exponent
    @fd_in = nil
    @current_block = ''
    @bits_total = 0
    @bit_offset = 0
  end

  def readblock
    open unless @fd_in
    s = self.class.readblock @fd_in, @block_size
    if !s
      rewind
      s = self.class.readblock @fd_in, @block_size
    end
    @current_block = s
    @bits_total = @current_block.length << 3
    @bit_offset = 0
    s
  end

  def close
    @fd_in.close if @fd_in
  end

  def open
    @fd_in = File.open(@afn)
  end

  def rewind
    close
    open
    @current_block = ''
    @bits_total = 0
    @bit_offset = 0
  end

  def getbit
    readblock if @bit_offset == @bits_total
    bit = self.class.getbit(@current_block, @bit_offset)
    @bit_offset += 1
    bit
  end

  def getbits_as_number(how_many)
    return nil unless how_many > 0
    first_one_bit_found = false
    bits = 0
    how_many.times do
      bit = getbit
      if first_one_bit_found
        bits = bits << 1
        bits += bit
      else
        if 1 == bit
          bits = 1
          first_one_bit_found = true
        end
      end
    end
    bits
  end

  def random(n)
    return nil unless n > 0
    return 0 if 1 == n
    bits_needed = 0
    power_of_two = 1
    while n > power_of_two
      bits_needed += 1
      power_of_two = power_of_two << 1
    end
    bits = power_of_two
    while bits >= n
      bits = getbits_as_number bits_needed
    end
    bits
  end

  def broken_random(n)
    current = n
    acc = 0
    while current > 0
      odd = 1 == 1 & current
      current = current >> 1
      if current > 0
        acc += current if 1 == getbit
      end
      if odd
        if (1 == getbit)
          acc += 1
        else
          current += 1
        end
      end
    end
    acc - 1
  end

  def get_many_random(how_many, what)
    a = []
    what.times {a << 0}
    how_many.times do
      r = random(what)
      a[r] +=  1
    end
    a
  end

end #CheapBits

