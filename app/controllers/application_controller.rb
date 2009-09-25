class ApplicationController < ActionController::Base
  
  helper :all
  helper_method :current_page
  
  protect_from_forgery
  
  
  
  protected
  
  def current_page
    params[:page].to_s.downcase
  end
  
  
end
