class RsvpsController < ApplicationController
  
  def create
    @rsvp = Rsvp.create!(params[:rsvp])
    head :ok
  end
  
  
  
end
