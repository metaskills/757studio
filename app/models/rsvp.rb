class Rsvp < ActiveRecord::Base
  
  ATTENDEE_RANGE = (1..5).to_a.freeze
  LIKELYHOOD_RANGE = [
    ['On The Fence',1],
    ['Almost Certain',2],
    ['Would Not Miss It!',3]
  ].freeze
  
  attr_protected :reserved
  
  
  def likelyhood
    self[:likelyhood] || 2
  end
  
  
end
