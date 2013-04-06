class CreateCategories2Notes < ActiveRecord::Migration
  def self.up
    create_table :categories_notes do |t|
      t.integer :note_id
      t.integer :category_id
      t.timestamps
    end

    change_table :categories_notes do |t|
      t.index :note_id
      t.index :category_id
    end
  end

  def self.down
    change_table :categories_notes do |t|
      t.remove_index :note_id
      t.remove_index :category_id
    end

    drop_table :categories_notes
  end
end
