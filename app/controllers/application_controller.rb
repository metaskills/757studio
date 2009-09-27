class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  helper :all
  helper_method :current_page, :current_rsvp
  
  rescue_from ActiveRecord::RecordInvalid, :with => :render_invalid_record
  
  before_filter :setup_form_objects
  
  
  
  protected
  
  def setup_form_objects
    @rsvp = Rsvp.new
  end
  
  def current_page
    cp = params[:page].to_s.downcase
    cp == 'home' ? 'index' : cp
  end
  
  def current_rsvp=(rsvp)
    @rsvp = rsvp
    session[:rsvp_id] = rsvp.id
  end
  
  def current_rsvp
    unless @current_rsvp == false
      @current_rsvp ||= session[:rsvp_id] ? Rsvp.find(session[:rsvp_id]) : false
    end
  end
  
  def render_invalid_record(exception)
    record = exception.record
    respond_to do |format|
      format.html { render :action => (record.new_record? ? 'new' : 'edit') }
      format.js   { render :json => record.errors.full_messages, :status => :unprocessable_entity, :content_type => 'application/json' }
      format.xml  { render :xml => record.errors.full_messages,  :status => :unprocessable_entity }
      format.json { render :json => record.errors.full_messages, :status => :unprocessable_entity }
    end
  end
  
  def admin_required
    authenticate_or_request_with_http_basic('757Studio') do |email,password|
      user = User.authenticate(email,password)
      user.try(:admin?)
    end
  end
  
  
end
