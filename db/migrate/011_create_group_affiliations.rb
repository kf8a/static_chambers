class CreateGroupAffiliations < ActiveRecord::Migration
  def self.up
    create_table :group_affiliations do |t|
      t.column :user_id, :integer
      t.column :group_id, :integer
    end
  end

  def self.down
    drop_table :group_affiliations
  end
end
