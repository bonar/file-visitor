
require 'file/visitor/filter'

class File::Visitor::Filter::Ext

    def initialize(extstr)
      if extstr.nil? || !(extstr.is_a?(String) || extstr.is_a?(Symbol))
        raise ArgumentError, "ext must be Sting/Symbol"
      end
      extstr = extstr.to_s
      unless extstr =~ /\A\./
        extstr = ".#{extstr}"
      end
      @ext = extstr
    end

    def match?(path)
      ext = File.extname(path)
      ext == @ext
    end

    def to_s
      "%s[%s]" % [self.class.name, @ext.to_s]
    end

end

