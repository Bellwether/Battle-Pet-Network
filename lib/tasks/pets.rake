namespace :bpn do
  namespace :pest do
    desc "Recover pet endurance and health levels"
    task(:recover => :environment) do
      Pet.recover!
    end
  end
end