class Compound < ActiveRecord::Base #CachedModel
  has_many :standards
  has_many :fluxes
  has_many :samples
end
