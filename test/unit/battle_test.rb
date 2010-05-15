require 'test_helper'

class BattleTest < ActiveSupport::TestCase
  def setup
    @issued_challenge = challenges(:siamese_burmese_issued)
  end
  
  def test_updates_challenge_status
    mock_combat
    assert_not_equal "resolved", @issued_challenge.status
    battle = @issued_challenge.create_battle(false)
    assert_equal "resolved", @issued_challenge.reload.status, "battle should resolve challenge status"
  end
  
  def test_update_combatant_counters
    mock_combat
    battle = @issued_challenge.build_battle
    battle.attacker.current_health = 0
    battle.defender.current_health = 0    
    assert_difference ['battle.attacker.draws_count','battle.defender.draws_count'], +1 do
      battle.update_combatant_counters
    end
    battle.attacker.current_health = 10
    assert_difference ['battle.attacker.wins_count','battle.defender.loses_count'], +1 do
      battle.update_combatant_counters
    end
  end
end