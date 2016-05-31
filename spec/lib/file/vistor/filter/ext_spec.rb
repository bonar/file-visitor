
require 'file/visitor/filter/ext'

describe File::Visitor::Filter::Ext do

  it 'can be created with String/Symbol' do
    filter = File::Visitor::Filter::Ext.new(:txt)
    filter = File::Visitor::Filter::Ext.new("txt")
  end

  it 'can match filename extention' do
    filter = File::Visitor::Filter::Ext.new(:txt)
    expect(filter.match?("/path/to/file.txt")).to be_truthy
    expect(filter.match?("/path/to/file.dat")).to be_falsy
  end

  it 'can be stringified' do
    filter = File::Visitor::Filter::Ext.new(:jpg)
    expect(filter.to_s).to eq "File::Visitor::Filter::Ext[.jpg]"
  end

end

