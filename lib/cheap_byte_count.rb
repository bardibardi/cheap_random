class CheapByteCount

  def self.readblock(fd_in)
    fd_in.readpartial 4096
  rescue EOFError
    nil
  end

  def self.byte_count_array_from_file(file_name)
    bca = nil
    File.open(file_name, 'rb') do |fd_in|
      bca = new(fd_in).byte_count_array
    end
    bca
  end

  attr_reader :byte_count_array

  def initialize(fd_in)
    @byte_count_array = []
    256.times {@byte_count_array << 0}
    while s = self.class.readblock(fd_in) do
      s.each_byte do |b|
        @byte_count_array[b] += 1
      end
    end
  end
  
end

