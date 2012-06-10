load 'cheap_file.rb'
load 'cheap_big_file.rb'
require 'stringio'

module CheapTest

  FAKE_XLAT = lambda do |is_do, perm, s|
    perm.dup << s.length
  end

  CF = CheapBigFile.new(9, '', '', [], FAKE_XLAT)

end

describe "CheapBigFile's block handling for CheapRandom" do
  it "should return blocks usable as 256 byte chunks" do
    (257..3000).each do |i|
      fd_in = StringIO.new('x' * i)
      fd_out = StringIO.new
      a = CheapTest::CF.xlat_big fd_in, fd_out, CheapTest::FAKE_XLAT
      len = a.length
      exist = len > 0
      exist.should == true
      total = a.reduce(:+)
      total.should == i
      last_block_big_enough = a[-1] > 255
      last_block_big_enough.should == true
      a[0..-2].each do |size|
        big_enough = size > 255
        big_enough.should == true
        multiple_of_256 = 0 == (size % 256)
        multiple_of_256.should == true
      end
    end
  end
end

describe "CheapBigFile's block handling for CheapRandom" do
  it "should return small blocks less than 257" do
    (1..256).each do |i|
      fd_in = StringIO.new('x'*i)
      fd_out = StringIO.new
      a = CheapTest::CF.xlat_big fd_in, fd_out, CheapTest::FAKE_XLAT
      len = a.length
      len.should == 1
      same_size = a[-1] == i
      same_size.should == true
    end
  end
end

