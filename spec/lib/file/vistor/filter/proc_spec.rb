
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
    filter.match?("/tmp/hoge/fuga.log").should be_true
    filter.match?("/tmp/log/fuga.txt").should be_true
    filter.match?("/tmp/hoge/fuga").should be_false
  end
  
  it 'can be stringified' do
    filter1 = File::Visitor::Filter::Proc.new(proc { true })
    filter2 = File::Visitor::Filter::Proc.new(proc { false })

    filter1.to_s.should be_a String
    filter2.to_s.should be_a String

    filter1.to_s.should_not == filter2.to_s
  end

end

