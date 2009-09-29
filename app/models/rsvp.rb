class Rsvp < ActiveRecord::Base
  
  ATTENDEE_RANGE = (1..5).to_a.freeze
  LIKELYHOOD_RANGE = [
    ['On The Fence',1],
    ['Almost Certain',2],
    ['Would Not Miss It!',3]
  ].freeze
  
  validates_presence_of :name, :email, :slug
  
  serialize :attendee_names, Array
  attr_protected :reserved, :slug
  
  before_validation :create_slug
  before_save  :sync_attendee_info
  after_create :send_email
  
  class << self
    
    def attendees
      sum :attendees, :conditions => {:reserved => true}
    end
    
  end
  
  
  def reserved!
    update_attribute :reserved, true unless reserved?
  end
  
  def attendees=(value)
    value = 1 if value.blank? || value.to_i <= 0
    self[:attendees] = value
  end
  
  def attendee_names
    self['attendee_names'].nil? ? default_attendee_names : unserialize_attribute('attendee_names')
  end
  
  def attendee_names=(names)
    scrubbed_names = names.flatten.reject(&:blank?)
    self[:attendee_names] = scrubbed_names
  end
  
  
  protected
  
  def default_attendee_names
    attendees == 1 ? [] : (attendees-1).times.map{ "Unknown" }
  end
  
  def sync_attendee_info
    self.attendee_names = attendee_names
    self.attendees =  attendee_names.size + 1
  end
  
  def create_slug
    self[:slug] ||= ActiveSupport::SecureRandom.hex(10)
  end
  
  def send_email
    RsvpMailer.deliver_reservation(self) unless reserved?
  end
  
  
end
