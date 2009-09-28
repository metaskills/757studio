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
    @rsvp = Rsvp.find_by_slug!(params[:id])
    if request.get?
      clear_rsvp
      flash.now[:indif] = "Thank you for confirming your reservation!" unless @rsvp.reserved?
      @rsvp.reserved!
    elsif request.put?
      begin
        update_rsvp_attributes
        redirect_to mine_rsvp_url(:id => @rsvp.slug)
      rescue ActiveRecord::RecordInvalid
        render
      end
    end
  end
  
  
  protected
  
  def find_rsvp_id
    @rsvp = Rsvp.find(params[:id])
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
