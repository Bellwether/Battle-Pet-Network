class Shop < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  
  belongs_to :pet, :include => [:breed]
  has_many :inventories
    
  named_scope :include_pet, :include => [:pet]
  named_scope :has_item_named, lambda { |name|
    {
      :conditions => ["items.name LIKE ?", "%#{name}%"],
      :joins => ["INNER JOIN inventories ON inventories.shop_id = shops.id \
                  INNER JOIN items ON items.id = inventories.item_id"]
    }
  }
  named_scope :has_type_in_stock, lambda { |item_type| 
    { 
      :conditions => ["items.item_type = ?", item_type],
      :joins => ["INNER JOIN inventories ON inventories.shop_id = shops.id \
                  INNER JOIN items ON items.id = inventories.item_id" ]
    }
  }
  
  cattr_reader :per_page
  @@per_page = 20
  
  def last_restock
    last_restock_at ? "#{time_ago_in_words(last_restock_at)} ago" : "unstocked"
  end
end