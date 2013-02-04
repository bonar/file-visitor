
require 'file/visitor/time_utils'

describe File::Visitor::TimeUtils do
  include File::Visitor::TimeUtils

  describe 'unitexp2sec' do

    it "returns seconds with unit string of time" do
      unitexp2sec(1, :sec).should == 1
      unitexp2sec(2, :sec).should == 2
      unitexp2sec(3, :sec).should == 3

      unitexp2sec(1, :min).should == 60
      unitexp2sec(2, :min).should == 120
      unitexp2sec(3, :min).should == 180

      unitexp2sec(1, :hour).should == 60 * 60 * 1
      unitexp2sec(2, :hour).should == 60 * 60 * 2
      unitexp2sec(3, :hour).should == 60 * 60 * 3
    end

    it "returns seconds with unit string aliases" do
      unitexp2sec(1, :second).should == 1
      unitexp2sec(2, :seconds).should == 2
      unitexp2sec(3, :secs).should == 3

      unitexp2sec(1, :mins).should == 60
      unitexp2sec(2, :minute).should == 120
      unitexp2sec(3, :minutes).should == 180

      unitexp2sec(1, :hours).should == 60 * 60 * 1
      unitexp2sec(2, :days).should == 60 * 60 * 24 * 2
      unitexp2sec(3, :months).should == 60 * 60 * 24 * 31 * 3
    end

    it "raises error with invalid count" do
      expect { unitexp2sec(nil, :day) }.to \
        raise_error(ArgumentError, %r/time count must be/)
      expect { unitexp2sec(-1, :day) }.to \
        raise_error(ArgumentError, %r/time count must be/)
    end

    it "raises error with invalid unit name" do
      expect { unitexp2sec(1 , :nichi) }.to \
        raise_error(ArgumentError, %r/unknown time unit/)
    end

  end

  describe 'compare_time' do

    it "supports equals_to" do
      compare_time(
        '2011-12-01 00:00:04',
        :equals_to,
        '2011-12-01 00:00:05'
      ).should be_false

      compare_time(
        '2011-12-01 00:00:05',
        :equals_to,
        '2011-12-01 00:00:05'
      ).should be_true

      compare_time(
        '2011-12-01 00:00:05',
        :equals_to,
        '2011-12-01 00:00:06'
      ).should be_false
    end

    it "supports is_greater_than" do
      compare_time(
        '2011-12-01 00:00:04',
        :is_greater_than,
        '2011-12-01 00:00:05'
      ).should be_false

      compare_time(
        '2011-12-01 00:00:05',
        :is_greater_than,
        '2011-12-01 00:00:05'
      ).should be_false

      compare_time(
        '2011-12-01 00:00:06',
        :is_greater_than,
        '2011-12-01 00:00:05'
      ).should be_true
    end

    it "supports is_greater_than=" do
      compare_time(
        '2011-12-01 00:00:04',
        :is_greater_than=,
        '2011-12-01 00:00:05'
      ).should be_false

      compare_time(
        '2011-12-01 00:00:05',
        :is_greater_than=,
        '2011-12-01 00:00:05'
      ).should be_true

      compare_time(
        '2011-12-01 00:00:06',
        :is_greater_than=,
        '2011-12-01 00:00:05'
      ).should be_true
    end

    it "supports is_less_than" do
      compare_time(
        '2011-12-01 00:00:04',
        :is_less_than,
        '2011-12-01 00:00:05'
      ).should be_true

      compare_time(
        '2011-12-01 00:00:05',
        :is_less_than,
        '2011-12-01 00:00:05'
      ).should be_false

      compare_time(
        '2011-12-01 00:00:06',
        :is_less_than,
        '2011-12-01 00:00:05'
      ).should be_false
    end

    it "supports is_less_than=" do
      compare_time(
        '2011-12-01 00:00:04',
        :is_less_than=,
        '2011-12-01 00:00:05'
      ).should be_true

      compare_time(
        '2011-12-01 00:00:05',
        :is_less_than=,
        '2011-12-01 00:00:05'
      ).should be_true

      compare_time(
        '2011-12-01 00:00:06',
        :is_less_than=,
        '2011-12-01 00:00:05'
      ).should be_false
    end

  end

end

