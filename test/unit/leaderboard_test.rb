require 'test_helper'

class LeaderboardTest < ActiveSupport::TestCase
  def setup
    @rank = nil
  end
  
  def test_rankables_for_indefatigable
    rankables = Leaderboard.rankables_for_indefatigable
    rankables.each do |pet|
      sql = "#{pet.id} IN (attacker_id, defender_id) AND challenges.#{Leaderboard::SQL_RECENT}"
      new_rank = Challenge.count(:conditions => sql)
      @rank ||= new_rank
      assert_operator new_rank, "<=", @rank
      @rank = new_rank
    end
  end
  
  def test_rankables_for_overlords
    rankables, ranking = Leaderboard.rankables_for_overlords
    rankables.each do |pet|
      assert_equal "active", pet.status
      assert_operator pet.user.last_login_at, ">=", Time.now - 1.week
    end
  end
  
  def test_rankables_for_strongest
    rankables = Leaderboard.rankables_for_strongest
    last_wins = 0
    rankables.each do |pet|
      count = Battle.count(:conditions => "winner_id = #{pet.id}")
      assert_operator count, ">=", last_wins
    end
  end
  
  def test_rank_indefatigable
    leaderboard = Leaderboard.indefatigable.first
    assert_difference ['leaderboard.rankings.count','Ranking.count'], +1 do    
      assert_difference ['Rank.count'], +Leaderboard.rankables_for_indefatigable.size do
        Leaderboard.rank_indefatigable
      end
    end
  end

  def test_rank_strongest
    leaderboard = Leaderboard.strongest.first
    assert_difference ['leaderboard.rankings.count','Ranking.count'], +1 do    
      assert_difference ['Rank.count'], +Leaderboard.rankables_for_strongest.size do
        Leaderboard.rank_strongest
      end
    end
  end
end