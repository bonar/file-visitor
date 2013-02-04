
require 'file/visitor/filter'
require 'file/visitor/time_utils'

class File::Visitor::Filter::Mtime
  include File::Visitor::TimeUtils

  PASSED_COMPARATOR = {
    :passed  => :is_older_than,
    :passed= => :is_older_than=,
  }

  # Two ways to initialize filter:
  #   1) File::Visitor::Filter::Mtime.new(
  #        :younger_than, "2012-01-01")
  #   2) File::Visitor::Filter::Mtime.new(
  #        :passed, 30, :days)

  def initialize(*args)
    comparator  = args.shift
    target_time = nil

    # case 1)
    if PASSED_COMPARATOR.keys.include?(comparator)
      count = args.shift
      unit  = args.shift
      target_time = Time.now -
        unitexp2sec(count, unit)
      comparator = PASSED_COMPARATOR[comparator]
    # case 2)
    else
      unless COMPARATOR.include?(comparator)
        raise ArgumentError,
          "comparator must be in " +
          COMPARATOR.join(", ")
      end
      target_time = args.shift
      if target_time.is_a?(String)
        target_time = Time.parse(target_time)
      end
      unless target_time.is_a?(Time)
        raise ArgumentError, "time must be a Time"
      end
    end 

    @comparator  = comparator
    @target_time = target_time
  end

  def match?(path)
    compare_time(
      File.mtime(path),
      @comparator,
      @target_time
    )
  end

end

