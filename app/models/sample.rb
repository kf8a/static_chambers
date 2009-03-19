class Sample < ActiveRecord::Base #CachedModel
  belongs_to :run
  belongs_to :flux
  belongs_to :calibration
  belongs_to :compound

  def minutes 
    self.seconds
  end
  
  def minutes=(minute)
    self.seconds = minute.to_f
  end
end
