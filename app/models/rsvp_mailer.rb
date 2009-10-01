class RsvpMailer < ActionMailer::Base
  
  FROM = 'info@757studio.org'
  
  def reservation(rsvp)
    subject   '757 Studio Reservation Confirmation'
    assign_common_attributes(rsvp)
  end
  
  def reminder(rsvp)
    subject   '757 Studio Reservation Reminder'
    assign_common_attributes(rsvp)
  end
  
  
  protected
  
  def assign_common_attributes(rsvp)
    from       FROM
    recipients rsvp.email
    body       :rsvp => rsvp
  end

end
