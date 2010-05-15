require 'test_helper'

class CombatTest < ActiveSupport::TestCase
  def setup
    @battle = battles(:persian_burmese_resolved_battle)
    @hunt = hunts(:rat_hunt)
    @combat_models = [@hunt,@battle]
    
    @attacker = pets(:siamese)
    @defender = pets(:persian)
    @attacker_strategy = @attacker.strategies.first
    @defender_strategy = @defender.strategies.first
    @defender = pets(:burmese)
    @params = {:attacker_id => @attacker.id,
              :defender_id => @defender.id,
              :attacker_strategy_id => @attacker_strategy.id, 
              :defender_strategy_id => @defender_strategy.id,               
              :challenge_type => "1v1"}
  end
  
  def test_attacker
    @combat_models.each do |m|
      assert m.respond_to?(:attacker)
      assert_not_nil m.attacker
    end
  end

  def test_defender
    @combat_models.each do |m|
      assert m.respond_to?(:defender)
      assert_not_nil m.defender, @hunt.sentient.inspect
    end
  end
  
  def test_combat_needs_to_occur_on_battle
    Challenge.destroy_all
    challenge = Challenge.new(@params)
    challenge.build_battle()
    assert challenge.battle.combat_needs_to_occur?
    challenge.save(false)
    assert !challenge.battle.combat_needs_to_occur?
  end
  
  def test_combat_needs_to_occur_on_hunt
    hunt = Hunt.new(:sentient_id => sentients(:leper_rat).id)
    assert hunt.combat_needs_to_occur?
    hunt.status = "ended"
    hunt.save(false)
    assert !hunt.combat_needs_to_occur?
  end
end