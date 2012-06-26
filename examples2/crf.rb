#!/usr/bin/env ruby

module CheapRandom

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

  # is_randomizing is a boolean
  # cheap_random with is_randomizing true, randomizes
  # cheap_random with is_randomizing false, un-randomizes
  # perm is a read only string of length 256 with each
  # byte represented once
  # perm is cheap_random's seed
  # nextperm is a writeable string of length 256
  # comes in as a copy of perm
  # it is the next seed for use in chain seeding
  # translation is a buffer needed for perm reversed as a substitution transformation
  # buffer is read as unrandomized text
  # and written as randomized text
  # offset is a pointer into the buffer
  # length is from 1 to 256
  # it is the number of bytes to process
  # starting at offset in buffer
  def self.cheap_random7(is_randomizing, perm, nextperm, translation, buffer, offset, length)
    if is_randomizing then
      random_cheap_random(perm, nextperm, buffer, offset, length)
    else
      (0..255).each do |x|
        translation.setbyte perm.getbyte(x), x
      end
      unrandom_cheap_random(perm, nextperm, translation, buffer, offset, length)
    end
    return nil
  end

  def self.random_cheap_random(perm, nextperm, buffer, offset, length)
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

  def self.unrandom_cheap_random(perm, nextperm, translation, buffer, offset, length)
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
  def self.cheap_random5!(is_randomizing, startperm, buffer, offset, length)
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
      cheap_random7(is_randomizing, perm, nextperm, translation, buffer, off, bs)
      off += bs
      len -= bs
    end
    nextperm[0..255]
  end

  def self.reverse_perm
    s = ' ' * 256
    (0..255).each do |x|
      s.setbyte(x, 255 - x)
    end
    s
  end
 
  def self.cheap_random3!(is_randomizing, perm, s)
    cheap_random5!(is_randomizing, perm, s, 0, s.length)
  end

  def self.cheap_seed!(s)
    ip = reverse_perm
    result = cheap_random3!(true, ip, s)
    cheap_random3!(false, ip, s)
    result
  end

end # CheapRandom

class CheapFile

  def self.file?(afn)
    File.file? afn
  end

  def self.from_file(afn)
    f = File.new afn, 'rb'
    s = f.read
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

  def xlat_small(is_do, s)
    @xlat.call is_do, @seed, s
  end

  def xlat_small_file(fn, should_write = true)
    is_do, afn, new_afn = self.class.is_do_afn_new_afn @base_dir, fn, @xlat_ext
    s = self.class.from_file afn
    perm = xlat_small is_do, s
    self.class.to_file new_afn, s if should_write
    perm
  end

end #CheapFile

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

  def initialize(block_size_exponent, base_dir, xlat_ext, seed, xlat_lambda)
    super base_dir, xlat_ext, seed, xlat_lambda
    @block_size = 1 << block_size_exponent
    @half_block_size = @block_size >> 1
  end

  def xlat_big(fd_in, fd_out, is_do)
    self.class.xlat(fd_in, fd_out, @half_block_size, is_do, @seed, @xlat)
  end

  def xlat_big_file(fn, should_write = true)
    is_do, afn, new_afn = self.class.is_do_afn_new_afn @base_dir, fn, @xlat_ext
    perm = nil
    File.open(afn, 'rb') do |fd_in|
      if should_write
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

