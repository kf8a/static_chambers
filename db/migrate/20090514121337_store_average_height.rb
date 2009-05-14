class StoreAverageHeight < ActiveRecord::Migration
  def self.up
    add_column :incubations, :avg_height_cm, :float
    
    Incubation.reset_column_information
    Incubation.find(:all).each do |i|
      i.avg_height_cm = (i.height_1_cm + i.height_2_cm + i.height_3_cm + i.height_4_cm)/4
    end
    remove_column :incubations, :height_1_cm
    remove_column :incubations, :height_2_cm  
    remove_column :incubations, :height_3_cm  
    remove_column :incubations, :height_4_cm  
  end

  def self.down
    add_column :incubations, :height_4_cm, :float
    add_column :incubations, :height_3_cm, :float
    add_column :incubations, :height_2_cm, :float
    add_column :incubations, :height_1_cm, :float
    Incubation.reset_column_information
    Incubation.find(:all).each do |i|
      i.height_1_cm = i.avg_height_cm/4
      i.height_2_cm = i.height_1_cm
      i.height_3_cm = i.height_1_cm
      i.height_4_cm = i.height_1_cm
    end
    remove_column :incubations, :avg_height_cm
  end
end
