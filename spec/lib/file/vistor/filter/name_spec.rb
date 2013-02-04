
require 'file/visitor/filter/name'

describe File::Visitor::Filter::Name do

  it 'can be created with new()' do
    filter = File::Visitor::Filter::Name.new('hoge')
  end

  it 'can match filename string' do
    filter = File::Visitor::Filter::Name.new('file')

    filter.match?("/path/to/file").should be_true
    filter.match?("file").should be_true

    filter.match?("file.txt").should be_false
    filter.match?(".file").should be_false
  end

  it 'can match filename regexp' do
    filter = File::Visitor::Filter::Name.new(/file\.\w+/)

    filter.match?("/path/to/file.txt").should be_true
    filter.match?("/path/to/xxx_file.txt").should be_true
    filter.match?("file.jpg").should be_true

    filter.match?("/path/to/file").should be_false
  end

  it 'can be stringified' do
    str1 = File::Visitor::Filter::Name.new("strfilter").to_s
    str2 = File::Visitor::Filter::Name.new(/filename\.\w+/).to_s

    str1.should be_a String
    str2.should be_a String

    str1.should_not == str2
  end

end
