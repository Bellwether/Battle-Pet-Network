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
end