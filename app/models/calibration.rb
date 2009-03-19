class Calibration < ActiveRecord::Base
  belongs_to :run
  has_many :curves
end
