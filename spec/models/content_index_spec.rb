require 'spec_helper'

describe ContentIndex do
  specify 'filter_out_word' do
    s = "ab\ ef // Def"
    words = ContentIndex.filter_out_word(s)
    words.should == %w(ab ef Def)
  end

  specify 'add_note' do
    note1 = Note.create!(:content=>"each git --cache \n --no-merge")
    note2 = Note.create!(:content=>"git merge")
    ContentIndex.add_note(note1)
    ContentIndex.add_note(note2)
    ContentIndex.add_note(note1)
    ContentIndex.where(:word=>'git').first.hit_ids.split(',').sort.should == [note1.id.to_s,note2.id.to_s]
  end
end
