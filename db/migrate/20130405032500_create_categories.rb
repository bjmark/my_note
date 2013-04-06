class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string     :name
      t.timestamps
    end

    change_table :categories do |t|
      t.index :name
    end
  end

  def self.down
    change_table :categories do |t|
      t.remove_index :name
    end

    drop_table :categories
  end
end
