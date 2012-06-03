load 'cheap_random.rb'
load 'cheap_test.rb'

describe "CheapRandom randomizer" do
  it "should reversibly randomize arbitrary strings when using arbitrary seed permutations" do
    reversed = CheapTest.is_reversible?
    reversed.should == true
  end
end

