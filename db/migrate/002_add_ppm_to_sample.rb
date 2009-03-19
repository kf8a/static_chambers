class AddPpmToSample < ActiveRecord::Migration
  def self.up
    add_column "samples", "ppm", :float
  end

  def self.down
    remove_column "samples", "ppm"
  end
end
