class CreateGroupPermissions < ActiveRecord::Migration
  def self.up
    create_table :group_permissions do |t|
      t.column :group_id, :integer
      t.column :permission_id, :integer
    end
  end

  def self.down
    drop_table :group_permissions
  end
end
