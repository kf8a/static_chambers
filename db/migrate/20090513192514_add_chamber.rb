class AddChamber < ActiveRecord::Migration
  def self.up
    add_column :incubations, :chamber, :string
  end

  def self.down
    remove_column :incubations, :chamber
  end
end
