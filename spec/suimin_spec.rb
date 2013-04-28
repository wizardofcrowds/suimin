require 'spec_helper'

describe Suimin do

  describe "::config" do
    let(:sleeper)  { Suimin::Sleeper.new(name: "napper", distribution: [[0.2, 0.1], [0.8, 0.2]]) }
    before do
      Suimin.config do |config|
        config.add_sleeper sleeper
      end
    end

    it "should have set sleepers" do
      Suimin.sleepers[sleeper.name].should == sleeper
    end
  end

  describe "::let_sleeper_sleep" do
    let(:quick_napper) { Suimin::Sleeper.new(name: "quick_napper", distribution: [[0.2, 0.2], [0.8, 0.1]]) }
    let(:snoozer)      { Suimin::Sleeper.new(name: "snoozer", distribution: [[0.2, 2], [0.8, 1]]) }
    let(:sleepers) { [quick_napper, snoozer] }
    before do
      Suimin.config do |s|
        s.add_sleeper quick_napper
        s.add_sleeper snoozer
      end
    end

    specify "Suimin::let_sleeper_sleep with quick_napper should call quick_napper.sleep" do
      quick_napper.should_receive(:sleep).and_return(true)
      snoozer.should_not_receive(:sleep)
      Suimin.let_sleeper_sleep("quick_napper")
    end

    specify "Suimin::let_sleeper_sleep with non-existent sleeper should blow up" do
      lambda { Suimin.let_sleeper_sleep("not_registered_napper") }.should raise_exception(Suimin::SleeperNotFound)
    end

  end
end
