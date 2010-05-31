class Facebook::LeaderboardsController < Facebook::FacebookController
  def index
    @indefatigable = Leaderboard.indefatigable.first.rankings.first
    @overlords = Leaderboard.overlords.first.rankings.first
    @strongest = Leaderboard.strongest.first.rankings.first
  end
end