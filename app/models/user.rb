class User < ActiveRecord::Base
  
  named_scope :admins, :conditions => {:admin => true}
  
  validates_presence_of :email, :password
  
  attr_protected :admin
  
  
  class << self
    
    def authenticate(email,password)
      returning user = find_by_email_and_password(email,password) do
        user.try(:touch)
      end
    end
    
  end
  
  
  
end
