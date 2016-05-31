
require 'file/visitor/filter/name'

describe File::Visitor::Filter::Name do

  it 'can be created with new()' do
    filter = File::Visitor::Filter::Name.new('hoge')
  end

  it 'can match filename string' do
    filter = File::Visitor::Filter::Name.new('file')

    expect(filter.match?("/path/to/file")).to be_truthy
    expect(filter.match?("file")).to be_truthy

    expect(filter.match?("file.txt")).to be_falsy
    expect(filter.match?(".file")).to be_falsy
  end

  it 'can match filename regexp' do
    filter = File::Visitor::Filter::Name.new(/file\.\w+/)

    expect(filter.match?("/path/to/file.txt")).to be_truthy
    expect(filter.match?("/path/to/xxx_file.txt")).to be_truthy
    expect(filter.match?("file.jpg")).to be_truthy

    expect(filter.match?("/path/to/file")).to be_falsy
  end

  it 'can be stringified' do
    str1 = File::Visitor::Filter::Name.new("strfilter").to_s
    str2 = File::Visitor::Filter::Name.new(/filename\.\w+/).to_s

    expect(str1).to be_a String
    expect(str2).to be_a String

    expect(str1).not_to eq str2
  end

end
