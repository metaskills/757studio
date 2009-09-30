require 'test_helper'

class RsvpTest < ActiveSupport::TestCase
  
  should_validate_presence_of :name, :email
  should_not_allow_mass_assignment_of :reserved, :slug
  
  
  context 'Class methods' do

    should 'should return reserved attendees sum' do
      assert_equal 4, Rsvp.attendees, 'Double check fixtures'
    end
    
    should 'return return open seats if available' do
      assert Rsvp.attendees < Rsvp::MAX_SEATS, 'Maybe there are too many fixtures :)'
      assert Rsvp.open_seats?
      Rsvp.stubs(:attendees => Rsvp::MAX_SEATS)
      assert !Rsvp.open_seats?
      assert !Rsvp.new.open_seats?, 'should delegate to class'
    end

  end
  
  context 'Instance behavior' do

    setup do
      @rsvp = Rsvp.new(:name => 'Test', :email => 'test@test.com')
    end
    
    should 'never allow attendees to be 0' do
      @rsvp.attendee_names = []
      assert_equal 1, @rsvp.attendees
      @rsvp.attendees = 0
      assert_equal 1, @rsvp.attendees
      @rsvp.attendees = -420
      assert_equal 1, @rsvp.attendees
    end

    should 'not allow mas assignment of default false reserved attribute' do
      assert !@rsvp.reserved?
      @rsvp.attributes = {:reserved => true}
      assert !@rsvp.reserved?
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
    
    should 'be able to create new unreserved rsvps when open seats are false' do
      Rsvp.stubs(:open_seats? => false)
      assert_nothing_raised() { @rsvp.save! }
      @rsvp.toggle(:reserved)
      assert_raise(ActiveRecord::RecordInvalid) { @rsvp.save! }
      assert @rsvp.errors.on(:reservation)
    end
    
    context 'attendees & serialized attendee_names' do

      setup do
        @clean = ['Friend One','Coworker Two']
        @with_blanks = @clean.dup.push('').unshift(nil).push(['Sub Name'])
      end
      
      should 'be an empty array of names by default' do
        assert_equal [], @rsvp.attendee_names
      end

      should 'serialize basic array and update attendees number' do
        @rsvp.attendee_names = @clean
        assert @rsvp.save
        assert_equal @clean, @rsvp.reload.attendee_names
        assert_equal @rsvp.attendee_names.size+1, @rsvp.attendees
      end
      
      should 'scrup blank nil/empty values and compact sub arrays and auto update attendees number' do
        @rsvp.attendee_names = @with_blanks
        assert @rsvp.save
        assert_equal ['Friend One','Coworker Two','Sub Name'], @rsvp.reload.attendee_names
        assert_equal @rsvp.attendee_names.size+1, @rsvp.attendees
      end
      
      should 'not create additonal attendee names for just one attendee' do
        @rsvp.attendees = 1
        assert @rsvp.save
        assert_equal [], @rsvp.reload.attendee_names
      end
      
      should 'create unknown names for all additional attendees ' do
        @rsvp.attendees = 3
        assert @rsvp.save
        assert_equal ['Unknown','Unknown'], @rsvp.reload.attendee_names
      end

    end
    

  end
  
  
  
end
