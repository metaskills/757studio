require 'test_helper'

class RsvpsControllerTest < ActionController::TestCase
  
  fixtures :all
  
  def setup
    @rsvp = rsvps(:simple)
  end
  
  context 'For INDEX action' do
  
    should 'allow authenticated admin to get page' do
      login_as_admin
      get :index
      assert_response :success
      assert_select 'h1', 'RSVPs'
    end
  
  end
  
  context 'For DESTROY action' do
  
    should 'allow authenticated admin to destroy a rsvp/reservation' do
      login_as_admin
      delete :destroy, :id => @rsvp.id
      assert_redirected_to rsvps_url
      assert assigns(:rsvp).frozen?
    end
  
  end
  
  
  
  
end
