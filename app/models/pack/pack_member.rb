class PackMember < ActiveRecord::Base
  belongs_to :pet
  belongs_to :pack
end