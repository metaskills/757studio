class SiteController < ApplicationController
  
  PAGES = ['']
  
  before_filter :ensure_valid_page, :except => :index
  
  
  def index
    render
  end
  
  def show
    render :template => "site/#{current_page}"
  end
  
  
  protected
  
  def current_page
    params[:page].to_s.downcase
  end
  
  def ensure_valid_page
    unless PAGES.include?(current_page)
      render :nothing => true, :status => 404 and return false
    end
  end
  
  
end
