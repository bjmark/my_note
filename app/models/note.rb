class Note < ActiveRecord::Base
  has_many :categories_notes,:class_name=>'CategoriesNotes'
  has_many :categories,:through=>:categories_notes

  def delete2
    self.categories.each do |g|
      g.destroy  if g.categories_notes.size == 1
    end
    
    CategoriesNotes.delete_all("note_id = #{self.id}")
    self.destroy
  end
end
