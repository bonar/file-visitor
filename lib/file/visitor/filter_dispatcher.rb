
require 'file/visitor/filter'
require 'file/visitor/filter/name'
require 'file/visitor/filter/ext'
require 'file/visitor/filter/mtime'

class File::Visitor::FilterDispatcher

  def self.dispatch(filter_name)
    case filter_name
    when :name, :filename
      return File::Visitor::Filter::Name
    when :ext, :extension, :filetype
      return File::Visitor::Filter::Ext
    when :mtime, :modified_time
      return File::Visitor::Filter::Mtime
    end
    raise ArgumentError, "invalid filter name: #{filter_name}"
  end

end

