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
  
  def test_attr_accessors
    accessors = [:current_round,:attacker_damage,:defender_damage]
    @combat_models.each do |m|
      accessors.each do |a|
        assert m.respond_to?(a), "#{m.class.name} didn't respond to #{a}"
      end
    end
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
  
  def test_combatants
    @combat_models.each do |m|
      assert m.combatants.is_a? Array
      assert_equal 2, m.combatants.size
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
  
  def test_combat_in_progress?
    attributes = [:current_health,:current_endurance]
    @combat_models.each do |m|
      assert m.combat_in_progress?
      m.combatants.each do |c|
        attributes.each do |a|
          c.update_attribute(a,0)
          assert !m.combat_in_progress?
        end
      end
    end
  end
  
  def test_losers_end_result
    attributes = [:current_health,:current_endurance]
    results = []
    expected_results = [3,4]
    @combat_models.each do |m|
      m.combatants.each do |c|
        attributes.each do |a|
          c.update_attribute(a,0)
          assert_not_nil m.end_result
          results << m.end_result.to_i unless results.include?(m.end_result.to_i)
          c.update_attribute(a,1)
        end
      end
    end
    
    assert_equal expected_results.size, results.size
    expected_results.each do |r|
      assert results.include?(r)
    end
  end
  
  def test_winners_end_result
    attributes = [:current_health,:current_endurance]
    results = []
    expected_results = [1,2]
    @combat_models.each do |m|
      attributes.each do |a|
        m.combatants.each { |c| c.update_attribute(a,0) }
        assert_not_nil m.end_result
        results << m.end_result.to_i unless results.include?(m.end_result.to_i)
      end
    end
    
    assert_equal expected_results.size, results.size
    expected_results.each do |r|
      assert results.include?(r)
    end
  end
  
  def test_strategy_for
    @combat_models.each do |m|
      m.combatants.each do |c|
        m.current_round = 0
        assert_equal c, m.strategy_for(c).combatant
      end
    end
  end
  
  def test_exhaust_combatants
    action = actions(:claw)
    @combat_models.each do |m|
      m.initialize_combat
      action_mock = flexmock(m)
      action_mock.should_receive(:action_for).and_return(action)
      assert_difference ['m.defender.current_endurance','m.attacker.current_endurance'], -action.endurance_cost do      
        m.exhaust_combatants
      end
    end
  end
  
  def test_restore_combatants_condition
    @combat_models.each do |m|
      m.combatants.each do |c|
        c.current_health = (c == m.attacker) ? 1 : 0
      end
      m.restore_combatants_condition
      m.combatants.each do |c|
        next unless c.is_a? Pet
        if (c == m.attacker)
          assert_equal c.health, c.current_health
        else
          assert_equal c.health / 2, c.current_health
        end
      end
    end
  end
end