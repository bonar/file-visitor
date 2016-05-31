
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
    expect(visitor).to be_a File::Visitor
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

      expect(files.size).to eq 3
      expect(files[0]).to eq "file1"
      expect(files[1]).to eq "file2"
      expect(files[2]).to eq "file3"
    end

    it 'can visit sibling directories' do
      create_file(['dir1'], 'file10', 'a')
      create_file(['dir2'], 'file11', 'b')
      create_file(['dir3'], 'file12', 'c')

      files = []
      @visitor.visit(test_dir) do |path|
        files.push File.basename(path)
      end

      expect(files.size).to eq 3
      expect(files[0]).to eq "file10"
      expect(files[1]).to eq "file11"
      expect(files[2]).to eq "file12"
    end

    it 'can visit deep directories' do
      create_file(['sub'], 'file20', 'a')
      create_file(['sub', 'subsub'], 'file21', 'b')
      create_file(['sub', 'subsub', 'subsubsub'], 'file22', 'c')

      files = []
      @visitor.visit(test_dir) do |path|
        files.push File.basename(path)
      end

      expect(files.size).to eq 3
      expect(files[0]).to eq "file20"
      expect(files[1]).to eq "file21"
      expect(files[2]).to eq "file22"
    end

    it 'return empty array when no target files' do
      files = []
      @visitor.visit(test_dir) do |path|
        files.push File.basename(path)
      end
      expect(files).to be_empty
    end

    it 'can do dir-only traversal' do
      create_file(['dir1'], 'file', 'a')
      create_file(['dir2-1'], 'file', 'a')
      create_file(['dir2-1', 'dir2-2'], 'file', 'a')

      dirs = []
      @visitor.visit_dir(test_dir) do |path|
        expect(File.directory?(path)).to be_truthy
        dirs.push File.basename(path)
      end

      expect(dirs.size).to eq 3
      expect(dirs[0]).to eq "dir1"
      expect(dirs[1]).to eq "dir2-1"
      expect(dirs[2]).to eq "dir2-2"
    end

  end

  it 'it can get files list' do
    create_file(['dir1'], 'file1', 'a')
    create_file(['dir2'], 'file2', 'b')
    create_file(['dir2'], 'file3', 'c')

    files = @visitor.file_list(test_dir)
    expect(files.size).to eq 3

    expect(File.exist?(files[0])).to be_truthy
    expect(File.exist?(files[1])).to be_truthy
    expect(File.exist?(files[2])).to be_truthy

    expect(File.basename(files[0])).to eq "file1"
    expect(File.basename(files[1])).to eq "file2"
    expect(File.basename(files[2])).to eq "file3"
  end

  it 'can get dir list' do
    create_file(['dir1'], 'file1', 'a')
    create_file(['dir2'], 'file2', 'b')
    create_file(['dir2'], 'file3', 'c')

    dirs = @visitor.dir_list(test_dir)
    expect(dirs.size).to eq 2

    expect(File.directory?(dirs[0])).to be_truthy
    expect(File.directory?(dirs[1])).to be_truthy

    expect(File.basename(dirs[0])).to eq "dir1"
    expect(File.basename(dirs[1])).to eq "dir2"
  end

  context "filters registration" do

    before(:each) do
    end

    it 'built-in filter' do
      @visitor.add_filter(:name, '2013-01-01.log')
      expect(@visitor.filters.size).to eq 1
      expect(@visitor.filters[0]).to be_a File::Visitor::Filter::Name
    end

    it 'custom filter' do
      class ValidCustomFilter
        def match?
          true
        end
      end
      @visitor.add_filter(ValidCustomFilter.new)
      expect(@visitor.filters.size).to eq 1
      expect(@visitor.filters[0]).to be_a ValidCustomFilter
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
      expect(@visitor.filters.size).to eq 1
      expect(@visitor.filters[0]).to be_a File::Visitor::Filter::Proc
    end

  end

  describe "target?" do

    it "all the paths are target, when no filters" do
      expect(@visitor.target?("/tmp")).to be_truthy
    end

    it "filter AND combination" do
      @visitor.add_filter(:ext, :txt)
      @visitor.add_filter { |path| path =~ /feb/ }
      
      expect(@visitor.target?("/tmp/2013-jan.txt")).to be_falsy
      expect(@visitor.target?("/tmp/2013-feb.txt")).to be_truthy
      expect(@visitor.target?("/tmp/2013-mar.txt")).to be_falsy
    end

  end

end

