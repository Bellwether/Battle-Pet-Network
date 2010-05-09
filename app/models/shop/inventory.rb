class Inventory < ActiveRecord::Base
  belongs_to :shop, :validate => true, :counter_cache => true
  belongs_to :item
  
  cattr_reader :per_page
  @@per_page = 12
end