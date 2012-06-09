load 'cheap_file.rb'
load 'cheap_big_file.rb'
require 'stringio'

module CheapTest

  FAKE_XLAT = lambda do |is_do, perm, s|
    s.length.to_s
  end

  CF = CheapBigFile.new(9, '', '', '', FAKE_XLAT)

end

describe "CheapBigFile's block handling for CheapRandom" do
  it "should return blocks larger than 255" do
    (256..3000).each do |i|
      fd_in = StringIO.new('x'*i)
      fd_out = StringIO.new
      sl = CheapTest::CF.xlat_big fd_in, fd_out, CheapTest::FAKE_XLAT
      big_enough = sl.to_i > 255
      big_enough.should == true
    end
  end
end

describe "CheapBigFile's block handling for CheapRandom" do
  it "should return small blocks less than 256" do
    (1..255).each do |i|
      fd_in = StringIO.new('x'*i)
      fd_out = StringIO.new
      sl = CheapTest::CF.xlat_big fd_in, fd_out, CheapTest::FAKE_XLAT
      same_size = sl.to_i == i
      same_size.should == true
    end
  end
end

