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
  end
  
  
  
  
end
