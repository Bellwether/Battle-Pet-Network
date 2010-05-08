class Spoil < ActiveRecord::Base
  belongs_to :pack
  belongs_to :item
  belongs_to :pet
end