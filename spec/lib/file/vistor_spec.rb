
require 'file/visitor'
require 'spec_utils'

describe File::Visitor do
  include SpecUtils

  before(:each) do
    setup_test_dir
    @visitor = File::Visitor.new
  end

  after(:all) do
    clear_test_dir
  end

  it 'can be created with new()' do
    visitor = File::Visitor.new
    visitor.should be_a File::Visitor
  end

  describe 'file/directory traversal' do

    it 'raises error on non-dir argument' do
      expect { @visitor.visit(nil) }.to raise_error(ArgumentError)
      expect { @visitor.visit(1) }.to raise_error(ArgumentError)
      expect { @visitor.visit_dir(nil) }.to raise_error(ArgumentError)
      expect { @visitor.visit_dir(1) }.to raise_error(ArgumentError)
    end

    it 'can visit given directory' do
      create_file(['dir1'], 'file1', 'a')
      create_file(['dir1'], 'file2', 'b')
      create_file(['dir1'], 'file3', 'c')

      files = []
      @visitor.visit(test_dir) do |path|
        files.push File.basename(path)
      end

      files.size.should == 3
      files[0].should == "file1"
      files[1].should == "file2"
      files[2].should == "file3"
    end

    it 'can visit sibling directories' do
      create_file(['dir1'], 'file10', 'a')
      create_file(['dir2'], 'file11', 'b')
      create_file(['dir3'], 'file12', 'c')

      files = []
      @visitor.visit(test_dir) do |path|
        files.push File.basename(path)
      end

      files.size.should == 3
      files[0].should == "file10"
      files[1].should == "file11"
      files[2].should == "file12"
    end

    it 'can visit deep directories' do
      create_file(['sub'], 'file20', 'a')
      create_file(['sub', 'subsub'], 'file21', 'b')
      create_file(['sub', 'subsub', 'subsubsub'], 'file22', 'c')

      files = []
      @visitor.visit(test_dir) do |path|
        files.push File.basename(path)
      end

      files.size.should == 3
      files[0].should == "file20"
      files[1].should == "file21"
      files[2].should == "file22"
    end

    it 'return empty array when no target files' do
      files = []
      @visitor.visit(test_dir) do |path|
        files.push File.basename(path)
      end
      files.should be_empty
    end

    it 'can do dir-only traversal' do
      create_file(['dir1'], 'file', 'a')
      create_file(['dir2-1'], 'file', 'a')
      create_file(['dir2-1', 'dir2-2'], 'file', 'a')

      dirs = []
      @visitor.visit_dir(test_dir) do |path|
        File.directory?(path).should be_true
        dirs.push File.basename(path)
      end

      dirs.size.should == 3
      dirs[0].should == "dir1"
      dirs[1].should == "dir2-1"
      dirs[2].should == "dir2-2"
    end

  end

  it 'it can get files list' do
    create_file(['dir1'], 'file1', 'a')
    create_file(['dir2'], 'file2', 'b')
    create_file(['dir2'], 'file3', 'c')

    files = @visitor.file_list(test_dir)
    files.size.should == 3

    File.exist?(files[0]).should be_true
    File.exist?(files[1]).should be_true
    File.exist?(files[2]).should be_true

    File.basename(files[0]).should == "file1"
    File.basename(files[1]).should == "file2"
    File.basename(files[2]).should == "file3"
  end

  it 'can get dir list' do
    create_file(['dir1'], 'file1', 'a')
    create_file(['dir2'], 'file2', 'b')
    create_file(['dir2'], 'file3', 'c')

    dirs = @visitor.dir_list(test_dir)
    dirs.size.should == 2

    File.directory?(dirs[0]).should be_true
    File.directory?(dirs[1]).should be_true

    File.basename(dirs[0]).should == "dir1"
    File.basename(dirs[1]).should == "dir2"
  end

  context "filters registration" do

    before(:each) do
    end

    it 'built-in filter' do
      @visitor.add_filter(:name, '2013-01-01.log')
      @visitor.filters.size.should == 1
      @visitor.filters[0].should be_a File::Visitor::Filter::Name
    end

    it 'custom filter' do
      class ValidCustomFilter
        def match?
          true
        end
      end
      @visitor.add_filter(ValidCustomFilter.new)
      @visitor.filters.size.should == 1
      @visitor.filters[0].should be_a ValidCustomFilter
    end

    it "add custom filter fails on invalid class" do
      class BrokenCustomFilter
        # match? not implemented
      end
      expect {
        @visitor.add_filter(BrokenCustomFilter.new)
      }.to raise_error(ArgumentError, /must implement match\?\(\)/)
    end

    it 'block filter' do
      @visitor.add_filter do |path|
        path =~ /\./
      end
      @visitor.filters.size.should == 1
      @visitor.filters[0].should be_a File::Visitor::Filter::Proc
    end

  end

  describe "target?" do

    it "all the paths are target, when no filters" do
      @visitor.target?("/tmp").should be_true
    end

    it "filter AND combination" do
      @visitor.add_filter(:ext, :txt)
      @visitor.add_filter { |path| path =~ /feb/ }
      
      @visitor.target?("/tmp/2013-jan.txt").should be_false
      @visitor.target?("/tmp/2013-feb.txt").should be_true
      @visitor.target?("/tmp/2013-mar.txt").should be_false
    end

  end

end

