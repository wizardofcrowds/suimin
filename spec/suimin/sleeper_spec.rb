require 'spec_helper'
require 'benchmark'

describe Suimin::Sleeper do
  describe "initialization" do
    let(:suimin) { Suimin::Sleeper.new(name: "ichiro", distribution: [[0.2, 1], [0.8, 2]]) }
    subject { suimin }
    its(:name) { should == "ichiro" }
    its(:distribution) { should == [[0.2, 1], [0.8, 2]]}
  end

  describe "#distribution" do

    describe "normalize distribution of the distribution" do
      subject { suimin.distribution }

      context "the given distribution has [0.2, 1], [0.8, 2]" do
        let(:suimin) { Suimin::Sleeper.new(name: "ichiro", distribution: [[0.2, 1], [0.8, 2]]) }
        subject { suimin.distribution }
        it { should == [[0.2, 1], [0.8, 2]] }
      end

      context "the given distribution has [0.2, 1], [0.2, 2]" do
        let(:suimin) { Suimin::Sleeper.new(name: "ichiro", distribution: [[0.2, 1], [0.2, 2]]) }
        subject { suimin.distribution }
        it { should == [[0.5, 1], [0.5, 2]] }
      end

    end

    describe "sort the distribution elements by probability" do
      subject { suimin.distribution }

      context "the given distribution has [0.8, 1], [0.2, 2]" do
        let(:suimin) { Suimin::Sleeper.new(name: "ichiro", distribution: [[0.8, 1], [0.2, 2]]) }
        subject { suimin.distribution }
        it { should == [[0.2, 2], [0.8, 1]] }
      end

    end

  end

  describe "#rule" do #rule is a list of possible sleep interval in the form of cumulative distribution function
    subject { suimin.rule }

    context "the given distribution has [0.8, 1], [0.2, 2]" do
      let(:suimin) { Suimin::Sleeper.new(name: "ichiro", distribution: [[0.8, 1], [0.2, 2]]) }
      subject { suimin.rule }
      it { should == [[0.2, 2], [1.0, 1]] }
    end

  end

  describe "#sleep_duration" do
    subject { suimin.sleep_duration }

    context "given [0.8, 1], [0.2, 2] and SecureRandom::random_number returns 0.0" do
      before { SecureRandom.stub(random_number: 0.0) }
      let(:suimin) { Suimin::Sleeper.new(name: "ichiro", distribution: [[0.8, 1], [0.2, 2]]) }
      it { should == 2 }
    end

    context "given [0.8, 1], [0.2, 2] and SecureRandom::random_number returns 0.2" do
      before { SecureRandom.stub(random_number: 0.2) }
      let(:suimin) { Suimin::Sleeper.new(name: "ichiro", distribution: [[0.8, 1], [0.2, 2]]) }
      it { should == 2 }
    end

    context "given [0.8, 1], [0.2, 2] and SecureRandom::random_number returns 0.21" do
      before { SecureRandom.stub(random_number: 0.21) }
      let(:suimin) { Suimin::Sleeper.new(name: "ichiro", distribution: [[0.8, 1], [0.2, 2]]) }
      it { should == 1 }
    end

    context "given [0.8, 1], [0.2, 2] and SecureRandom::random_number returns 1.0" do
      before { SecureRandom.stub(random_number: 1.0) }
      let(:suimin) { Suimin::Sleeper.new(name: "ichiro", distribution: [[0.8, 1], [0.2, 2]]) }
      it { should == 1 }
    end

  end

  describe "#sleep" do

    context "the given distribution has [0.2, 0.1], [0.8, 0.05]" do
      let(:suimin) { Suimin::Sleeper.new(name: "ichiro", distribution: [[0.2, 0.1], [0.8, 0.05]]) }

      specify "calling 100 times would take approximately 100 * 0.2 * 0.1 + 100 * 0.8 * 0.05" do
        Benchmark.realtime { 1.upto(100) { suimin.sleep } }.should be_within(1.0).of(6.0)
      end
    end

  end
end
