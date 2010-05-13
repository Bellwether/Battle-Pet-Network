require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
  def setup
    @attacker = pets(:siamese)
    @attacker_strategy = @attacker.strategies.first
    @defender = pets(:burmese)
    @params = {:attacker_id => @attacker.id,
              :defender_id => @defender.id,
              :attacker_strategy_id => @attacker_strategy.id, 
              :challenge_type => "1v1"}
  end
  
  def test_validates_different_combatants
    invalid_challenge = Challenge.create(@params.merge!(:attacker_id => @defender.id))
    assert invalid_challenge.errors.on_base.include?("cannot challenge self")
  end
  
  def test_validates_no_existing_challenge
    invalid_challenge = Challenge.create(@params)
    assert invalid_challenge.errors.on_base.include?("existing challenge already issued")
  end
  
  def test_validate_prowling
    Challenge.destroy_all
    prowling = occupations(:prowling)
    taming = occupations(:taming)
    @attacker.update_attribute(:occupation_id,prowling.id)
    @defender.update_attribute(:occupation_id,prowling.id)
    challenge = Challenge.create(@params)
    assert_nil challenge.errors.on(:defender_id)
    assert_nil challenge.errors.on(:attacker_id)
    @attacker.update_attribute(:occupation_id,taming.id)
    @defender.update_attribute(:occupation_id,taming.id)
    challenge = Challenge.create(@params)
    assert_equal "must be prowling to issue challenge", challenge.errors.on(:attacker_id)
    assert_equal "must be prowling to accept challenge", challenge.errors.on(:defender_id)
  end
end