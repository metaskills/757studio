require 'test_helper'

class VisitorStoryTest < ActionController::IntegrationTest
  
  should 'A basic user path' do
    get_page :home
    assert_response :success
    assert_select 'h1', '757Studio'
    get_page :who_should_attend
    assert_response :success
    assert_select 'h1', 'Who Should Attend'
    get_page :presenters
    assert_response :success
    assert_select 'h1', 'Presenters'
    get_page :sponsors
    assert_response :success
    assert_select 'h1', 'Sponsors'
  end
  
  
  
  
end
