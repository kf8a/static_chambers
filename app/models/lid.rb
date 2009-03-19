class Lid < ActiveRecord::Base #CachedModel
  has_many :incubations
end
