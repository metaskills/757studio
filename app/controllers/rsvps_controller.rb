class RsvpsController < ApplicationController
  
  before_filter :admin_required, :except => [:create,:clear,:mine,:toggle_reservation,:survey]
  
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  
  def index
    @rsvps = Rsvp.all
  end
  
  def create
    self.current_rsvp = Rsvp.create!(params[:rsvp])
    head :ok
  end
  
  def destroy
    find_rsvp_id
    @rsvp.destroy
    flash[:good] = "Succesfully destroyed RSVP for #{@rsvp.name} with email of <#{@rsvp.email}>."
    redirect_to rsvps_url
  end
  
  def edit
    find_rsvp_id
  end
  
  def update
    find_rsvp_id
    begin
      update_rsvp_attributes
      redirect_to edit_rsvp_url(@rsvp)
    rescue ActiveRecord::RecordInvalid
      render :action => 'edit'
    end
  end
  
  def clear
    clear_rsvp
    redirect_to root_path
  end
  
  def mine
    find_by_slug
    if request.get?
      clear_rsvp
      @rsvp.reserved! unless session[:toggled_reservation]
    elsif request.put?
      begin
        update_rsvp_attributes
        redirect_to mine_rsvp_url(:id => @rsvp.slug)
      rescue ActiveRecord::RecordInvalid
        render
      end
    end
  end
  
  def toggle_reservation
    find_by_slug
    session[:toggled_reservation] = true
    @rsvp.toggle(:reserved).save!
    redirect_to mine_rsvp_url(:id => @rsvp.slug)
  rescue ActiveRecord::RecordInvalid
    render :action => 'mine'
  end
  
  def survey
    find_by_slug
    @survey = @rsvp.survey || @rsvp.build_survey
    if request.post?
      @survey.update_attributes!(params[:survey])
      flash[:good] = "Thanks for taking the time to fill this out."
      redirect_to survey_rsvp_url(:id => @rsvp.slug)
    end
  end
  
  def send_reminders
    reminded = Rsvp.send_reminders
    reminded_notice = reminded.map { |rsvp| "#{rsvp.name} at #{rsvp.email}" }
    flash[:good] = "Sent reminders out to the following: #{reminded_notice.to_sentence}"
    redirect_to rsvps_url
  end
  
  def send_upcoming_reminders
    RsvpMailer.deliver_upcoming_event_reminders
    flash[:good] = "Sent upcoming event reminders to #{Rsvp.count} people."
    redirect_to rsvps_url
  end
  
  
  protected
  
  def find_rsvp_id
    @rsvp = Rsvp.find(params[:id])
  end
  
  def find_by_slug
    @rsvp = Rsvp.find_by_slug!(params[:id])
  end
  
  def update_rsvp_attributes
    @rsvp.update_attributes!(params[:rsvp])
    flash[:good] = 'Successfully updated reservation and attendee information.'
  end
  
  def not_found
    flash[:bad] = 'Reservation was not found.'
    redirect_to root_path
  end
  
  def clear_rsvp
    self.current_rsvp = nil
  end
  
  
end
