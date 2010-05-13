require 'test_helper'

class BattleTest < ActiveSupport::TestCase
  def setup
    @issued_challenge = challenges(:siamese_burmese_issued)
  end
  
  def test_updates_challenge_status
    assert_not_equal "resolved", @issued_challenge.status
    battle = @issued_challenge.create_battle(false)
    assert_equal "resolved", @issued_challenge.reload.status, "battle should resolve challenge status"
  end
end