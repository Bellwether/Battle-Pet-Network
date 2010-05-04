class Occupation < ActiveRecord::Base
  has_many :pets
end