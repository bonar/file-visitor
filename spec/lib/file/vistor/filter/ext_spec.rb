
require 'file/visitor/filter/ext'

describe File::Visitor::Filter::Ext do

  it 'can be created with String/Symbol' do
    filter = File::Visitor::Filter::Ext.new(:txt)
    filter = File::Visitor::Filter::Ext.new("txt")
  end

  it 'can match filename extention' do
    filter = File::Visitor::Filter::Ext.new(:txt)
    filter.match?("/path/to/file.txt").should be_true
    filter.match?("/path/to/file.dat").should be_false
  end

  it 'can be stringified' do
    filter = File::Visitor::Filter::Ext.new(:jpg)
    filter.to_s.should == "File::Visitor::Filter::Ext[.jpg]"
  end

end

