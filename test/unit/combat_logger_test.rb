require 'test_helper'

class CombatLoggerTest < ActiveSupport::TestCase
  def setup
    @attacker = pets(:siamese)
    @defender = pets(:persian)
    @sentient = sentients(:leper_rat)
    @new_combat_models = [Hunt.new, Battle.new]
    
    @battle = battles(:persian_burmese_resolved_battle)
    @hunt = hunts(:rat_hunt)
    @combat_models = [@hunt,@battle]
  end
  
  def test_set_logs
    @new_combat_models.each do |m|
      assert_equal Combat::CombatLogger::LOG_STRUCT, m.logs
    end
  end
  
  def test_named
    @new_combat_models.each do |m|
      assert_equal @attacker.name, m.named(@attacker)
      assert_equal "the #{@sentient.name.downcase}", m.named(@sentient)
    end
  end
  
  def test_log_advancement
    @combat_models.each do |m|
      m.combatants.each do |c|  
        next unless c.is_a? Pet
        key = (c == m.attacker) ? :attacker_awards : :defender_awards
        log = m.log_advancement(c)
        assert_equal log, m.logs[key][:experience].last
      end
    end
  end
  
  def test_log_outcome
    @combat_models.each do |m|
      m.combatants.each do |c|
        [:current_health,:current_endurance].each do |a|
          c.send("#{a}=",0)
          log = m.log_outcome
          assert_not_nil log
          assert_equal log, m.logs[:outcome]
          c.send("#{a}=",10)
        end
      end
    end
  end
end