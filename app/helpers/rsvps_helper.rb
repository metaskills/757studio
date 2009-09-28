module RsvpsHelper
  
  def render_rsvp_errors
    error_messages_for :rsvp, :class => 'flash_bad', :object_name => 'Reservation', :header_message => nil, :message => nil
  end
  
  def render_attendee_row(name=nil)
    # If this changes, make sure to update JS ReservationForm#addAttendee method.
    content_tag :div, :class => 'attendee_name vmiddle_all pb10' do
      text_field_tag 'rsvp[attendee_names][]', name, :id => nil
    end
  end
  
  
end
