class RsvpsController < ApplicationController
  
  before_filter :admin_required, :except => [:create]
  
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
  
  
end
