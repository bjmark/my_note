class CreateContentIndices < ActiveRecord::Migration
  def self.up
    create_table :content_indices do |t|
      t.string :word
      t.string :hit_ids
    end

    change_table :content_indices do |t|
      t.index :word
    end
  end

  def self.down
    change_table :content_indices do |t|
      t.remove_index :word
    end

    drop_table :content_indices
  end
end
