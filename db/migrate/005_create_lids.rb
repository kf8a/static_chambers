class CreateLids < ActiveRecord::Migration
  def self.up
    create_table :lids do |t|
      t.column "name", :string, :limit => 1
      t.column "volume", :float
    end
    
    Lid.reset_column_information
    Lid.create({:name=>'A', :volume => 16.5})
    Lid.create({:name=>'B', :volume => 16.9})
    Lid.create({:name=>'C', :volume => 17.3})
    
    add_column "incubations", "lid_id", :integer

    remove_column "incubations", "lid_type"
  end

  def self.down
    add_column "incubations", "lid_type", :string, :limit => 1
    remove_column "incubations", "lid_id"
    drop_table :lids
  end
end
