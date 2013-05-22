class ContentIndex < ActiveRecord::Base
  belongs_to :note

  def self.del_note(note)
    ContentIndex.delete_all("note_id = #{note.id}")
  end

  def self.add_note(note)
    words = filter_out_word(note.content)
    rec = []
    words.each do |e|
      rec << {:word=>e,:note_id=>note.id}
    end
    ContentIndex.create!(rec)
  end

  def self.filter_out_word(str)
    words = []
    x = ''
    str.each_char do |c|
      if ('a'..'z').include?(c) || ('A'..'Z').include?(c)
        x << c
      else
        words << x if !x.blank?
        x = ''
      end
    end

    words << x if !x.blank?
    return words
  end
end
