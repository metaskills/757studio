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
      assert_match %r|the following link.*http:\/\/757studio.org/rsvps/#{@rsvp.slug}/mine|m, email.body
    end

  end
  
  
  protected
  
  def deliveries
    ActionMailer::Base.deliveries
  end
  
end
