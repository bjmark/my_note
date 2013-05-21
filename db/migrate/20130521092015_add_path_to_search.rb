class AddPathToSearch < ActiveRecord::Migration
  def self.up
    add_column :searches, :kind, :string
  end

  def self.down
    remove_column :searches, :kind
  end
end
