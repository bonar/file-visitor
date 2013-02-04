
require 'file/visitor/filter_dispatcher'

describe File::Visitor::FilterDispatcher do

  it "dispatches filter classname" do
    File::Visitor::FilterDispatcher.dispatch(:name)\
      .should == File::Visitor::Filter::Name
    File::Visitor::FilterDispatcher.dispatch(:filename)\
      .should == File::Visitor::Filter::Name

    File::Visitor::FilterDispatcher.dispatch(:ext)\
      .should == File::Visitor::Filter::Ext
    File::Visitor::FilterDispatcher.dispatch(:extension)\
      .should == File::Visitor::Filter::Ext
    File::Visitor::FilterDispatcher.dispatch(:filetype)\
      .should == File::Visitor::Filter::Ext

    File::Visitor::FilterDispatcher.dispatch(:mtime)\
      .should == File::Visitor::Filter::Mtime
    File::Visitor::FilterDispatcher.dispatch(:modified_time)\
      .should == File::Visitor::Filter::Mtime
  end

end

