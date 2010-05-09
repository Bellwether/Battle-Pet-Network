class Inventory < ActiveRecord::Base
  belongs_to :shop, :validate => true, :counter_cache => true
  belongs_to :item
end