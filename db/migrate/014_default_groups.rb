class DefaultGroups < ActiveRecord::Migration
  def self.up
    add_column "group_affiliations", "default_group", :boolean,  :default => false
  end

  def self.down
    remove_column "group_affiliations", "default"
  end
end
