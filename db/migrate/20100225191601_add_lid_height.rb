class AddLidHeight < ActiveRecord::Migration
  def self.up
    add_column :lids, :height, :float
  end

  def self.down
    remove_column :lids, :height
  end
end
