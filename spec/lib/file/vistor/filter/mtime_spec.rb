
require 'file/visitor/filter/mtime'
require 'spec_helper'
require 'fileutils'
require 'time'

describe File::Visitor::Filter::Mtime do

   before(:each) do
     @ns = File::Visitor::Filter::Mtime
     cleanup_spec_data_dir
   end

   after(:each) do
     cleanup_spec_data_dir
   end

   it "can be created with comparator/target_time" do
    filter = @ns.new(:equals_to, Time.now)
    expect(filter).to be_a @ns
   end

   context ":passed" do

     it ":passed initialize" do
       allow(Time).to receive(:now).and_return(
         Time.parse("2013-01-05 05:00"))

       filter1 = @ns.new(:passed, 2, :days)

       file1 = spec_data_create("file1")
       file2 = spec_data_create("file2")
       file3 = spec_data_create("file3")
       file4 = spec_data_create("file4")

       time1 = Time.parse("2013-01-03 04:59")
       time2 = Time.parse("2013-01-03 05:00")
       time3 = Time.parse("2013-01-03 05:01")
       time4 = Time.parse("2013-01-04 05:00")

       File.utime(time1, time1, file1)
       File.utime(time2, time2, file2)
       File.utime(time3, time3, file3)
       File.utime(time4, time4, file4)

       expect(filter1.match?(file1)).to be_truthy
       expect(filter1.match?(file2)).to be_falsy
       expect(filter1.match?(file3)).to be_falsy
       expect(filter1.match?(file4)).to be_falsy

       filter2 = @ns.new(:passed=, 2, :days)
       expect(filter2.match?(file1)).to be_truthy
       expect(filter2.match?(file2)).to be_truthy
       expect(filter2.match?(file3)).to be_falsy
       expect(filter2.match?(file4)).to be_falsy
     end

   end

   it "raises error with invalid comparator" do
     expect { @ns.new(:invalid, Time.now) }.to \
       raise_error(ArgumentError, %r/comparator must/)
   end

   it "raises error with non-Time instance" do
     expect { @ns.new(:equals_to, :now) }.to \
       raise_error(ArgumentError, %r/time must be/)
   end

   context "match?" do

     before(:each) do
       @file1 = spec_data_create("file1")
       @file2 = spec_data_create("file2")
       @file3 = spec_data_create("file3")
       @file4 = spec_data_create("file4")

       @time1 = Time.parse("2013-01-05 00:00")
       @time2 = Time.parse("2013-01-06 00:00")
       @time3 = Time.parse("2013-01-07 00:00")
       @time4 = Time.parse("2013-01-08 00:00")

       File.utime(@time1, @time1, @file1)
       File.utime(@time2, @time2, @file2)
       File.utime(@time3, @time3, @file3)
       File.utime(@time4, @time4, @file4)
     end

     it "supports eq filter" do
       filter = @ns.new(:equals_to, @time2)
       expect(filter.match?(@file1)).to be_falsy
       expect(filter.match?(@file2)).to be_truthy
       expect(filter.match?(@file3)).to be_falsy
       expect(filter.match?(@file4)).to be_falsy
     end

     it "supports lt filter" do
       filter = @ns.new(:is_less_than, @time2)
       expect(filter.match?(@file1)).to be_truthy
       expect(filter.match?(@file2)).to be_falsy
       expect(filter.match?(@file3)).to be_falsy
       expect(filter.match?(@file4)).to be_falsy
     end

     it "supports gt filter" do
       filter = @ns.new(:is_greater_than, @time2)
       expect(filter.match?(@file1)).to be_falsy
       expect(filter.match?(@file2)).to be_falsy
       expect(filter.match?(@file3)).to be_truthy
       expect(filter.match?(@file4)).to be_truthy
     end

   end

end

