require 'test_helper'

class LeaderboardTest < ActiveSupport::TestCase
  def setup
    @rank = nil
  end
  
  def test_rankables_for_indefatigable
    rankables = Leaderboard.rankables_for :indefatigable
    rankables.each do |pet|
      sql = "#{pet.id} IN (attacker_id, defender_id) AND challenges.#{Leaderboard::SQL_RECENT}"
      new_rank = Challenge.count(:conditions => sql)
      @rank ||= new_rank
      assert_operator new_rank, "<=", @rank
      @rank = new_rank
    end
  end
  
  def test_rankables_for_overlords
    rankables = Leaderboard.rankables_for :overlords
    rankables.each do |pet|
      assert_equal "active", pet.status
      assert_operator pet.user.last_login_at, ">=", Time.now - 1.week
    end
  end
  
  def test_rankables_for_strongest
    rankables = Leaderboard.rankables_for :strongest
    last_wins = 0
    rankables.each do |pet|
      count = Battle.count(:conditions => "winner_id = #{pet.id}")
      assert_operator count, ">=", last_wins
    end
  end
end