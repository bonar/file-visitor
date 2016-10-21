
require 'file/visitor/filter/ext'

describe File::Visitor::Filter::Ext do

  it 'can be created with String/Symbol' do
    filter = File::Visitor::Filter::Ext.new(:txt)
    expect(filter).to be_truthy

    filter = File::Visitor::Filter::Ext.new("txt")
    expect(filter).to be_truthy
  end

  it 'can match filename extention' do
    filter = File::Visitor::Filter::Ext.new('txt')
    expect(filter.match?("/path/to/file.txt")).to be_truthy
    expect(filter.match?("/path/to/file.dat")).to be_falsy
  end

  it 'can be stringified' do
    filter = File::Visitor::Filter::Ext.new('jpg')
    expect(filter.to_s).to eq "File::Visitor::Filter::Ext[.jpg]"
  end

  it 'can take array param as OR filters' do
    filter = File::Visitor::Filter::Ext.new(['jpg', 'txt'])
    expect(filter.match?("/path/to/file.txt")).to be_truthy
    expect(filter.match?("/path/to/file.jpg")).to be_truthy
    expect(filter.match?("/path/to/file.mp3")).to be_falsy
  end

  it 'raises error on invalid ext' do
    expect { File::Visitor::Filter::Ext.new(nil) } \
      .to raise_error /ext is nil/
    expect { File::Visitor::Filter::Ext.new([nil]) } \
      .to raise_error /ext must be/
  end

end

