require 'spec_helper'

describe Note do
  specify 'has_many' do
    note = Note.create!
    
    a = ['a', 'b', 'c']
    Category.bulk_create(note,a.join("\n"))

    note.reload.categories_notes.size.should == 3
    note.categories.size.should == 3
  end

  specify 'delete2' do
    note = Note.create!
    
    a = ['a', 'b', 'c']
    Category.bulk_create(note,a.join("\n"))

    note_id = note.id

    note.reload.delete2
    Note.where(:id=>note_id).should be_blank
    CategoriesNotes.count.should == 0
    Category.count.should == 0
  end

  specify 'search' do
    note = Note.create!(:content=>'aaa')
    names = ['ruby','rails'].join("\n")
    Category.bulk_create(note,names)

    Note.search('ruby')[0].size.should == 1
  end
end
