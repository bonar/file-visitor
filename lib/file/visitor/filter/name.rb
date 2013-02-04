
require 'file/visitor/filter'

class File::Visitor::Filter::Name

  def initialize(exp)
    unless exp.is_a?(String) || exp.is_a?(Regexp)
      raise ArgumentError, "expression must be String or Regexp"
    end
    @exp = exp
  end

  def match?(path)
    filename = File.basename(path)
    return @exp == filename if @exp.is_a?(String)
    return filename =~ @exp if @exp.is_a?(Regexp)
    raise RuntimeError, "unexpected exp type: #{@exp.class}"
  end

  def to_s
    "%s[%s:%s]" % [self.class.name, @exp.class.name, @exp.to_s]
  end

end

