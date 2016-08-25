# File::Visitor

file path collectiong utility

## DESCRIPTION

file-visitor is an alternative way to collecting files.
We often write code to collect file, like this.

    Dir.glob("/usr/local/lib/*.a")

Dir.glob or UNIX find command is very useful.
But in the following cases, it is not enough. 

* need to combine various conditions. 
* need to write the conditions of the file path to collect by ruby. 
* need to test and reuse conditions. 

Collecting files with file-visitor:

    require 'file/visitor'
    
    visitor = File::Visitor.new
      
    # files with extension .log
    visitor.add_filter(:ext, :log)
    
    # and last modified is more than 30 days ago
    visitor.add_filter(:mtime, :passed, 30, :days)

    # set sort order (:asc or :desc)
    visitor.set_direction(:desc) 

    # remove all the matched files
    visitor.visit(root_dir) do |path|
      FileUtils.rm(path)
    end

You can add custom filters.

    class BigFileFilter
     
      def initialize(size)
        @size = size
      end
    
      # filter must implement match?(path)
      def match?(path)
        File.size(path) > @size
      end
    
    end
     
    filter = BigFileFilter(2048)
    visitor.add_filter(filter)

BigFileFilter is testable and reusable.

### Filters

#### Filename

filename string or regexp.

    visitor.add_filter(:filename, "sample.txt")
    visitor.add_filter(:filename. /\d{4}\-\d{2}\-\d{2}\.txt/)

#### Extension

file extension sym or string.

    visitor.add_filter(:ext, :txt)

#### Modified time

    # 1. specify Time instance
    # add_filter(:mtime, comparetor_sym, time)
    visitor.add_filter(:mtime, :equals_to, Time.parse("2013-01-03 04:59"))
    visitor.add_filter(:mtime, :is_less_than, Time.parse("2013-01-03 04:59"))
    
    # 2 specify number and unit sym
    # add_filter(:mtime, :passed, number, time_unit)
    visitor.add_filter(:mtime, :passed, 3, :days)

Comparator syms you can use:

* :equals_to (:==)
* :is_greater_than (:is_younger_than, :>)
* :is_greater_than= (:is_younger_than=, :>=)
* :is_less_than (:is_older_than, :<)
* :is_less_than= (:is_older_than=, :<=)

Time unit

* :sec, :second, :seconds
* :min, :mins, :minute, :minutes
* :hour, :hours
* :day, :days
* :month, :months (1 month = 30 days)
* :year, :years

#### Block filter

    visitor.add_filter do |path|
      # return true/false
    end

#### custom filter

    class HaveMD5SumFilter
      def match?(path)
        File.readable?("#{path}.md5")
      end
    end
  
    filter = HaveMD5SumFilter.new
    visitor.add_filter(filter)

filter instance must repond_to :match?.

### methods

#### visit(dir)

Collect files and execute given block.

#### file_list(dir)

Collect files and return path array.

#### target?(path)

return if the given path is target.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'file-visitor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install file-visitor

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/file-visitor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

