class CheapBigFile < CheapFile

  def self.readblock(fd_in, half_block_size)
    fd_in.readpartial half_block_size
  rescue EOFError
    nil
  end

  def self.write(fd_out, s)
    fd_out.write s if fd_out
  end

  def self.wipe!(s)
    (0...s.length).each {|i| s.setbyte i, 255}
  end

  def self.eof_sout_from_blocks(half_block_size, s0, s1)
    return [true, nil] unless s0
    return [true, s0] unless s1
    return [true, s0 + s1] if half_block_size > s1.length
    [false, s0]
  end

  def self.xlat(fd_in, fd_out, half_block_size, is_do, seed, xlat_lambda)
    perm = seed
    s0 = readblock fd_in, half_block_size
    eof = false
    while !eof do
      s1 = readblock fd_in, half_block_size
      eof, sout = eof_sout_from_blocks half_block_size, s0, s1
      if sout
        perm = xlat_lambda.call is_do, perm, sout
        write fd_out, sout
      end
      if sout.length > half_block_size
        wipe! s0
        wipe! s1
      end
      s0 = s1
    end
    perm
  end

  def initialize(block_size_exponent, base_dir, xlat_ext, seed, xlat_lambda, should_write = true)
    super base_dir, xlat_ext, seed, xlat_lambda, should_write
    @block_size = 1 << block_size_exponent
    @half_block_size = @block_size >> 1
  end

  def xlat_big(fd_in, fd_out, is_do)
    self.class.xlat(fd_in, fd_out, @half_block_size, is_do, @seed, @xlat)
  end

  def xlat_big_file(fn)
    is_do, afn, new_afn = self.class.is_do_afn_new_afn @base_dir, fn, @xlat_ext
    perm = nil
    File.open(afn) do |fd_in|
      if @should_write
        File.open(new_afn, 'wb') do |fd_out|
          perm = xlat_big(fd_in, fd_out, is_do)
        end
      else
        perm = xlat_big(fd_in, nil, is_do)
      end
    end
    perm
  end

end #CheapBigFile

