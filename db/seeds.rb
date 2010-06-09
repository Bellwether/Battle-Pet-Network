require 'active_record/fixtures'  

[Occupation,Species,Breed,Level,Human,Sentient,Item,Action,Strategy,Maneuver,Leaderboard,User,Pet,Shop,Belonging,Forum,ForumTopic,ForumPost].each do |klass|
  Fixtures.create_fixtures("#{Rails.root}/db/fixtures", klass.table_name) if klass.count == 0
end