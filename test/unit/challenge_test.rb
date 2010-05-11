require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
  def setup
    @attacker = pets(:siamese)
    @attacker_strategy = @attacker.strategies.first
    @defender = pets(:persian)
    @params = {:attacker_id => @attacker.id,
              :defender_id => @defender.id,
              :attacker_strategy_id => @attacker_strategy.id, 
              :challenge_type => "1v1"}
  end
  
  def test_validates_different_combatants
    invalid_challenge = Challenge.create(@params.merge!(:attacker_id => @defender.id))
    invalid_challenge.save
    assert invalid_challenge.errors.on_base.include?("cannot challenge self")
  end
end