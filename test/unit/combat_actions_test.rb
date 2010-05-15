require 'test_helper'

class CombatActionsTest < ActiveSupport::TestCase
  def setup
    @attacker = pets(:siamese)
    @defender = pets(:persian)
  end
  
  def test_action_types
    assert Combat::CombatActions::Resolution.new(@attacker,actions(:slash),@defender,actions(:slash)).both_attacking?
    assert Combat::CombatActions::Resolution.new(@attacker,actions(:dodge),@defender,actions(:dodge)).both_defending?
    assert Combat::CombatActions::Resolution.new(@attacker,actions(:slash),@defender,actions(:dodge)).first_attacking_second?
    assert Combat::CombatActions::Resolution.new(@attacker,actions(:dodge),@defender,actions(:slash)).second_attacking_first?
  end
end