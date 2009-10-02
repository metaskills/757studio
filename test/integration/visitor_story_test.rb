require 'test_helper'

class VisitorStoryTest < ActionController::IntegrationTest
  
  def setup
    Rsvp.delete_all
  end
  
  should 'A basic user path' do
    # Get Home
    get_page :home
    assert_response :success
    assert_select 'h1', 'Presentations/Talks'
    # Get Who Should Attend Page
    get_page :who_should_attend
    assert_response :success
    assert_select 'h1', 'Who Should Attend'
    # Get Presenters Page
    get_page :presenters
    assert_response :success
    assert_select 'h1', 'Presenters'
    # Get Venue
    get_page :the_venue
    assert_response :success
    assert_select 'h1', 'The Venue'
    # Not Get RSVP index
    get rsvps_path
    assert_response :unauthorized
    # Get Presenters page again, not see post RSVP flash message, then make a reservation.
    get_page :presenters
    assert_element_visible('div#rsvp_button')
    assert_element_hidden('#rsvp_flash_indif')
    post rsvps_path, :rsvp => {:name => 'Some Name', :company => 'Some Company', :email => 'some@email.com', :attendees => '1'}
    assert_response :ok
    get_page :presenters
    assert_element_hidden('div#rsvp_button')
    assert_element_visible('#rsvp_flash_indif')
    # Let's assume we clicked the link in the email
    rsvp = Rsvp.first
    get mine_rsvp_path(:id =>rsvp.slug)
    assert_response :success
    assert_select 'h1', 'My Registration'
    assert_element_hidden('div#rsvp_stuff')
    # Can go to other page and see registration if needed
    get_page :home
    assert_select 'h1', 'Presentations/Talks'
    assert_element_visible('div#rsvp_stuff')
    assert_element_visible('div#rsvp_button')
    assert_element_hidden('div#content_right div.flash_indif')
  end
  
  should 'Not see seats reserved message until max seats have been reached' do
    get_page :home
    assert_element_hidden '#rsvp_flash_alert'
    reserve_all_seats!
    get_page :home
    assert_element_visible '#rsvp_flash_alert'
  end
  
  should 'Not be allowed to confirm reservation when house is full' do
    reserve_all_seats!
    rsvp_email = 'unlucky@email.com'
    post rsvps_path, :rsvp => {:name => 'Some Name', :company => 'Some Company', :email => rsvp_email, :attendees => '1'}
    assert_response :ok
    assert rsvp = Rsvp.find_by_email(rsvp_email)
    assert_equal rsvp.id, session[:rsvp_id]
    assert !rsvp.reserved?
    get mine_rsvp_path(:id =>rsvp.slug)
    assert_response :success
    rsvp.reload
    assert !rsvp.reserved?
    assert_nil session[:rsvp_id]
    assert_element_hidden '#rsvp_flash_indif'
  end
  
  
end