module CheapRandomFile

  DEFAULT_SEED = CheapRandom.reverse_perm
  XLAT = lambda {|is_do, perm, s| CheapRandom.cheap_random3! is_do, perm, s}
  XLAT_EXT = '.random'
  SEED_EXT = '.seed'
  PRIOR_EXT = '.prior'
  ENV_CR_SEED_VARIABLE = 'CR_SEED'
  USER_DOT_CHEAP_RANDOM = File.expand_path '~/.cheap_random'
  THE_SEED_FILE_NAME = "#{USER_DOT_CHEAP_RANDOM}/the#{SEED_EXT}"

  def self.afn_path(file_name, ext = '')
    File.absolute_path(file_name + ext)
  end

  def self.is_do?(file_name)
    !(file_name =~ Regexp.new("#{XLAT_EXT}$"))
  end

  def self.name_pair(file_name)
    afn = afn_path file_name
    if is_do? file_name
      new_afn = afn + XLAT_EXT
    else
      new_afn = afn[0..-(XLAT_EXT.length + 1)]
    end
    [afn, new_afn]
  end

  def self.process_one(seed, afn, should_write)
    return seed if File.zero? afn
    is_do = is_do? afn
    fd_in = File.open afn, 'rb'
    fd_out = nil
    if should_write
      fd_out = File.open afn, 'r+b'
    end
    generated_seed =
      CheapBigFile.xlat fd_in, fd_out, 256, is_do, seed, XLAT
    fd_out.close if fd_out
    fd_in.close
    generated_seed
  end

  def self.get_seed_afn
    cr_seed = ENV[ENV_CR_SEED_VARIABLE]
    return afn_path cr_seed if cr_seed
    afn = THE_SEED_FILE_NAME
    a = Dir.glob "#{USER_DOT_CHEAP_RANDOM}/*"
    raise "#{USER_DOT_CHEAP_RANDOM} has multiple seeds" if 1 < a.length
    afn = a[0] if 1 == a.length
    afn
  end

  def self.seed?(s)
    return false unless 256 == s.length
    h = {}
    s.each_byte do |b|
      return false if h[b]
      h[b] = true
    end
    true
  end

  def self.get_seed
    afn = get_seed_afn
    raise "#{afn} does not exist" unless File.exists? afn
    if afn =~ Regexp.new("#{SEED_EXT}$")
      env_seed = CheapFile.from_file afn
      raise "#{afn} bad seed file" unless seed?(env_seed)
      return env_seed
    end
    process_one(DEFAULT_SEED, afn, false)
  end

  def self.prior_seed(new_afn)
    psfn = new_afn + '.new' + SEED_EXT + PRIOR_EXT
    return [psfn, true] if File.exists? psfn
    psfn = new_afn + '.new' + SEED_EXT
    return [psfn, false] if File.exists? psfn
    [nil, nil]
  end

  def self.garbage_collect_prior_seed(seed_file_name, generated_seed)
    prior_afn_seed_file_name = seed_file_name + PRIOR_EXT
    if File.exists? prior_afn_seed_file_name
      prior_afn_seed = CheapFile.from_file prior_afn_seed_file_name
      if prior_afn_seed == generated_seed
        File.delete prior_afn_seed_file_name
      end
    end
  end

  def self.process_generated_seeds(afn, new_afn, generated_seed)
    seed_file_name = afn + '.new' + SEED_EXT
    CheapFile.to_file seed_file_name, generated_seed
    prior_seed_file_name, prior = prior_seed new_afn
    return true unless prior_seed_file_name
    prior_generated_seed = CheapFile.from_file prior_seed_file_name
    seeds_match = prior_generated_seed == generated_seed
    if !prior && !seeds_match
      CheapFile.to_file(prior_seed_file_name + PRIOR_EXT, prior_generated_seed)
    end
    garbage_collect_prior_seed seed_file_name, generated_seed
    seeds_match
  end

  def self.run(file_name)
    afn, new_afn = name_pair file_name
    raise "#{afn} does not exist" unless File.exists? afn
    raise "#{new_afn} already exists" if File.exists? new_afn
    seed = get_seed
    installed_seed_file_name = afn + '.the' + SEED_EXT
    CheapFile.to_file installed_seed_file_name, seed
    generated_seed = process_one seed, afn, true
    File.rename afn, new_afn
    seeds_match = process_generated_seeds afn, new_afn, generated_seed
    [seeds_match, generated_seed, seed]
  end

end #CheapRandomFile

def l
  load File.absolute_path(__FILE__)
end

if ARGV[0]
  p File.absolute_path(__FILE__)
  file_name = ARGV[0]
  seeds_match, generated_seed, seed = CheapRandomFile.run file_name
# p generated_seed.each_byte.inject([], :<<)
  puts 'Mismatching Seeds' unless seeds_match 
else
  puts 'usage: crf <FILE_NAME>'
end

