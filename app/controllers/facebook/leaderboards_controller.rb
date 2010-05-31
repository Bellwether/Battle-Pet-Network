class Facebook::LeaderboardsController < Facebook::FacebookController
  def index
    @indefatigable = Leaderboard.indefatigable.first
    @indefatigable = @indefatigable.rankings.first unless @indefatigable.blank?
    
    @overlords = Leaderboard.overlords.first
    @overlords = @overlords.rankings.first unless @overlords.blank?
    
    @strongest = Leaderboard.strongest.first
    @strongest = @strongest.rankings.first unless @strongest.blank?
  end
end