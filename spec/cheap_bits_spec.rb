load 'cheap_file.rb'
load 'cheap_big_file.rb'
load 'cheap_bits.rb'

module CheapTest

  BASE_DIR = File.expand_path('../../random', File.dirname(__FILE__))
  RANDOM_FILE_SOURCE = "test.zip"
  XLAT_EXT = '.random'
  CB = CheapBits.new(9, BASE_DIR, RANDOM_FILE_SOURCE, XLAT_EXT)

  def self.random(n)
    CB.random n
  end

end

describe "CheapBits random" do
  it "should get an in bounds number" do
    inbounds = 256 > CheapTest.random(256)
    inbounds.should == true
  end
end

describe "CheapBits getbit" do
  fake_random_block = ' ' * 8
  (0..7).each {|i| fake_random_block.setbyte(7 - i, 1 << i) }
  it "should get the correct bit" do
    (0..7).each do |i|
      bit = CheapBits.getbit fake_random_block, ((i << 3) + i)
      bit.should == 1
    end
  end
end

describe "CheapBits get_many_random" do
  it "should be plausibly random" do
    a = CheapTest::CB.get_many_random 30000, 3
    a.each do |i|
      plausible = i > 9750
      plausible.should == true
    end
  end
end

