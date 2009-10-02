require 'test_helper'

class RsvpMailerTest < ActionMailer::TestCase
  
  should 'not send emails when newly created Rsvp object is already reserved' do
    assert_no_emails do
      rsvp = Rsvp.new :name => 'Test', :email =>'test@test.com'
      rsvp.reserved = true
      rsvp.save!
    end
  end
  
  context 'For #deliver' do

    setup do
      @rsvp = Rsvp.create! :name => 'Test', :email =>'test@test.com'
    end

    should 'have made an email since new rsvp is not reserved by default' do
      assert_equal 1, deliveries.size
    end
    
    should 'have email with correct content' do
      email = deliveries.first
      assert_equal @rsvp.email, email.to.first
      assert_equal RsvpMailer::FROM, email.from.first
      assert_match %r|Reservation Confirmation|, email.subject
      assert_slug_link_in_body(@rsvp,email)
    end

  end
  
  context 'For #reminder' do

    should 'allow each instance of Rsvp to send a reminder if NOT reserved with correct content' do
      rsvp = rsvps(:simple)
      assert !rsvp.reserved?
      assert_emails(1) { rsvp.send_reminder }
      email = deliveries.first
      assert_equal rsvp.email, email.to.first
      assert_equal RsvpMailer::FROM, email.from.first
      assert_match %r|Reservation Reminder|, email.subject
      assert_slug_link_in_body(rsvp,email)
    end
    
    should 'not allow each instance of Rsvp to send a reminder if it IS reserved' do
      rsvp = rsvps(:big)
      assert rsvp.reserved?
      assert_no_emails { rsvp.send_reminder }
    end
    
    should 'have a class method that send email to all unreserved RSVPs with correct content' do
      total_count = Rsvp.not_reserved.count
      assert_emails(total_count) { Rsvp.send_reminders }
    end
    
    should 'not send reminders if there are no seats available' do
      assert Rsvp.all.any?{ |rsvp| !rsvp.reserved? }, 'making sure there is someone to potentially mail'
      reserve_all_seats!
      assert_no_emails do 
        assert_equal [], Rsvp.send_reminders, 'should return an empty array'
      end
    end

  end
  
  context 'For #open_seat' do
    
    setup do
      @rsvp = rsvps(:simple)
    end
    
    should 'allown instnace of Rsvp to send an open_seat notice if it is not reserved and there is an open seat' do
      assert Rsvp.open_seats?
      assert !@rsvp.reserved?
      @rsvp.send_open_seat
      assert email = deliveries.first
      assert_equal @rsvp.email, email.to.first
      assert_equal RsvpMailer::FROM, email.from.first
      assert_match %r|Open Seat Notice|, email.subject
      assert_slug_link_in_body(@rsvp,email)
    end
    
    context 'under a full house' do

      setup do
        create_count = Rsvp::MAX_SEATS - Rsvp.attendees
        create_count.times do |n|
          r = Rsvp.new :name => "Fill Er#{n}", :email => "fill@er#{n}.com"
          r.reserved = true
          r.save!
        end
        # Subjects
        @notreserved = rsvps(:simple)
        @canceler = rsvps(:big)
        # Testing setup and setup subjects.
        assert_equal Rsvp::MAX_SEATS, Rsvp.attendees
        assert !@notreserved.reserved?
        assert @canceler.reserved?
      end
      
      should 'send an email to non reserved rsvps' do
        @canceler.toggle(:reserved).save!
        assert_equal 1, deliveries.size, 'make sure we find the one for delivered to @notreserved if this is more in here'
        assert email = deliveries.first
        assert_equal @notreserved.email, email.to.first
        assert_match %r|Open Seat Notice|, email.subject
      end

    end

  end
  
  
  
  protected
  
  def deliveries
    ActionMailer::Base.deliveries
  end
  
  def assert_slug_link_in_body(rsvp,email)
    assert_match %r|http:\/\/757studio.org/rsvps/#{rsvp.slug}/mine|m, email.body
  end
  
  
end
