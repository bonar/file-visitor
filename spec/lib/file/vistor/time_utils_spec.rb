
require 'file/visitor/time_utils'

describe File::Visitor::TimeUtils do
  include File::Visitor::TimeUtils

  describe 'unitexp2sec' do

    it "returns seconds with unit string of time" do
      expect(unitexp2sec(1, :sec)).to eq 1
      expect(unitexp2sec(2, :sec)).to eq 2
      expect(unitexp2sec(3, :sec)).to eq 3

      expect(unitexp2sec(1, :min)).to eq 60
      expect(unitexp2sec(2, :min)).to eq 120
      expect(unitexp2sec(3, :min)).to eq 180

      expect(unitexp2sec(1, :hour)).to eq 60 * 60 * 1
      expect(unitexp2sec(2, :hour)).to eq 60 * 60 * 2
      expect(unitexp2sec(3, :hour)).to eq 60 * 60 * 3
    end

    it "returns seconds with unit string aliases" do
      expect(unitexp2sec(1, :second)).to eq 1
      expect(unitexp2sec(2, :seconds)).to eq 2
      expect(unitexp2sec(3, :secs)).to eq 3

      expect(unitexp2sec(1, :mins)).to eq 60
      expect(unitexp2sec(2, :minute)).to eq 120
      expect(unitexp2sec(3, :minutes)).to eq 180

      expect(unitexp2sec(1, :hours)).to eq 60 * 60 * 1
      expect(unitexp2sec(2, :days)).to eq 60 * 60 * 24 * 2
      expect(unitexp2sec(3, :months)).to eq 60 * 60 * 24 * 31 * 3
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
      expect(compare_time(
        '2011-12-01 00:00:04',
        :equals_to,
        '2011-12-01 00:00:05'
      )).to be_falsy

      expect(compare_time(
        '2011-12-01 00:00:05',
        :equals_to,
        '2011-12-01 00:00:05'
      )).to be_truthy

      expect(compare_time(
        '2011-12-01 00:00:05',
        :equals_to,
        '2011-12-01 00:00:06'
      )).to be_falsy
    end

    it "supports is_greater_than" do
      expect(compare_time(
        '2011-12-01 00:00:04',
        :is_greater_than,
        '2011-12-01 00:00:05'
      )).to be_falsy

      expect(compare_time(
        '2011-12-01 00:00:05',
        :is_greater_than,
        '2011-12-01 00:00:05'
      )).to be_falsy

      expect(compare_time(
        '2011-12-01 00:00:06',
        :is_greater_than,
        '2011-12-01 00:00:05'
      )).to be_truthy
    end

    it "supports is_greater_than=" do
      expect(compare_time(
        '2011-12-01 00:00:04',
        :is_greater_than=,
        '2011-12-01 00:00:05'
      )).to be_falsy

      expect(compare_time(
        '2011-12-01 00:00:05',
        :is_greater_than=,
        '2011-12-01 00:00:05'
      )).to be_truthy

      expect(compare_time(
        '2011-12-01 00:00:06',
        :is_greater_than=,
        '2011-12-01 00:00:05'
      )).to be_truthy
    end

    it "supports is_less_than" do
      expect(compare_time(
        '2011-12-01 00:00:04',
        :is_less_than,
        '2011-12-01 00:00:05'
      )).to be_truthy

      expect(compare_time(
        '2011-12-01 00:00:05',
        :is_less_than,
        '2011-12-01 00:00:05'
      )).to be_falsy

      expect(compare_time(
        '2011-12-01 00:00:06',
        :is_less_than,
        '2011-12-01 00:00:05'
      )).to be_falsy
    end

    it "supports is_less_than=" do
      expect(compare_time(
        '2011-12-01 00:00:04',
        :is_less_than=,
        '2011-12-01 00:00:05'
      )).to be_truthy

      expect(compare_time(
        '2011-12-01 00:00:05',
        :is_less_than=,
        '2011-12-01 00:00:05'
      )).to be_truthy

      expect(compare_time(
        '2011-12-01 00:00:06',
        :is_less_than=,
        '2011-12-01 00:00:05'
      )).to be_falsy
    end

  end

end

