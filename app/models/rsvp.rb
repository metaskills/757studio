class Rsvp < ActiveRecord::Base
  
  ATTENDEE_RANGE = (1..5).to_a.freeze
  LIKELYHOOD_RANGE = [
    ['On The Fence',1],
    ['Almost Certain',2],
    ['Would Not Miss It!',3]
  ].freeze
  
  attr_protected :reserved
  
  validates_presence_of :name, :email
  
  
  after_create :send_email
  
  
  protected
  
  def send_email
    RsvpMailer.deliver_reservation(self) unless reserved?
  end
  
  
end
