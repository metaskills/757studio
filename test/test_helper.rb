ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  fixtures :all
  
  
  private
  
  def get_page(name)
    get site_path(name.to_s)
  end
  
  def login_as_admin
    returning admin = users(:admin) do
      @request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("#{admin.email}:#{admin.password}")
    end
  end
  
  def assert_element_visible(selector,visible=true)
    style_regexp = visible ? /display:(inline|block);/ : /display:none;/
    assert_select(selector) do
      assert_select '[style=?]', style_regexp
    end
  end

  def assert_element_hidden(selector)
    assert_element_visible(selector,visible=false)
  end
  
  
end
