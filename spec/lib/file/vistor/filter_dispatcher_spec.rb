
require 'file/visitor/filter_dispatcher'

describe File::Visitor::FilterDispatcher do

  it "dispatches filter classname" do
    expect(File::Visitor::FilterDispatcher.dispatch(:name))\
      .to eq File::Visitor::Filter::Name
    expect(File::Visitor::FilterDispatcher.dispatch(:filename))\
      .to eq File::Visitor::Filter::Name

    expect(File::Visitor::FilterDispatcher.dispatch(:ext))\
      .to eq File::Visitor::Filter::Ext
    expect(File::Visitor::FilterDispatcher.dispatch(:extension))\
      .to eq File::Visitor::Filter::Ext
    expect(File::Visitor::FilterDispatcher.dispatch(:filetype))\
      .to eq File::Visitor::Filter::Ext

    expect(File::Visitor::FilterDispatcher.dispatch(:mtime))\
      .to eq File::Visitor::Filter::Mtime
    expect(File::Visitor::FilterDispatcher.dispatch(:modified_time))\
      .to eq File::Visitor::Filter::Mtime
  end

end

