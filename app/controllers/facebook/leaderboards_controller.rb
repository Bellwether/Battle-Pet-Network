class Facebook::LeaderboardsController < Facebook::FacebookController
  def index
    @indefatigable = Leaderboard.indefatigable.first
    @overlords = Leaderboard.overlords.first
    @strongest = Leaderboard.strongest.first
  end
end