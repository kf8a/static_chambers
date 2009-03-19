class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :name, :string
    end
    add_column "runs", "group_id", :integer
  end

  def self.down
    remove_column "runs", "grouo_id"
    drop_table :groups
  end
end
