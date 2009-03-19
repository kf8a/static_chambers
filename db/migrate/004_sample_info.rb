class SampleInfo < ActiveRecord::Migration
  def self.up
    add_column "incubations", "lid_type", :string, :limit=>1
    add_column "incubations", "height_1_cm", :float
    add_column "incubations", "height_2_cm", :float
    add_column "incubations", "height_3_cm", :float
    add_column "incubations", "height_4_cm", :float
    add_column "incubations", "soil_temperature", :float
    add_column "incubations", "treatment", :string
    add_column "incubations", "replicate", :string
    
    add_column "samples", "comment", :string
    add_column "samples", "vial", :integer
    add_column "samples", "run_id", :integer
    add_column "samples", "compound_id", :integer
    change_column "samples", "minutes", :integer
    rename_column "samples", "minutes", "seconds"
  end

  def self.down
    remove_column "incubations", "lid_type"
    remove_column "incubations", "height_1_cm"
    remove_column "incubations", "height_2_cm"
    remove_column "incubations", "height_3_cm"
    remove_column "incubations", "height_4_cm"
    remove_column "incubations", "soil_temperature"
    remove_column "incubations", "treatment"
    remove_column "incubations", "replicate"
    
    remove_column "samples", "comment"
    remove_column "samples", "vial"
    remove_column "samples", "run_id"
    remove_column "samples", "compound_id"
    
    rename_column "samples", "seconds", "minutes"
    change_column "samples", "minutes", :float
  end
end
