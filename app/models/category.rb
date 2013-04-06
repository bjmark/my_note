class Category < ActiveRecord::Base
  has_many :categories_notes,:class_name=>'CategoriesNotes'
  
  def self.find_or_create(word)
    res_value = self.where(:name=>word).first
    return res_value if res_value

    res_value = self.create!(:name=>word)
  end

  def self.check_name(s)
    names = s.split("\n")
    names = names.reject{|e| e.strip.size == 0}
    names = names.collect{|e| e.split(/\s+/).join(' ')}
    names.uniq
  end

  def self.bulk_create(note,s)
    names = check_name(s)
    categories = names.collect{|e| find_or_create(e)}
    categories.each do |g|
      CategoriesNotes.create!(:note_id=>note.id,:category_id=>g.id)
    end
  end

  def self.bulk_update(note,s)
    names = check_name(s)
    old_cats = note.categories
    
    old_cats = old_cats.reject do |g|
      if !names.include?(g.name)
        CategoriesNotes.delete_all("note_id = #{note.id} and category_id = #{g.id}")
        if g.categories_notes.count == 0
          g.destroy
        end
        next true
      end
    end

    old_names = old_cats.collect{|e| e.name}

    (names - old_names).each do |name|
      g = find_or_create(name)
      CategoriesNotes.create!(:note_id=>note.id,:category_id=>g.id)
    end
  end

  scope :search, lambda {|s| where("name like ?", "#{s}%") }
end
