
require 'file/visitor/filter/proc'

describe File::Visitor::Filter::Proc do

  it 'can be created with new()' do
    filter = File::Visitor::Filter::Proc.new(proc { |path| true })
  end

  it 'raises error when non-proc instance given' do
    expect {
      filter = File::Visitor::Filter::Proc.new(true)
    }.to raise_error(ArgumentError, /Proc instance required/)
  end

  it 'can match path with custom proc' do
    filter = File::Visitor::Filter::Proc.new(proc { |path| 
      path =~ /log/
    })
    expect(filter.match?("/tmp/hoge/fuga.log")).to be_truthy
    expect(filter.match?("/tmp/log/fuga.txt")).to be_truthy
    expect(filter.match?("/tmp/hoge/fuga")).to be_falsy
  end
  
  it 'can be stringified' do
    filter1 = File::Visitor::Filter::Proc.new(proc { true })
    filter2 = File::Visitor::Filter::Proc.new(proc { false })

    expect(filter1.to_s).to be_a String
    expect(filter2.to_s).to be_a String

    expect(filter1.to_s).not_to eq filter2.to_s
  end

end

