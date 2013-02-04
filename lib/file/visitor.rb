
require 'file/visitor/filter'
require 'file/visitor/filter_dispatcher'
require 'file/visitor/filter/proc'

class File
  class Visitor

    attr_reader :filters
    attr_accessor :visit_dot_dir

    FILTER_NS_BASE = File::Visitor::Filter

    def initialize
      @filters = []

      @visit_dot_dir = false
    end

    def visit(dir, &handler)
      visit_with_mode(dir, :file, &handler)
    end

    def visit_dir(dir, &handler)
      visit_with_mode(dir, :dir, &handler)
    end

    def file_list(dir)
      files = []
      visit(dir) { |path| files << path }
      files
    end

    def dir_list(dir)
      dirs = []
      visit_dir(dir) { |path| dirs << path }
      dirs
    end

    # 3 ways to register filter
    #
    # 1. built-in filter
    #    filter.add_filter(:mtime, :passed, 30, :days)
    #
    # 2. custom filter
    #    filter.add_filter(my_filter)
    #    (my_filter must implements match?(path) method)
    #
    # 3. block filter
    #    filter.add_filter do |path|
    #      # filter operations
    #    end
    #
    def add_filter(*args, &block)
      # 3. block filter
      if block_given?
        filter = File::Visitor::Filter::Proc.new(block)
        @filters.push(filter)
        return true
      end

      # 2. custom filter
      if (1 == args.size)
        custom_filter = args.shift
        unless (custom_filter.respond_to?(:match?))
          raise ArgumentError,
            "custom_filter must implement match?()"
        end
        @filters.push(custom_filter)
        return true
      end

      # 1. built-in filter
      filter_class = File::Visitor::FilterDispatcher.dispatch(args.shift)
      @filters.push(filter_class.new(*args))
      true
    end

    def target?(path)
      # all the paths are target when no filters given
      return true unless @filters

      @filters.each do |filter|
        return false unless filter.match?(path)
      end
      true
    end

    private

    def dot_dir?(path)
      basename = File.basename(path)
      basename == '.' || basename == '..'
    end

    def assert_directory(dir)
      unless dir.is_a?(String) && File.directory?(dir)
        raise ArgumentError, "#{dir} is not directory"
      end
    end

    # dir: target directory
    # mode:
    #   file - visit all files
    #   dir  - visit directory only
    # handler: proc to call

    def visit_with_mode(dir, mode, &handler)
      assert_directory(dir)

      Dir.entries(dir).each do |entry|
        next if (dot_dir?(entry) && !@visit_dot_dir)

        abs_path = File.join(dir, entry)
        if File.directory?(abs_path)
          mode == :dir && handler.call(abs_path)
          visit_with_mode(abs_path, mode, &handler)
        else
          if mode == :file && target?(abs_path)
            handler.call(abs_path) 
          end
        end
      end
    end

  end
end

