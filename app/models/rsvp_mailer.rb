class RsvpMailer < ActionMailer::Base
  
  FROM = 'info@757studio.org'
  
  class << self
    
    def deliver_upcoming_event_reminders
      Rsvp.all.each { |rsvp| self.deliver_upcoming_event_reminder(rsvp) }
    end
    
  end
  
  def reservation(rsvp)
    subject '757 Studio Reservation Confirmation'
    assign_common_attributes(rsvp)
  end
  
  def reminder(rsvp)
    subject '757 Studio Reservation Reminder'
    assign_common_attributes(rsvp)
  end
  
  def open_seat(rsvp)
    subject '757 Studio Open Seat Notice'
    assign_common_attributes(rsvp)
  end
  
  def upcoming_event_reminder(rsvp)
    subject "757 Studio [#{rsvp.reserved? ? 'RESERVED' : 'WAITING'}]"
    assign_common_attributes(rsvp)
  end
  
  
  protected
  
  def assign_common_attributes(rsvp)
    from       FROM
    recipients rsvp.email
    body       :rsvp => rsvp
  end
  
  
end
