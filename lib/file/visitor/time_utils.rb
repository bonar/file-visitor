
require "time"

class File
  class Visitor
  end
end

module File::Visitor::TimeUtils

  UNIT_SEC = {
    :sec   => 1,
    :min   => 60,
    :hour  => 60 * 60,
    :day   => 60 * 60 * 24,
    :month => 60 * 60 * 24 * 31,
    :year  => 60 * 60 * 24 * 365
  }
  # aliases
  UNIT_SEC.merge!({
    :secs    => UNIT_SEC[:sec],
    :second  => UNIT_SEC[:sec],
    :seconds => UNIT_SEC[:sec],
    :mins    => UNIT_SEC[:min],
    :minute  => UNIT_SEC[:min],
    :minutes => UNIT_SEC[:min],
    :hours   => UNIT_SEC[:hour],
    :days    => UNIT_SEC[:day],
    :months  => UNIT_SEC[:month],
    :years   => UNIT_SEC[:year],
  })

  COMPARATOR = [
    :equals_to,
    :==,
    :is_greater_than,
    :is_younger_than,
    :>,
    :is_greater_than=,
    :is_younger_than=,
    :>=,
    :is_less_than,
    :is_older_than,
    :<,
    :is_less_than=,
    :is_older_than=,
    :<=,
  ]

  def unitexp2sec(count, unit_name)
    if (!count.is_a?(Fixnum) || count < 0)
      raise ArgumentError,
        "time count must be positive fixnum: #{count}"
    end
    if !UNIT_SEC[unit_name]
      raise ArgumentError, "unknown time unit: #{unit_name}"
    end
    count * UNIT_SEC[unit_name]
  end

  def compare_time(time1, comparator, time2)
    time1 = to_time(time1)
    time2 = to_time(time2)

    unless COMPARATOR.include?(comparator)
      raise ArgumentError,
        "invalid comparator: #{comparator.to_s}"
    end

    case comparator
    when :equals_to, :==
      return time1 == time2
    when :is_greater_than, :is_younger_than, :>
      return time1 > time2
    when :is_greater_than=, :is_younger_than=, :>=
      return time1 >= time2
    when :is_less_than, :is_older_than, :<
      return time1 < time2
    when :is_less_than=, :is_older_than=, :<=
      return time1 <= time2
    else
      raise RuntimeError,
        "invalid comparator: #{comparator.to_s}"
    end
  end

  def to_time(time)
    return time if time.is_a?(Time)
    return Time.parse(time) if time.is_a?(String)
    raise ArgumentError, "invalid time: #{time.inspect}"
  end

end

