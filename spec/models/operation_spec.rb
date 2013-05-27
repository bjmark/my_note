require 'spec_helper'

describe Operation do
  specify 'bdate,edate' do
    Operation.create!
    Operation.count.should == 1
    
    Operation.bdate(Date.today.to_formatted_s(:db)).count.should == 1
    Operation.bdate((Date.today + 1).to_formatted_s(:db)).count.should == 0
    Operation.bdate('2012-1').count.should == 1

    Operation.edate(Date.today.to_formatted_s(:db)).count.should == 0
    Operation.edate((Date.today + 1).to_formatted_s(:db)).count.should == 1
  end
   
  specify 'to_date' do
    Operation.to_date('2011-5-1').should_not be_nil 
    Operation.to_date('2011-5-').should be_nil 
  end
end
