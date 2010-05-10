class Hunter < ActiveRecord::Base
  belongs_to :hunt
  belongs_to :pet
end