class Shop < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  
  SPECIALTIES = ['Food', 'Kibble', 'Toy', 'Collar', 'Claws', 'Sensors', 'Ornament', 'Mantle', 'Charm', 'Standard']
    
  belongs_to :pet, :include => [:breed]
  has_many :inventories, :validate => true
  
  validates_presence_of :pet_id, :name, :status, :specialty, :inventories_count
  validates_length_of :name, :in => 3..128
  validates_inclusion_of :specialty, :in => SPECIALTIES
      
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
  
  validate :validates_max_inventory  
  
  def after_initialize(*args)
    self.status ||= 'active'
    self.inventories_count ||= 0
  end
  
  def validates_max_inventory
    errors.add_to_base("shopkeeping ability too low for that much inventory") if inventories.size > max_inventory
  end
  
  def max_inventory
    pet ? pet.intelligence : 0
  end
  
  def last_restock
    last_restock_at ? "#{time_ago_in_words(last_restock_at)} ago" : "unstocked"
  end
end