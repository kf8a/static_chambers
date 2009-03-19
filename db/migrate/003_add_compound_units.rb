class AddCompoundUnits < ActiveRecord::Migration
  def self.up
    add_column "compounds", "unit", :string
    Compound.reset_column_information
    
    c = Compound.find_by_name('n2o')
    c.unit = 'ppm'
    c.save
    c = Compound.find_by_name('co2')
    c.unit = 'ppm'
    c.save
    c = Compound.find_by_name('ch4')
    c.unit = 'ppm'
    c.save
  end

  def self.down
    remove_column "compounds", "unit"
  end
end
