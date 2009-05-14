class Incubation < ActiveRecord::Base #CachedModel 
  belongs_to :run
  has_many :fluxes, :dependent => :destroy
  belongs_to :lid
  
  def plot(compound_id)
    f = File.dirname(__FILE__) + "/../../tmp/incubation_" + self.id.to_s + ".png"
    fluxes = self.fluxes.find(:first, :conditions => ['compound_id = ?', compound_id])  
  end
  
end
