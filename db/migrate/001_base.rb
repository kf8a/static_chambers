class Base < ActiveRecord::Migration
  def self.up
    create_table "calibrations", :force => true do |t|
       t.column "run_id", :integer
       t.column "name", :string, :limit => 25
     end

     create_table "compounds", :force => true do |t|
       t.string :name, :limit => 10
       t.float :mol_weight
     end
     
     Compound.reset_column_information
     Compound.create(:name =>'n2o', :mol_weight => 43.99)
     Compound.create(:name=>'co2', :mol_weight => 44 )
     Compound.create(:name=>'ch4', :mol_weight => 16)

     create_table "fluxes", :force => true do |t|
       t.column "incubation_id", :integer
       t.column "flux", :float
       t.column "compound_id", :integer
     end
     
     create_table "curves", :force => true do |t|
        t.column "calibration_id", :integer
        t.column "compound_id", :integer
        t.column "slope", :float
        t.column "intercept", :float
      end
     
     create_table "incubations", :force => true do |t|
       t.column "name", :string, :limit => 25
       t.column "run_id", :integer
     end

     create_table "runs", :force => true do |t|
       t.column "run_on", :date
       t.column "sampled_on", :date
       t.column "name", :string, :limit => 25
       t.column "comment", :text
       t.column "approved", :boolean, :default=> false
     end

     create_table "samples", :force => true do |t|
       t.column "response", :float
       t.column "excluded", :boolean, :default => false
       t.column "flux_id", :integer
       t.column "minutes", :float
     end

     create_table "standards", :force => true do |t|
       t.column "ppm", :float
       t.column "response", :float
       t.column "exclude", :boolean, :default => false
       t.column "comment", :text
       t.column "curve_id", :integer
     end
    
  end

  def self.down
    drop_table "standards"
    drop_table "samples"
    drop_table "runs"
    drop_table "incubations"
    drop_table "calibrations"
    drop_table "compounds"
    drop_table "fluxes"
  end
end
