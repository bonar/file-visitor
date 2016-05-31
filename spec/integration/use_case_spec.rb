
require 'file/visitor'
require 'spec_utils'

describe 'use case test' do
  include SpecUtils

  before(:each) do
    setup_test_dir
  end

  context "collect log file" do

    before(:each) do
      @path1 = create_file(['log', '2013-01'], '2013-01-01.log', 'a')
      @path2 = create_file(['log', '2013-02'], '2013-02-02.log', 'b')
      @path3 = create_file(['log', '2013-02'], '2013-02-03.log', 'c')
      @path4 = create_file(['log', '2013-01'], '2013-01-03.txt', 'd')
    end

    it 'removes 2013-02 logs' do
      visitor = File::Visitor.new
      visitor.add_filter(:ext, :log)
      visitor.add_filter { |path| path =~ /2013\-02/ }

      allow(FileUtils).to receive(:rm).with(@path2)
      allow(FileUtils).to receive(:rm).with(@path3) 

      visitor.visit(test_dir) do |path|
        FileUtils.rm(path)
      end

    end

    it 'removes old logs' do
      time1 = Time.parse("2013-01-01 00:00:00")
      time2 = Time.parse("2013-01-02 00:00:00")
      time3 = Time.parse("2013-01-03 00:00:00")
      time4 = Time.parse("2013-01-04 00:00:00")

      File.utime(time1, time1, @path1)
      File.utime(time2, time2, @path2)
      File.utime(time3, time3, @path3)
      File.utime(time4, time4, @path4)

      allow(Time).to receive(:now).and_return(Time.parse("2013-01-04 22:00:00"))

      visitor = File::Visitor.new
      visitor.add_filter(:mtime, :passed, 1, :day)

      expect(visitor.file_list(test_dir)).to eq([@path1, @path2, @path3])

      visitor.add_filter(:mtime, :passed, 2, :days)
      expect(visitor.file_list(test_dir)).to eq([@path1, @path2])

      visitor.add_filter(:mtime, :passed, 3, :days)
      expect(visitor.file_list(test_dir)).to eq([@path1])
    end

  end

end

