class ApplicationController < ActionController::Base
  
  helper :all
  helper_method :current_page
  
  protect_from_forgery
  
  
  
  protected
  
  def current_page
    cp = params[:page].to_s.downcase
    cp == 'home' ? 'index' : cp
  end
  
  
end
