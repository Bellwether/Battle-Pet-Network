class Inventory < ActiveRecord::Base
  belongs_to :shop
  belongs_to :item
end