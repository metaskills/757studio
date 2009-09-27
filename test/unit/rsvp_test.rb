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
    
    should 'have a default likelyhood of 2' do
      assert_equal 2, @rsvp.likelyhood
      @rsvp.likelyhood = 3
      assert_equal 3, @rsvp.likelyhood
    end

  end
  
  
end
