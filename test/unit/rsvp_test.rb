require 'test_helper'

class RsvpTest < ActiveSupport::TestCase
  
  context 'Instance behavior' do

    setup do
      @rsvp = Rsvp.new
    end

    should 'not allow mas assignment of default false reserved attribute' do
      assert !@rsvp.reserved?
      @rsvp.attributes = {:reserved => true}
      assert !@rsvp.reserved?
    end

  end
  
  
end
