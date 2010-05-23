namespace :bpn do
  namespace :leadboards do
    desc "Update leaderboards with new rankings"
    task(:rank => :environment) do
      Leaderboard.create_rankings
    end
  end
end