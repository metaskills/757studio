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
  
  def render_toggle_reservation_area
    action_path = toggle_reservation_rsvp_path(:id => @rsvp.slug)
    if @rsvp.reserved?
      reserved_flag = image_tag('/images/layout/flag_reserved.png')
      action = button_to('Cancel Reservation', action_path, :method => :put, :confirm => 'Are you sure you want to cancel your reservation?')
    else
      reserved_flag = image_tag('/images/layout/flag_not_reserved.png')
      action = Rsvp.open_seats? ? button_to('Make Reservation', action_path, :method => :put) : 'No Seats Available'
    end
    content_tag :div, :class => 'center' do
      reserved_flag + '<br/>' + action
    end
  end
  
  
end
