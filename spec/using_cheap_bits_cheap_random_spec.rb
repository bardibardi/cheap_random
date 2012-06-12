load 'cheap_random.rb'
load 'cheap_test.rb'

load 'cheap_file.rb'
load 'cheap_big_file.rb'
load 'cheap_bits.rb'

module CheapTest

  BASE_DIR ||= File.expand_path('../random', File.dirname(__FILE__))
  RANDOM_FILE_SOURCE ||= "test.zip"
  XLAT_EXT ||= '.random'
  CB ||= CheapBits.new(9, BASE_DIR, RANDOM_FILE_SOURCE, XLAT_EXT)

  def self.random(n)
    CB.random n
  end

end

describe "CheapTest random" do
  it "should be using the CheapBits RANDOM_FILE_SOURCE" do
    bit = CheapTest.random 2
    is_a_bit = 2 > bit
    is_a_bit.should == true
  end
end

describe "CheapRandom randomizer" do
  it "should reversibly randomize arbitrary strings when using arbitrary seed permutations" do
    reversed = CheapTest.is_reversible?
    reversed.should == true
  end
end

