class RsvpMailer < ActionMailer::Base
  
  FROM = 'info@757studio.org'
  
  def reservation(rsvp)
    subject   '757Studio Reservation Confirmation'
    from       FROM
    recipients rsvp.email
    body       :rsvp => rsvp
  end
  
  

end
