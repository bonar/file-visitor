
require 'file/visitor/filter'

class File::Visitor::Filter::Proc

  def initialize(custom_proc)
    unless custom_proc.is_a?(Proc)
      raise ArgumentError, "Proc instance required"
    end
    @proc = custom_proc
  end

  def match?(path)
    !!@proc.call(path)
  end

  def to_s
    "%s[%s]" % [self.class.name, @proc.object_id]
  end

end


