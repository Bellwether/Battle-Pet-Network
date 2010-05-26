namespace :bpn do
  namespace :packs do
    desc "Recover pet endurance levels for active pack members"
    task(:recover => :environment) do
      Pack.recover!
    end
  end
end