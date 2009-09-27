require 'test_helper'

class RsvpsControllerTest < ActionController::TestCase
  
  context 'For INDEX action' do

    should 'allow authenticated admin to get page' do
      login_as_admin
      get :index
      assert_response :success
      assert_select 'h1', 'RSVPs'
    end

  end
  
  
  
end
