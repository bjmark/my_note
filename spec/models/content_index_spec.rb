require 'spec_helper'

describe ContentIndex do
  specify 'filter_out_word' do
    s = "ab\ ef // Def => Def"
    words = ContentIndex.filter_out_word(s)
    words.should == %w(ab ef def)
  end

  specify 'add_note' do
    note1 = Note.create!(:content=>"each git --cache \n --no-merge git")
    note2 = Note.create!(:content=>"git merge")

    job1 = BackgroundJob.create!(:job=>{:name=>'build_content_index',:note_id=>note1.id,:content=>note1.content})
    job2 = BackgroundJob.create!(:job=>{:name=>'build_content_index',:note_id=>note2.id,:content=>note2.content})

    ContentIndex.add_note(job1.job[:note_id],job1.job[:content])
    ContentIndex.add_note(job2.job[:note_id],job2.job[:content])

    ContentIndex.where('word like ?','git%').count.should == 2

    ContentIndex.del_note(note2)
    ContentIndex.where('word like ?','git%').count.should == 1
  end
end
