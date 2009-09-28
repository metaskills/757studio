module RsvpsHelper
  
  def render_rsvp_errors
    error_messages_for :rsvp, :class => 'flash_bad', :object_name => 'Reservation', :header_message => nil, :message => nil
  end
  
  
end
