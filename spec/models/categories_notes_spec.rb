require 'spec_helper'

describe CategoriesNotes do
  specify 'create' do 
    CategoriesNotes.create(:note_id=>1,:category_id=>2)
    CategoriesNotes.count.should == 1
  end
end
