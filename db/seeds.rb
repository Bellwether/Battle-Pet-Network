require 'active_record/fixtures'  

Fixtures.create_fixtures("#{Rails.root}/db/fixtures", "species") if Species.count == 0
Fixtures.create_fixtures("#{Rails.root}/db/fixtures", "breeds") if Breed.count == 0