require 'test_helper'

class RsvpsControllerTest < ActionController::TestCase
  
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
  
  context 'For CREATE action' do

    setup do
      @rsvp_parms = {:name => 'Some Name', :company => 'Some Company', :email => 'some@email.com', :attendees => '1'}
    end

    should 'be able to create an rsvp with more than one attendee' do
      @rsvp_parms[:attendees] = 2
      post :create, :rsvp => @rsvp_parms
      assert_response :ok
    end

  end
  
  context 'For MINE action' do

    should 'be able to get page using slug' do
      get :mine, :id => @rsvp.slug
      assert_response :success
      assert_select 'h1', 'My Registration'
    end
    
    should 'be aboe to update attributes' do
      new_name = 'Some Newname'
      new_email = 'new@email.come'
      new_comp = 'A New Company'
      new_attendees = ['Some Otherguy']
      put :mine, :id => @rsvp.slug, :rsvp => {:name => new_name, :email => new_email, :company => new_comp, :attendee_names => new_attendees}
      assert_redirected_to mine_rsvp_path(:id => @rsvp.slug)
      @rsvp.reload
      assert_equal new_name, @rsvp.name
      assert_equal new_email, @rsvp.email
      assert_equal new_comp, @rsvp.company
      assert_equal new_attendees, @rsvp.attendee_names
      assert_equal 2, @rsvp.attendees
    end

  end
  
  
    
end
