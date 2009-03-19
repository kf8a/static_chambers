class Group < ActiveRecord::Base
  has_many :group_affiliations
  has_many :people, :through => :group_affiliations
  has_many :runs
  has_many :group_permissions
  has_many :permissions, :through => :group_permissions
  
  def find_unapproved_runs
    runs(:all,:conditions => ['approved=true'])
  end
  
  def find_approved_runs
  end
end
