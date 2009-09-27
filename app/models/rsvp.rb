class Rsvp < ActiveRecord::Base
  
  ATTENDEE_RANGE = (1..5).to_a.freeze
  LIKELYHOOD_RANGE = [
    ['On The Fence',1],
    ['Almost Certain',2],
    ['Would Not Miss It!',3]
  ].freeze
  
  attr_protected :reserved, :slug
  
  validates_presence_of :name, :email, :slug
  
  before_validation :create_slug, :on => :create
  after_create :send_email
  
  
  protected
  
  def create_slug
    self[:slug] = ActiveSupport::SecureRandom.hex(10)
  end
  
  def send_email
    RsvpMailer.deliver_reservation(self) unless reserved?
  end
  
  
end
