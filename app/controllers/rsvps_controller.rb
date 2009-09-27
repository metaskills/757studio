class RsvpsController < ApplicationController
  
  def create
    @rsvp = Rsvp.create!(params[:rsvp])
    head :ok
  rescue
    head :bad_request
  end
  
  
  
end
