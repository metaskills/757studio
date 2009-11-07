class Survey < ActiveRecord::Base
  
  QUESTIONS = [
    {:attr => :a1t, :question => "Please give us a brief description of your expierence. We may quote you."},
    {:attr => :a2t, :question => "Suggest a topic for a future 757 Studio event."},
    {:attr => :a1b, :question => "Would you like to see a larger venue for a future event?"},
    {:attr => :a4t, :question => "If you have a twitter account, what is your username? (for the Nov.5th attendee list on twitter.com/757studio/attendees)"},
    {:attr => :a3t, :question => "Additional comments."}
  ].freeze
  
  belongs_to :rsvp
  
  
  
end






