class Note < ActiveRecord::Base
  has_many :categories_notes,:class_name=>'CategoriesNotes'
  has_many :categories,:through=>:categories_notes

  def self.search(word)
      categories = Category.search(word)
      
      category_ids = categories.collect{|e| e.id}
      note_ids = CategoriesNotes.where(:category_id=>category_ids).collect{|e| e.note_id}
      notes = Note.where(:id=>note_ids)

      [notes,categories]
  end

  def delete2
    self.categories.each do |g|
      g.destroy  if g.categories_notes.size == 1
    end
    
    CategoriesNotes.delete_all("note_id = #{self.id}")
    self.destroy
  end
end
