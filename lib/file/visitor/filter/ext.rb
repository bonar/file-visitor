
require 'file/visitor/filter'

class File::Visitor::Filter::Ext

    def initialize(ext)
      if ext.is_a?(Array)
        @extentions = ext
      elsif ext.nil?
        raise ArgumentError, "ext is nil"
      else
        @extentions = [ext]
      end

      @extentions = @extentions.map do |extention|
        if extention.nil? ||
          !(extention.is_a?(String) || extention.is_a?(Symbol))
          raise ArgumentError, "ext must be Sting/Symbol."
        end

        extention = extention.to_s
        unless extention =~ /\A\./
          extention = ".#{extention}"
        end
        extention
      end
    end

    def match?(path)
      ext = File.extname(path)
      @extentions.any? { |fext| ext == fext }
    end

    def to_s
      "%s[%s]" % [self.class.name, @extentions.join(',')]
    end

end

