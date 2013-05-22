class ContentIndex < ActiveRecord::Base
  def self.add_note(note)
    words = filter_out_word(note.content)
    words.each do |e|
      c = ContentIndex.where(:word=>e).first
      c = ContentIndex.new(:word=>e) if c.blank?
      
      if c.hit_ids.blank?
        ids = []
      else
        ids = c.hit_ids.split(',')
      end

      note_id = note.id.to_s
      
      ids = ids.reject{|i| i == note_id}
      ids << note_id

      c.hit_ids = ids.join(',')
      c.save
    end
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
