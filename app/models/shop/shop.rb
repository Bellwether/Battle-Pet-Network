class Shop < ActiveRecord::Base
  belongs_to :pet, :include => [:breed]
  has_many :inventories
  
  named_scope :include_pet, :include => [:pet]
  named_scope :has_type_in_stock, lambda { |item_type| 
    { 
      :conditions => ["item.item_type = ?", item_type],
      :joins => ["RIGHT INNER JOIN inventories ON inventories.shop_id = shop.id RIGHT INNER JOIN items ON items.id = inventories.item_id AND items.item_type IN (?)", item_type]
    }
  }
  
  cattr_reader :per_page
  @@per_page = 20
end