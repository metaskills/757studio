class RsvpsController < ApplicationController
  
  before_filter :admin_required, :except => [:create,:clear,:mine]
  
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  
  def index
    @rsvps = Rsvp.all
  end
  
  def create
    self.current_rsvp = Rsvp.create!(params[:rsvp])
    head :ok
  end
  
  def destroy
    @rsvp = Rsvp.find(params[:id])
    @rsvp.destroy
    flash[:good] = "Succesfully destroyed RSVP for #{@rsvp.name} with email of <#{@rsvp.email}>."
    redirect_to rsvps_url
  end
  
  def clear
    clear_rsvp
    redirect_to root_path
  end
  
  def mine
    @rsvp = Rsvp.find_by_slug!(params[:id])
    clear_rsvp
    flash.now[:indif] = "Thank you for confirming your reservation!" unless @rsvp.reserved?
    @rsvp.reserved!
  end
  
  
  protected
  
  def not_found
    redirect_to root_path
  end
  
  def clear_rsvp
    self.current_rsvp = nil
  end
  
  
end
