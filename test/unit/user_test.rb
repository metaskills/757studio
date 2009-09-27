require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  should_validate_presence_of :email, :password
  
  
  def setup
    @admin = users(:admin)
  end
  
  context 'Class methods' do

    should 'authenticate admin by returning user' do
      assert_equal @admin, User.authenticate(@admin.email,@admin.password)
    end
    
    should 'return nil when user is not found' do
      assert_nil User.authenticate('foo@bar.com','secret')
    end

  end
  
  context 'Instance behavior' do

    should 'admin should be so' do
      assert @admin.admin?
    end
    
    should 'not make new users an admin and protected those attributes' do
      assert !User.new.admin?
      assert !User.new(:admin => true).admin?
    end

  end
  
  
  
end
