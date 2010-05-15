require 'test_helper'

class CombatTest < ActiveSupport::TestCase
  def setup
    @battle = battles(:persian_burmese_resolved_battle)
    @hunt = hunts(:rat_hunt)
    @combat_models = [@hunt,@battle]
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
end