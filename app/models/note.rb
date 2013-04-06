class Note < ActiveRecord::Base
  has_many :categories_notes,:class_name=>'CategoriesNotes'
  has_many :categories,:through=>:categories_notes

  def delete2
    cats = self.categories
    CategoriesNotes.delete_all("note_id = #{self.id}")
    self.destroy

    cats.each do |g|
      g.destroy if g.categories_notes.size == 0
    end
  end
end
