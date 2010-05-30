require 'test_helper'

class SignTest < ActiveSupport::TestCase
  def setup
    @sender = pets(:siamese)
    @recipient = pets(:persian)
    @cost = AppConfig.communication.sign_endurance_cost
  end
  
  def test_signs_with
    assert !Sign.signs_with( pets(:siamese), @new_pet).blank?
  end
  
  def test_exhaust_sender
    assert_difference '@sender.reload.current_endurance', -@cost do    
      signing = @sender.signings.build(:recipient => @recipient, :sign_type => 'purr')
      signing.save(false)
    end
  end
  
  def test_verb
    Sign::SIGNINGS.each do |s|
      assert_not_nil Sign.new(:sign_type => 'purr').verb
    end
  end
  
  def test_validates_endurance_cost
    @sender.update_attribute(:current_endurance, 0)  
    signing = @sender.signings.build(:recipient => @recipient, :sign_type => 'purr')
    rescue_save(signing)
    assert_equal "not enough endurance", signing.errors.on(:sender_id)
  end
  
  def test_validates_once_per_day
    existing = @sender.signings.build(:recipient => @recipient, :sign_type => 'purr')
    existing.save(false)
    signing = existing.sender.signings.build(:recipient => existing.recipient, :sign_type => 'purr')
    rescue_save(signing)
    assert_equal "already sent a sign today", signing.errors.on(:recipient_id)
  end
end