class User < ActiveRecord::Base
    acts_as_authentic :validate_fields=>false, :logout_on_timeout => true, :validate_password_field => false
    
    has_many :group_affiliations
    has_many :groups, :through => :group_affiliations
     
    def default_group
      group_affiliations.find(:first, :conditions => [%q{default_group ='t'}]).group
    end 
    
end
