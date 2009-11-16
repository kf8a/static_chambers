class AddReleasedField < ActiveRecord::Migration
  def self.up
    add_column :runs, :released, :boolean, :default => false
  end

  def self.down
    remove_column :runs, :released
  end
end
