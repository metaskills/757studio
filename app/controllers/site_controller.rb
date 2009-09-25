class SiteController < ApplicationController
  
  def index
    render
  end
  
  def show
    render :template => "site/#{current_page}"
  rescue
    render :nothing => true, :status => 404
  end
  
  
end
