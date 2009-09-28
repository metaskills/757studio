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
    
    should 'have a reserved! method that updates record in place' do
      assert !@rsvp.reserved?
      @rsvp.reserved!
      assert @rsvp.reload.reserved?
    end
    
    context 'serialized attendee_names' do

      setup do
        @clean = ['Friend One','Coworker Two']
        @with_blanks = @clean.dup.push('').unshift(nil).push(['Sub Name'])
      end

      should 'serialize basic array' do
        @rsvp.attendee_names = @clean
        assert @rsvp.save
        assert_equal @clean, @rsvp.reload.attendee_names
      end
      
      should 'scrup blank nil/empty values and compact sub arrays' do
        @rsvp.attendee_names = @with_blanks
        assert @rsvp.save
        assert_equal ['Friend One','Coworker Two','Sub Name'], @rsvp.reload.attendee_names
      end
      
      should 'not create additonal attendee names for just one attendee' do
        @rsvp.attendees = 1
        assert @rsvp.save
        assert_nil @rsvp.reload.attendee_names
      end
      
      should 'create unknown names for all additional attendees ' do
        @rsvp.attendees = 3
        assert @rsvp.save
        assert_equal ['Unknown','Unknown'], @rsvp.reload.attendee_names
      end

    end
    

  end
  
  
  
end
