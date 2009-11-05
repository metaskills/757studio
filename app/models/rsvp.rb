class Rsvp < ActiveRecord::Base
  
  extend ActiveSupport::Memoizable

  MAX_SEATS = 50
  ATTENDEE_RANGE = (1..5).to_a.freeze
  
  named_scope :reserved, :conditions => {:reserved => true}
  named_scope :not_reserved, :conditions => {:reserved => false}
  
  has_one :survey
  
  validates_presence_of :name, :email, :slug
  
  serialize :attendee_names, Array
  attr_protected :reserved, :slug
  
  before_validation :create_slug
  before_save  :record_open_seats, :sync_attendee_info
  after_create :send_reservation
  after_save   :notify_open_seat
  
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
    
    def send_open_seats(exception=nil)
      open_seats? ? not_reserved.all.reject{ |r| r == exception }.each{ |r| r.send_open_seat(true) } : []
    end
    
    def event_date
      Date.parse('2009-11-05')
    end
    
    def event_today?
      event_date == Date.today
    end
    
    def event_passed?
      event_date < Date.today
    end
    
  end
  
  
  def reserved!
    update_attribute :reserved, true if open_seats? && !reserved?
  end
  
  def open_seats?
    self.class.open_seats?
  end
  memoize :open_seats?
  
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
  
  def send_reservation
    RsvpMailer.deliver_reservation(self) unless reserved?
  end
  
  def send_open_seat(verified_open_seats=false)
    RsvpMailer.deliver_open_seat(self) if !reserved? && (verified_open_seats || open_seats?)
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
  
  def record_open_seats
    @seats_were_maxed = !open_seats?
    true
  end
  
  def seats_were_maxed?
    @seats_were_maxed && open_seats?(true)
  end
  
  def notify_open_seat
    self.class.send_open_seats(self) if seats_were_maxed?
  end
  
  
end
