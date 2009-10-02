class Rsvp < ActiveRecord::Base
  
  MAX_SEATS = 50
  ATTENDEE_RANGE = (1..5).to_a.freeze
  
  named_scope :reserved, :conditions => {:reserved => true}
  named_scope :not_reserved, :conditions => {:reserved => false}
  
  validates_presence_of :name, :email, :slug
  
  serialize :attendee_names, Array
  attr_protected :reserved, :slug
  
  before_validation :create_slug
  before_save  :sync_attendee_info
  after_create :send_email
  
  class << self
    
    def attendees
      reserved.sum(:attendees)
    end
    
    def open_seats?
      attendees < MAX_SEATS
    end
    
    def send_reminders
      open_seats? ? not_reserved.all.each(&:send_reminder) : []
    end
    
  end
  
  
  def reserved!
    update_attribute :reserved, true unless reserved?
  end
  
  def open_seats?
    @open_seats ||= self.class.open_seats?
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
  
  def send_reminder
    RsvpMailer.deliver_reminder(self) unless reserved?
  end
  
  
  protected
  
  def validate
    validate_new_reserved_state
  end
  
  def validate_new_reserved_state
    if reserved_changed? && reserved?
      errors.add :reservation, 'can not be confirmed because all seats are currently taken' unless open_seats?
    end
  end
  
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
