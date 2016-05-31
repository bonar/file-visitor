
require 'fileutils'
require 'rspec/mocks'

module SpecUtils

  def test_dir
    File.join(File.dirname(__FILE__), 'data_for_test')
  end

  def clear_test_dir
    FileUtils.rm_rf(test_dir)
  end

  def setup_test_dir
    clear_test_dir
    FileUtils.mkdir_p(test_dir)
  end

  def create_dir(dirs)
    dirs.unshift test_dir
    FileUtils.mkdir_p(File.join(dirs))
  end

  def create_file(dirs, filename, content)
    dir  = create_dir(dirs)
    path = File.join(dir, filename)
    File.open(path, 'w') do |file|
      file.puts content
    end
    path
  end

end
