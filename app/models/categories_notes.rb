class CategoriesNotes < ActiveRecord::Base
  belongs_to :category
  belongs_to :note
end
