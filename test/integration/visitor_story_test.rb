require 'test_helper'

class VisitorStoryTest < ActionController::IntegrationTest
  
  should 'A basic user path' do
    # Get Home
    get_page :home
    assert_response :success
    assert_select 'h1', '757Studio'
    # Get Who Should Attend Page
    get_page :who_should_attend
    assert_response :success
    assert_select 'h1', 'Who Should Attend'
    # Get Presenters Page
    get_page :presenters
    assert_response :success
    assert_select 'h1', 'Presenters'
    # Get Sponsors
    get_page :sponsors
    assert_response :success
    assert_select 'h1', 'Sponsors'
    # Not Get RSVP index
    get rsvps_path
    assert_response :unauthorized
    # Get Presenters page again, not see post RSVP flash message, then make a reservation.
    get_page :presenters
    assert_element_visible('div#rsvp_button')
    assert_element_hidden('div#content_right div.flash_indif')
    post rsvps_path, :rsvp => {:name => 'Some Name', :company => 'Some Company', :email => 'some@email.com', :attendees => '1'}
    assert_response :ok
    get_page :presenters
    assert_element_hidden('div#rsvp_button')
    assert_element_visible('div#content_right div.flash_indif')
  end
  
  
  
  
end
