require 'test_helper'

class RsvpTest < ActiveSupport::TestCase
  
  should_validate_presence_of :name, :email
  should_not_allow_mass_assignment_of :reserved, :slug
  
  context 'Instance behavior' do

    setup do
      @rsvp = Rsvp.new(:name => 'Test', :email => 'test@test.com')
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
    
    should 'create a slug for each new rsvp' do
      @rsvp.save!
      assert @rsvp.slug.present?
    end

  end
  
  
  
end
