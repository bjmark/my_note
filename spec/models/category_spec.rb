#encoding=utf-8
require 'spec_helper'

describe Category do
  specify 'find_or_create' do
    #<find>
    c1 = Category.find_or_create('ruby')
    Category.count.should == 1

    c2 = Category.find_or_create('ruby')
    Category.count.should == 1

    c1.should == c2
    #</find>
    
    #<create>
    c3 = Category.find_or_create('ruby1')
    Category.count.should == 2
    #</create>
  end

  specify 'search' do
    c1 = Category.find_or_create('ruby')
    c3 = Category.find_or_create('ruby1')
    Category.search('ruby').size.should == 2
  end

  specify 'bulk_create' do 
    note = Note.create!
    a = ['a b','b','c']
    Category.bulk_create(note,a.join("\n")).size.should == 3
    Category.count.should == 3
    CategoriesNotes.count.should == 3
    
    Category.all.each do |g|
      g.categories_notes.count.should == 1
    end
  end

  specify 'bulk_upate' do 
    note = Note.create!
    a = ['a b','b','c']
    Category.bulk_create(note,a.join("\n")).size.should == 3
    
    note2 = Note.create!
    Category.bulk_create(note2,'b').size.should == 1

    Category.where(:name=>'b').first.categories_notes.size.should == 2

    b = ['c','d']
    Category.bulk_update(note,b.join("\n"))

    Category.where(:name=>'d').size.should == 1
    Category.where(:name=>'a b').size.should == 0
    Category.where(:name=>'b').size.should == 1
  end
end

