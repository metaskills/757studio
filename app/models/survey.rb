class Survey < ActiveRecord::Base
  
  QUESTIONS = {
    :a1t => "Please give us a brief description of your expierence.",
    :a2t => "Suggest a topic for a future 757 Studio event.",
    :a1b => "Would you like to see a larger venue for a future event?",
    :a3t => "Additional comments."
  }.freeze
  
  belongs_to :rsvp
  
  
  
end






