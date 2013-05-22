class CreateContentIndices < ActiveRecord::Migration
  def self.up
    create_table :content_indices do |t|
      t.string :word
      t.integer :note_id
    end

    change_table :content_indices do |t|
      t.index :word
      t.index :note_id
    end
  end

  def self.down
    change_table :content_indices do |t|
      t.remove_index :word
      t.remove_index :note_id
    end

    drop_table :content_indices
  end
end
