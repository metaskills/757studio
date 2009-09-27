class ApplicationController < ActionController::Base
  
  before_filter :setup_form_objects
  
  helper :all
  helper_method :current_page
  
  protect_from_forgery
  
  
  
  protected
  
  def setup_form_objects
    @rsvp = Rsvp.new
  end
  
  def current_page
    cp = params[:page].to_s.downcase
    cp == 'home' ? 'index' : cp
  end
  
  
end
