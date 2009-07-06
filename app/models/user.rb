class User < ActiveRecord::Base
    acts_as_authentic 
    
    has_many :group_affiliations
    has_many :groups, :through => :group_affiliations
     
    def default_group
      group_affiliations.find(:first, :conditions => [%q{default_group ='t'}]).group
    end 
    
end
