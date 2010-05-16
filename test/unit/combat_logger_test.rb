require 'test_helper'

class CombatLoggerTest < ActiveSupport::TestCase
  def setup
    @attacker = pets(:siamese)
    @defender = pets(:persian)
    @sentient = sentients(:leper_rat)
    @new_combat_models = [Hunt.new, Battle.new]
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
end