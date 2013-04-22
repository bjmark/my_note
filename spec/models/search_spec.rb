require 'spec_helper'

describe Search do
  specify 'add' do
    Search.create!(:word=>'ruby')
    Search.create!(:word=>'rails')
    Search.add('rails')

    Search.count.should == 2
    Search.order("id desc").first.word.should == 'rails'
  end
end
