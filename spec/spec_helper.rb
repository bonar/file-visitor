
def spec_data_dir
  data_dir = File.join(
    File.dirname(__FILE__), "data_for_spec")
  unless File.directory?(data_dir)
    FileUtils.mkdir(data_dir)
  end
  data_dir
end

def cleanup_spec_data_dir
  return unless File.directory?(spec_data_dir)
  FileUtils.rm_rf(spec_data_dir)
end

def spec_data_create(filename)
  path = File.join(spec_data_dir, filename)
  file = File.open(path, "w") do |file|
    file.puts "test"
  end
  path
end

